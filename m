Return-Path: <netdev+bounces-4682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4C570DD9F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F3E71C20D55
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D571EA79;
	Tue, 23 May 2023 13:39:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1436FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:39:43 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A1E9;
	Tue, 23 May 2023 06:39:40 -0700 (PDT)
Received: from 104.47.11.170_.trendmicro.com (unknown [172.21.166.90])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 2A3781000049E;
	Tue, 23 May 2023 13:39:39 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1684849178.545000
X-TM-MAIL-UUID: beb0dca7-dbbd-4b46-b987-465df8710ee6
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.170])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 8534510005E00;
	Tue, 23 May 2023 13:39:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fm+q7+Q4erCkjxZLYkt4tjiCYiCqxA0XrwenNCxeXbUM2kCT5s/ev3NQyj0RjuBkJ2e6Blq9k+RpdC58vM/Gp8Oi50h8tBbjeTDuK8McK1n0P6Fg4VCUibt9aSoNfqVSHkFq8sJZnydxcJUZd7R6zly06V60L2hdFOBzeGG5fa7ni7VqP7Qz3TvT3lmc3F7o4CU9DoDgTYkk68zSOBjkmfRt5+iwFYo/mUMK6k+/NdTkBQJRUKoTEc5saKaScRxo4n99J8xydrRlZZevzIvl7gQjkwviCgelYCwdMXCgqnM8DtkAUADW09bOwVj2ltibTc4V6vRUDhEbCymDoSSEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bo11vxuJgJMv1TQAXZbwLc1EH7Z+aRCIgDNov+e8AFw=;
 b=fjfBlRFgRZkXQ4q28OtQve5SAglxDADvdQ0nmj1m2X5Ztj4PEqA+PHAd6xyzCch4dbrgM5QUbc4Wha/5sc3QE+HIuIb+/RP5z0/blFEmA0boJxiUKdahQ4Qxi2GCx4gTuCDsBBAm9CHsBjpbARg3pJhA2CXaZdc6K9A56vs231lCUoxPwqjfLHD8Oir2cd2rHmY7ztwprECOP+JkcOcBbG+/rApCuSRNdaLPlQlXt1z9yE1vKEy1lgSKzonPhb1QawqdFyR1WXI0HV81mCoMYepHIlM3QnVK1C1sJOlaLjY59o6EdnY2x+dFowwbUj4puGX3lSrF7Y+6Yh0yylvtzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <12d27b94-27c3-00fc-4030-0a0941a0b17f@opensynergy.com>
Date: Tue, 23 May 2023 15:39:35 +0200
From: Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
To: Vincent Mailhol <vincent.mailhol@gmail.com>
Cc: Arnd Bergmann <arnd@kernel.org>,
 Mikhail Golubev <Mikhail.Golubev@opensynergy.com>,
 Harald Mommer <hmo@opensynergy.com>, virtio-dev@lists.oasis-open.org,
 linux-can@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
 linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
 Stratos Mailing List <stratos-dev@op-lists.linaro.org>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
 <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com>
 <ed2d2ea7-4a8c-4616-bca4-c78e6f260ba9@app.fastmail.com>
 <CAMZ6Rq+RjOHaGx-7GLsj-PNAcHd=nGd=JERddqw4FWbNN3sAXA@mail.gmail.com>
 <9bdba1e2-9d1f-72b3-8793-24851c11e953@opensynergy.com>
 <CAMZ6RqKfdBio3cnH+FpeCwasoVNBZ3x55FiM+BpgrurKkT8aHg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAMZ6RqKfdBio3cnH+FpeCwasoVNBZ3x55FiM+BpgrurKkT8aHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0198.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::35) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|BE1P281MB2755:EE_
