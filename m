Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E241DA6D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349299AbhI3NC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:02:27 -0400
Received: from mail-eopbgr150138.outbound.protection.outlook.com ([40.107.15.138]:17892
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349165AbhI3NC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UERV1IYcMsk6hksNmJ/aux+07YdC7Wo+ygQXkjHPN3ENmUUrqoFtp8Uc/OMdWpJ7LAn7D7VKyLMz2udWTwU30QVGwVLLdYVQbhUPLSKXGZ7IpOVU/WsfoC0GojcYup+DqF+YmykU0ewYtg8cN34GS2kgOedRhnu3JostWrImvFUP+Qy0LohZ/GMQxb6rQKyuEc4BdedqqppTRllsyHJe/oGXwyGtBnMYOtvk5ZeqvZ/EZY7AWmySoY7h/fnfVY2SOaTTr0ne9y3yyAF4kLNZYmpcTVI413gZVZKW5AoFovlo1ybSK5kTuuhLXnikYBy4F/zNOO+SQEyO1ZHqScAWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5J/Gg1ndtz4sSl7YerPtNW1//TP/7Rv96hnlor/vTRI=;
 b=Bvpe5QWKu1/v7itLY4Rhy2+f8ZT7gXPec9tcT4TFzHTbNjwQRewN5zbpV34hJOcBa9V7/pacswHlGEQ3M3hEIjgbQHWO8pxtGupNLbGaNFYicDGiMj+wgN/7QyNcyaAOaqK7ETPAVqmOQbebMTJMnMdZnVtIACW/Z2otZEXC9FmN37MQOG6zKYF/NiE8WXZDjcbPhfmPx7cpVHSLPHPSDmvpdCV5WJCc9FNbaS+VGPZrZCOCgJwzsXGW+aOgXAl23eb/wDTB6xrYPhfDK3ERwaDVBpSbLoUe5mQYPKWsyD70sTxDU2GRiHU6iPfzl7NSaBj/tnnsNhQeM+fWQ5mwTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J/Gg1ndtz4sSl7YerPtNW1//TP/7Rv96hnlor/vTRI=;
 b=BYIS/iqAnCVOYsi6rEE6TQx8/B5O2taL+d+aCKz/2nmyDeiGGMo6NJF2ib9FGuW1fJnod6Lizylz5gRJawO8dtIGgJQxRrzssRiJpr6oWpCKj9HGjWp/bli7RnWuDixKKcjYmEz0zjxN1HxTcWzxEA9ea8JnQ501YbZlQ3uKz5I=
Authentication-Results: fris.de; dkim=none (message not signed)
 header.d=none;fris.de; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4436.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:271::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 13:00:40 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 13:00:40 +0000
Message-ID: <c52ca248-f555-e5a7-4fb8-f6efdc06e6c6@kontron.de>
Date:   Thu, 30 Sep 2021 15:00:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 2/3] dt-bindings: net: phy: mscc: vsc8531: Add LED mode
 combine disable property
Content-Language: en-US
To:     Frieder Schrempf <frieder@fris.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Cc:     Baisheng Gao <gaobaisheng@bonc.com.cn>,
        Rob Herring <robh@kernel.org>
