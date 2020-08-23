import { HttpClientService } from './HttpClientService';

export class OpenViduService {

    private httpClientService: HttpClientService;

	constructor(){
        this.httpClientService = new HttpClientService();
    }

	public async createSession(sessionId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
        const url = openviduUrl + '/api/sessions';
        console.log("Solicitud de sesion ", url);
        const body: string = JSON.stringify({ customSessionId: sessionId});

        return await this.httpClientService.post(body, url, openviduSecret);
	}

	public async createToken(sessionId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
		const url = openviduUrl + '/api/tokens';
        console.log("Solicitud de token ", url);
        const body: string = JSON.stringify({ session: sessionId });

        return await this.httpClientService.post(body, url, openviduSecret);
    }
}