X-MS-Office365-Filtering-Correlation-Id: 86120b1c-ac22-45dd-27db-08db5b932698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aLWA52WZKUudVbNaRkMO7fGX53pj3NmBGD7jxgFKJqNOGhK06AAbQ+ziD/F9BIQAXwjJi/eqSHN0F8rPvYWLAs5/ULrp/5DJAR3T/ksa66JtSBBfwBjvE4X+T/xqtJsvKLgLO5tQRS/zkIF7YSJ9oHAsYWr9HmfkZfyiwtcpKRJ/uQnDJZFxgr2f/So5Z2Y6lnHumOpG1dxqgcPIEGX8mQytDCHwqc2T1ImI2B2feNImWUIttsyxigexSeOxoFz6jg5VyPu6QbB8fGjvLrSIh1ZtPD99TONlRA/5T2klWMjQjPiOFDqEnPvIWBQKx/6xGArLn4H6dyT6sEEnktKJTFSCy0XBqFcJ00NGyhmQfzsbM5ltFctOC5U+4QZUf2qngGrRDWr7fRP/J5TqA8kCosfVwMGu/tk/Fm8Px+ENdrxj6Yz7l5EDRwDGzgodI6CgGDFntcJ/xUj5fw7v7ops7SQtil+eESavMCClxl6OjYgJybWz+8+guWu+lJ76ZnTUp63ERdc6fv61304ujaZc6hmU7T+a9obmkHbt5KKaMLc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(376002)(396003)(366004)(136003)(346002)(451199021)(26005)(7416002)(44832011)(83380400001)(2616005)(186003)(53546011)(2906002)(36756003)(6916009)(4326008)(66476007)(316002)(66556008)(66946007)(38100700002)(41300700001)(31696002)(54906003)(42186006)(478600001)(86362001)(31686004)(8936002)(8676002)(66899021)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Skh6UHBxNzBKMjhTSE16WGVzeXg4OWt6cVpLdGNyOXl6RDFXa1R1dGFBQ2Fj?=
 =?utf-8?B?ckxrNEgwdHFWeHlFdStDYkQxbFhlSlBCL0xjemhoVG9pejRHMlJsQ0Fka2xq?=
 =?utf-8?B?M3B4bE15NzdNQ1pCNkMvNm84VlIvamNzS3J6WE9WMEFrcWdtcndmVFdMa3Jz?=
 =?utf-8?B?NlVXSGQ2KzFmQ1BNOHY1VXFSelUxNnYzYnVBKzBVQTQvcmt4WGdWV0pnakZF?=
 =?utf-8?B?TkpjV2pweHZMNklhRFgzUllvdGEyYWlDdHlNYnpBUkxORzd3Umt3RmY0SElU?=
 =?utf-8?B?ZXBFNEc0d01wS0tLWW9mTnBNSGZhdHE4UmQweU1pcEVmWDI3V20rSXVHOUp6?=
 =?utf-8?B?RW0wUWM5OFBQenROZzVBOFdXNjJVMzNuVnYwTnNka2xUUGRQRXBZY21wZXBo?=
 =?utf-8?B?QnRBZkFkR29ia0xOazRpYk12cWRyZXI5bUtuZndsSkY0cUVwWlpWREw4eUYx?=
 =?utf-8?B?dTBsZkt0akplaHA1bDNsWFQ2dStnZVI5WUVzM014R3JKa1Mvejc2OHZvMlVl?=
 =?utf-8?B?Si9IWXQwaWR6bTJSaVQ0WlBRT3B3SURCbjFGTmVkTUtZa1JUdXVuRGNDZHdD?=
 =?utf-8?B?SGptYkZ2ZFZrYWpiMlYzczBKd1h0aDN5Y1A0TkgwdWo5L2t1azR6Zitva1JV?=
 =?utf-8?B?T2NPbEtSVGwwbXhCTS9yWGhadm90NSs0RDF0RjBvYVNGWlpKN0JtSlJ4bXBV?=
 =?utf-8?B?VU54ejZ3cWsxSDluUEpRV21zbXIwZUNyRlQ5b0w1VFEwN3E0aHc0NFV4K2J3?=
 =?utf-8?B?WTI4anUxeXFRS0JlSm5TUGdZcHczRzFUc0RsYStDNHlzeVRiMThQZjJHMkVk?=
 =?utf-8?B?cStiMTJkTU5DMWdLRHl5UlFvVEZPTWNTdUJ4U2dobG1KTGp6QTJteUZ5bUVU?=
 =?utf-8?B?V0tCMWdEd1hEcmZ4cGpGcCtkclcxTGxOMmZ2RGZWNVZFV1dDUFJTckxDU3Mz?=
 =?utf-8?B?akpzWU9BamdmRFlsMlNrWHRsWlJnOExQejcyMDFMRkY2Wnh3aVQrbjZMSGRU?=
 =?utf-8?B?NVlSaGYyald5d0lEdVBDZnlCTnc5bXpkeldjMkJxemVSSUlPbFRtM1dGcnQ4?=
 =?utf-8?B?SkJld1l4SGFEaG5RWlJhTzhFejhUUnJuVWNIV3I2cUw0Y2lTSkwzbExjMEhO?=
 =?utf-8?B?RFk0M0tCRGc5MklnWTh5bWxNSkI5VDZHWkNJUVZzS3doOUJGTjFoQ3V2MXB4?=
 =?utf-8?B?YjZYSklpNzRrRVQzNmlQdTF3cVZMNm9kU1hRSjBPbXdLdWQ2KytYNDlkNG91?=
 =?utf-8?B?QmlSampFcTBnZEd5S1h5ZnpKazdNZFplMGZVMlZGNm16Yk1JdnlhbXJ0UzhK?=
 =?utf-8?B?S1RiUUdXV0V6ZTNoeHhuQi9GQzh4QVJsTU1wTERRc0RSVktQbkRQWGZ5UEsw?=
 =?utf-8?B?U3pTUHZOSjdPa3ZqYkpRN0Q3Y3ZZTUt1QTgrRHA2SXhJR0xWTjhZOU9XREU3?=
 =?utf-8?B?TUp0QmU2b3FOQmNrUnNUbTRSZUFSdTBIUGVYT2RvYWppdTBJaDhnQ1YyNkFh?=
 =?utf-8?B?ckEyLzd0VDU0cTFCRjZOczNtTGUrcWllTU0zZ3cyVFhBMHlHRnRBOG8rZDI5?=
 =?utf-8?B?R0R3MzFCck9OMm5INnlCSTE0L05jczZONVRReDQySHRwVlUrYi9YUDBrd3FE?=
 =?utf-8?B?Yk80MVpoYjdZNDk4MzhFZ01rK3lzRU5xSjZGVGJjdUEwZHBxSmtMakpVRVYx?=
 =?utf-8?B?K0lYVGZGaVVqWlpKbWV6TTNkd05ZQzVxZUVxSUxOdy9HZStMUTZLbHVNMFlp?=
 =?utf-8?B?MUpvSnNLUHN3UUJ0TlIvNlBRbW05ajZPY1ZXK1RQeWxTOFU1a0tOQlpCSGxq?=
 =?utf-8?B?Q0Fpa1pONGQzbnFMaHBNaUJtYTRMaW9EQ1VtczFQUFo2enJoWkl6eUdFWXRK?=
 =?utf-8?B?NjRITjZXSS9LM2NWenJHcTVwY1ZFdS9XUUd0N0NKSkEvbVdoZjdUV3loU3hy?=
 =?utf-8?B?eEJtNGpSelJtUXNqd1hNRU5CdkthMjduc01seVhZZ3NWMDJ5em81UWw1dlJN?=
 =?utf-8?B?OE5EWkVnTlpaL29RMDFWSWNhdkRDY3lTRytWTmxWRGhVWnZLYlZoSVJDczdk?=
 =?utf-8?B?ODFTOTNyZXZ5aERrdGlSU25Ya0s1QjRZazR2RURVa2htTWQvTnJ2SjNZNTQr?=
 =?utf-8?Q?FLHhDZ1ewUpIxjn4K3EpLfy0b?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86120b1c-ac22-45dd-27db-08db5b932698
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 13:39:37.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dX45kjMdAThy4GuHCwNcOt/reUV7kdP0xP7pnpetje8FgUo4/uHDerU4rF56XphoxBmdDgZuCYkjCfRzM9Lt5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2755
X-TM-AS-ERS: 104.47.11.170-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27646.000
X-TMASE-Result: 10--34.545800-4.000000
X-TMASE-MatchedRID: hwsFDxVJcFkMek0ClnpVp/HkpkyUphL91WzGAcKOrqOWwuVcTMXFdGlF
	7OhYLlctxfyJC8c9bfMKVHmngcHCMJuvQFoaPOspF63b38RTfu+iGsyrScSFB7x5bin9f3K6O4d
	dIrW9yRVdf0oKhHHHddimFujA5p4DMWaDVk6hcbkapIb9znReA1EwSDwOevUhLlKcC0fi2On2wV
	qcxIeACuk1VIbVhAZv7CBlww5eFoZHMehuZse+zhHJWwDGGGOswB8CBqAcJuUEea0f881wgUGzU
	7CKX1sd4lufU2TxHK753iqanE6wygjt4l5TmF6fv8fLAX0P50CXqCWexXV0L3ROxyHvZdJsXjeI
	3I6c4UFh/7vLrkOO2eQi15pCPz5y4acyaNVQ+eMF7cpFXK76TWUfjhTZG7XacfnL37UR/jqhOWf
	zrY0HOa267pjFKBP/rtBupzUt4jzINUBYpHy9LTOgNHhlU7YMyiKgKtIyB4qdkHRvBVgJZoRMyN
	/ppM4nb0fmCWHRknHf+GBs5/vlPpGxVOLhpZHWhjlBjwpom1PVBDonH99+Vi0dCVIQSitSQc7xr
	bH7/9HkizndBEr04YU3rW+IhSE8QLBrHsp/dPO/QNwZdfw3FY5A6wTicMJ0ctZudseHPS38191l
	vAtzOW/gGDdn7Df57weYwzhvAp+FxmnVS90dVZeZUDMyphfSQuLGuwInWNMCGfvnVpx+2732USt
	usyaI6BzqZfWXA0dftuJwrFEhTbew1twePJJBFhMKYff+mUv6C0ePs7A07YVH0dq7wY7up8Odl1
	VwpCSUTGVAhB5EbQ==