References: <20210930125747.2511954-1-frieder@fris.de>
 <20210930125747.2511954-2-frieder@fris.de>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20210930125747.2511954-2-frieder@fris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0111.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::8) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.40] (89.247.44.207) by AM0PR02CA0111.eurprd02.prod.outlook.com (2603:10a6:20b:28c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Thu, 30 Sep 2021 13:00:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2247940-95f3-48c6-f76f-08d984124dee
X-MS-TrafficTypeDiagnostic: AM9PR10MB4436:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4436E8F402791E5F288E9EFDE9AA9@AM9PR10MB4436.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+F1FUtZLdvfhGJF7c/BmL3I38NykGEVD9pbWEMmmkiX67yA13Qb9JNlCXsGQaoW2ildZo6sGweyTA+yyObPRvgD4IMvRgMiWSfYuedFUu1JtoxlnR7eCmXjkflnOCiNb/sMCcaapSYk085VyPDEpVyunh1vLP36e0NvePdufRqSzVhTIMpVdinQ6oxOQXIfokgbzSEmBScJMeiF3JVyzBO/0VHmkAE9YOS9MixXZDwQ4HFJWqr08h/tbZQnHB/5SuUJgn/rVi/nWEfM7pfopM28U1oYk9nZo9igdZ18DyO06TO3CPtfsOKpTQZ/oQr4swOfxu3RdYfkgJTdogZWZ/vmVRbhqtR9yioqbIj3FGv9+X7ICQ2wSj3DEWaa646QTwbxO867pkuaHXM4zoXdrz7Ed+Ffnw51s5UKyjLabWSVgp+NswCCjNyTvoQqRYxB4tHFkJcvQhpuRznRGdVHOUkeBFXJplbsYMnjQHrQumlZw8wmSMYHbONYs5phlUGplg77siTZpYxJCCt2n1zYna274XuK6+Tuo0CXLEoWTYEeJmZT3u70NxDIiDkuzzqmIjiMXjED0fCKwlM/uHqHZoBbbnWLd6mDhlBhXsGU2Ly5/XDYsEHxheQFS/mR91q2GnlsWKDUy1FJLKPau/CliUU3uah89cV9Hn6NLbsb1WVzg62ZJcPHEY2rMyzRW2sfGG6M2gvuKzAtvzx+sGxJNhcO1soILMbfUuTENuW+zzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66946007)(8936002)(66476007)(53546011)(66556008)(83380400001)(186003)(2616005)(956004)(26005)(4326008)(8676002)(5660300002)(38100700002)(44832011)(36756003)(2906002)(508600001)(110136005)(54906003)(316002)(31686004)(6486002)(16576012)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTAyVXJkWkxReitGOGMwN043ZEs1UlgxZFgxME9iaEJNWVkwWVVhQ29JUnpI?=
 =?utf-8?B?dFYvM1hGV2JoM0lDbmRlblg0NUp3cmREM1BBdFdteTJCMUxkNVVxY1dmVlFX?=
 =?utf-8?B?Z1NGMmpQL3Rhd1lyYkJtbW5uUlB4QkR3SUlyZGtoZTJzWTJHSERqbDFFMW02?=
 =?utf-8?B?S3EraTdvOGQ4b3NvcW9WMTBWTjI1bGI2ZUhSOURMQ2svcHUwOXVEcFZoMWl6?=
 =?utf-8?B?dkxYT3dJNVplUC9Gck1OeU5JVTRIL2JpZDNMQm9TU3BKVFNjNEtvb09TTzRm?=
 =?utf-8?B?dWc1K2syOEtTaklYdUw1ekxNcUJYU1owekxZdUZJSzRxUmJ0dUNrS0xBL1FR?=
 =?utf-8?B?akJpeUxLTDc4M2ZpaHpIODR4Wm9BOVZwYlYwRzdiZGIwRHNoN1RVVnp3cUlQ?=
 =?utf-8?B?TTMwR1NGd3hPbTlSOWE4dHlhaVpLTTJJYkhPcmVjSE82Um5VQTZXNldQa1JG?=
 =?utf-8?B?TXlxZkZRcFpPMFhuSmI3Z2c4Rm5VdEd6K003RFFFQTBpK0duNVZMWjkyTTdt?=
 =?utf-8?B?SEx6dGlTeStNLzQ5bGFKQUR6enhpV1BUTVBtSmo5RTBSemdtOW8xTVhuT3VR?=
 =?utf-8?B?SnVMUk5GZWR2eWxxWWc4cm95VnlQSmY2M0t0a3dQYlA3RjIycHIrQTAwandw?=
 =?utf-8?B?K3NsbWlicnpXRDEvdVRxbGh3cUhCVmVaREFxdEo0Y0t4QVc1aEFvbHNsQzZB?=
 =?utf-8?B?VE5rYlkwZXJNZktpZkpCd0pRZXB3amtZcm5KYXBWWm9GMHJoSCtFU1lUbzNj?=
 =?utf-8?B?blAvT1M2MVRJVmhxUi95S0JXTUFZNG5MUlhENGJ0UGtmcjF3NFFDKzIzZVBh?=
 =?utf-8?B?YUhWb3RiK3l5K1ZlNlN2a25mK2tYNVF5MW5UZjg1bklEUGdzT0hmZlBVSXBO?=
 =?utf-8?B?L1JzZzRqRkFIVXl0QjJ2anE1cDEwUm9oTi9MQklWSEZjUllVdktzL0N5YnJl?=
 =?utf-8?B?bFg0WEFDell2a29mTHRaYnI4WUdCbk5ab3VubnhpOVZkSzVqckU0eEM1amZN?=
 =?utf-8?B?ZWZxOHk2VjU5ZEk1U3N5elNGT2hjS1NjUmlneFVrQzBsRTllNTUyNWhnY0Vh?=
 =?utf-8?B?VGM4bzdldEVYTW5iSTJvLzh2dHpFemtablVIdXFNU2pXRWpiZTh4UTc0L0xT?=
 =?utf-8?B?dUlPZmw4ZiszVVlNcUpqUElqMzBCS1ZPenJuSWxjY2liQnYzTnRyU0NCMlFq?=
 =?utf-8?B?cWp1S3QvZTNCNG1Qak5qSGFDcklhampuQzZKZnNPVU91cWxyM2YyTHVRNmdX?=
 =?utf-8?B?OUZoK3FuSEZ6cW0rYXM4Q2Jxb0hyOUtUdU03czQ2RVRYM21JdGNpUWZEM0ZE?=
 =?utf-8?B?ZVZHbFByWE5xSVduSkNHN1VtNlhtV1pmNW4zbm9TUnNVOEVEVVgzWFdmdjlo?=
 =?utf-8?B?YnJmQnVrVHdobWI3Mlh3NEwvaEplV2FITkFXU3JoSUJYK0l5Ui9ZeHg0OU5m?=
 =?utf-8?B?cGZHeGF3OGxOS1ZMajVaSkdjMkZNdjRSNk1seHpvdWE4ejNZcFdneXFpd01Y?=
 =?utf-8?B?amw3azJ2WXFkT05zZE9IVkJMcVhiYTlaK2tWTHBOa0ErMG5zQnM2NlExOWxO?=
 =?utf-8?B?c0VVb2tjT2ltNnptWUYzdU0wQXNpR2U0cVB2Z2M3UGdxY2xlN2ZuNTNWM3dM?=
 =?utf-8?B?SWQ2UG1vZFY0TGpyY0NWWnUyckNTclZIaFhmT2pCR3BqRHdjSFcrMjZnbHlG?=
 =?utf-8?B?MkVFM2VnaW81NE1pcTAzTFVNRzhmcnQyZVpaZ29PRWFCd1FKNTk0NUEyOXRL?=
 =?utf-8?Q?AuAbVKw2gWA6Wv18eo507PsZu5XHufvfQm+skJr?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a2247940-95f3-48c6-f76f-08d984124dee
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 13:00:40.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYL5wjhzzVxzsCuMg4WcMyf7zpC5ZHYP/zDitTstwEAHzOwYKKoBdfaioEuB3FSOW6jk1Ov/6Tn+CWCOqvPbEuBXvNF3Q2CTlKxQWbQWiIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.21 14:57, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Add the new property to disable the combined LED modes to the bindings
> documentation.
> 
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> index 0a3647fe331b..1ca11ab4011b 100644
> --- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> +++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> @@ -31,10 +31,13 @@ Optional properties:
>  			  VSC8531_LINK_100_ACTIVITY (2),
>  			  VSC8531_LINK_ACTIVITY (0) and
>  			  VSC8531_DUPLEX_COLLISION (8).
> +- vsc8531,led-[N]-combine-disable	: Disable the combined mode for LED[N].
> +			  This disables the second mode if a combined mode is selected.
>  - load-save-gpios	: GPIO used for the load/save operation of the PTP
>  			  hardware clock (PHC).
>  
>  
> +

Sorry, this extra newline shouldn't be here of course.

>  Table: 1 - Edge rate change
>  ----------------------------------------------------------------|
>  | 		Edge Rate Change (VDDMAC)			|
> 