X-TMASE-XGENCLOUD: 95ef448b-828f-44f6-84b2-e58dbd89de1e-0-0-200-0
X-TM-Deliver-Signature: 3BD702C4D114DFA2FA739626427AAA65
X-TM-Addin-Auth: sevHVf8TXHba2kHrgTb6r8jd5ny8xP9TTEea86iSbhf2urEYtwJnErb5oMf
	yplNLFY1JsWLP0UnyLKlzyp6cxbOb+00asltPvENb8nlt8SZKWSiLsSyJbEd05Far2xXhteaYlF
	iYlW25hC4d+m7AwXxmztYfxSIZn8TJipZJI3zqyfYGZh302yMh6OmoBRQ5qiLsOKY4sy3AIBdx7
	Gu5BALYz3antDlzqH5kpqeCs0UIkc9tDEk4my1ObmkHbi9YcVZmIcEgsn4bU1tN2WQ3W1mWyBh9
	LB2HlGR9KS1+miE=.M2fvdfhusNFcRT3D8o7oPNtF5CgOIg4Rm9sX+4710S/m1NFhJk8HvkVCs2
	bcbytn12k+YjqZym+YKlx3FUee31nJC0a3m2h1RPpU7Dl/w570anoVKw6yLfB3LzRH6yiYReUC1
	v+X0Yc3Asq5qPIE4jNd2cZNHeMpexunG2XBAoVJqUj84ZMkF2sBlr5xbWFgf/WUX4zMlXEsxc5n
	6YC3VW5gWBsh0cqeEUlaWVHnlJ9BzvReeUfVt89OWzKkptq0yDZt3GUrt5gofim9EqvQzq0kDqQ
	eRLpGD3H33HZzVbwnUy8AmC0A7yH6uF0mxY7or75KEcaBTew+ADQzNObZwg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1684849179;
	bh=6Nm4K61u0GFP61tbsDzzcuWpBPAUFjcD4XkmyImYu5I=; l=7931;
	h=Date:From:To;
	b=TRec9De28YomgQ9hU1/cLIrZlFuhotjWFFbkN5so6RP0NyPwCzt5aMAnM4EnNrhjX
	 qdl51/WbfgCdgmuKpTZHbiTM1JsGLQxOIwvgmmGd1XeJvp+Y1gasRO7rvtiKbyoQdS
	 yIJ4G9xICz4wqcKKVIJA6KBg8xunwhlGIH9mdLidSGVq21zxFK5jFd07/+q7VN00wb
	 mKV8jmSM/FG/vIWik25gL9358uPO/JrAXoLGxn4Jgm9/zgHlutjS1whataMcN5my/Z
	 9/GLxMOWe48t8VfvO45/f4u5wp1AS76xpGMtvCaEqN0HVhDcSuBc7AIJ4bT/nQDAEP
	 28UZbWczLaVjQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vincent,

On 15.05.23 07:58, Vincent Mailhol wrote:
> Hi Harald,
>
> On Fri. 12 May 2023 at 22:19, Harald Mommer
> <harald.mommer@opensynergy.com>  wrote:
>> Hello Vincent,
>>
>> searched for the old E-Mail, this was one of that which slipped through.
>> Too much of those.
>>
>> On 05.11.22 10:21, Vincent Mailhol wrote:
>>> On Fry. 4 nov. 2022 at 20:13, Arnd Bergmann<arnd@kernel.org>  wrote:
>>>> On Thu, Nov 3, 2022, at 13:26, Harald Mommer wrote:
>>>>> On 25.08.22 20:21, Arnd Bergmann wrote:
>>>> ...
>>>>> The messages are not necessarily processed in sequence by the CAN stack.
>>>>> CAN is priority based. The lower the CAN ID the higher the priority. So
>>>>> a message with CAN ID 0x100 can surpass a message with ID 0x123 if the
>>>>> hardware is not just simple basic CAN controller using a single TX
>>>>> mailbox with a FIFO queue on top of it.
>>> Really? I acknowledge that it is priority based *on the bus*, i.e. if
>>> two devices A and B on the same bus try to send CAN ID 0x100 and 0x123
>>> at the same time, then device A will win the CAN arbitration.
>>> However, I am not aware of any devices which reorder their own stack
>>> according to the CAN IDs. If I first send CAN ID 0x123 and then ID
>>> 0x100 on the device stack, 0x123 would still go out first, right?
>> The CAN hardware may be a basic CAN hardware: Single mailbox only with a
>> TX FIFO on top of this.
>>
>> No reordering takes place, the CAN hardware will try to arbitrate the
>> CAN bus with a low priority CAN message (big CAN ID) while some high
>> priority CAN message (small CAN ID) is waiting in the FIFO. This is
>> called "internal priority inversion", a property of basic CAN hardware.
>> A basic CAN hardware does exactly what you describe.
>>
>> Should be the FIFO in software it's a bad idea to try to improve this
>> doing some software sorting, the processing time needed is likely to
>> make things even worse. Therefore no software does this or at least it's
>> not recommended to do this.
>>
>> But the hardware may also be a better one. No FIFO but a lot of TX
>> mailboxes. A full CAN hardware tries to arbitrate the bus using the
>> highest priority waiting CAN message considering all hardware TX
>> mailboxes. Such a better (full CAN) hardware does not cause "internal
>> priority inversion" but tries to arbitrate the bus in the correct order
>> given by the message IDs.
>>
>> We don't know about the actually used CAN hardware and how it's used on
>> this level we are with our virtio can device. We are using SocketCAN, no
>> information about the properties of the underlying hardware is provided
>> at some API. May be basic CAN using a FIFO and a single TX mailbox or
>> full CAN using a lot of TX mailboxes in parallel.
>>
>> On the bus it's guaranteed always that the sender with the lowest CAN ID
>> winds regardless which hardware is used, the only difference is whether
>> we have "internal priority inversion" or not.
>>
>> If I look at the CAN stack = Software + hardware (and not only software)
>> it's correct: The hardware device may re-order if it's a better (full
>> CAN) one and thus the actual sending on the bus is not done in the same
>> sequence as the messages were provided internally (e.g. at some socket).
> OK. Thanks for the clarification.
>
> So, you are using scatterlist to be able to interface with the
> different CAN mailboxes. But then, it means that all the heuristics to
> manage those mailboxes are done in the virtio host.

There is some heuristic when VIRTIO_CAN_F_LATE_TX_ACK is supported on 
the device side. The feature means that the host marks a TX message as 
done not at the moment when it's scheduled for sending but when it has 
been really sent on the bus.

To do that SocketCAN needs to be configured to receive it's own sent 
message. On RX the device identifies the message which has been sent on 
the bus. The heuristic is going through the list of pending messages, 
check CAN ID and payload and mark the respective message as done.

Problem with SocketCAN: There is a load case (full sending without any 
delay in both directions) where it seems that own sent messages are 
getting lost in the software stack. Thus we get in a state where the 
list of pending messages gets full and TX gets stuck.

The feature flag is not offered in the open source device, it is only 
experimental in our proprietary device and normally disabled.

Without this feature there is no heuristic, just send to SocketCAN and 
put immediately as used (done). But for an AUTOSAR CAN driver this means 
CanIf_TxConfirmation() came too early, not late when the message "has 
been transmitted on the CAN network" but already earlier when the 
message is put to SocketCAN scheduled for transmission.

> Did you consider exposing the number of supported mailboxes as a
> configuration parameter and let the virtio guest manage these? In
> Linux, it is supported since below commit:
>
>    commit 038709071328 ("can: dev: enable multi-queue for SocketCAN devices")
>    Link:https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fgit.kernel.org%2ftorvalds%2fc%2f038709071328&umid=67080c1c-b5d1-4d20-a9eb-ab7f9a062932&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-9ae22f0c43ab3effc4ba0f9fd0327c9852d5d05a
>
> Generally, from a design perspective, isn't it better to make the
> virtio host as dumb as possible and let the host do the management?

I was not aware of this patch.

But thought about different priorities. 2 priorities, low priority for 
CAN messages which may go into some FIFO suffering priority inversion 
and high priority for CAN messages going to mailboxes. The very first 
draft specification had this not knowing about some restrictions in the 
Linux environment. It had the number of places for each priority (low: 
FIFO places, high: mailboxes) in the config space. Everything going into 
a single TX queue but with some priority field. Got the comment on the 
list to use a dedicated queue for high priority messages instead of 
using a priority field in the message itself.

It would be easy to do if there was an AUTOSAR CAN driver used as back 
end, in this case you configure it and know the capabilities and 
configuration.

But looking into for example m_can.c the information is not available. 
Checked now again.

=> The information about underlying hardware properties is not available 
outside the CAN driver

And I also looked now into the patch you sent:

dev.h:

#define alloc_candev(sizeof_priv, echo_skb_max) \
     alloc_candev_mqs(sizeof_priv, echo_skb_max, 1, 1)
#define alloc_candev_mq(sizeof_priv, echo_skb_max, count) \
     alloc_candev_mqs(sizeof_priv, echo_skb_max, count, count)

=> Every single driver uses alloc_candev(), none uses alloc_candev_mq(). 
So the patch which came in already 2018 is still an offering which is 
not used at all.

To have multiple priorities with queues we needed a way in user land

- to determine the number of queues (priorities)
- to address the queues
- to determine the number of resources behind each queue for flow 
control purposes
- to determine the nature of the queue (basic CAN FIFO with n places or 
full CAN queue with m mailboxes)

There is nothing of this in place.

=> We are currently not in the position to support different priority 
queues in Linux.

BTW: Even then we would probably need the heuristic on the device side 
when VIRTIO_CAN_F_LATE_TX_ACK is negotiated. I don't think it was a good 
idea to use 1 queue for basic CAN and m queues for m full CAN mailboxes, 
probably it was better to have a low priority queue and a high priority 
queue. But as there is nothing in place currently beside this patch you 
mentioned this is an issue to think about in the future.

Regards
Harald


