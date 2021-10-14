Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C556142D98B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhJNMxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:53:55 -0400
Received: from mail-oln040093003003.outbound.protection.outlook.com ([40.93.3.3]:21188
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231140AbhJNMxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:53:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFQO4O7WfZ7bbE5qqcPv1yWTU+y3tcr84X4Pgv4nIc0GJNT471xsJczbl0VGDR2yvqmWCywOO5OSs9uVYTiKSljnOsr9Qe2JEu9L092ZeVE58QXpGI8/pkHD/uXEAeEUDyRPx73jLc7uJ5daxSUIRXWDBhPosgKegYqUFIGf3YCTaIHevb+aiB4Nn2vNt3kO2m92fTA2nqzo+TpROm3V7/0d40OSIX+qQqd+B8R6QaSIPSwBAXdbywnBfQH5IR7pvMFC9KFQ8byPlTEH8U86KYMiImk/Y7Fc9YbdVFP66p70UkiiUTKqziCFJOZAJOairfNe3MliPmtjO0y1q6nHEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTZ8PljX/KUFo44quNY166bkZOy8cgps8qRAFzPFgz8=;
 b=hXtaJ+gKNUDLsoE+xcCS+U7q79a0W/QmBnZCKsiy29qdQav1sfDwuywT2sBvzfdZ3REn5D2MAPDdfOhaX2EtsAkXdmZlvGBO0B4oeFD0bV5ghP0KhVJzI4l6C87LREBMRgkwcEr5wsOb0rSkIG3pf3opSAfALBlUP/UzdroVa+26uL1IbX96xqKOQL2Do0qoJux1wKXP5p2xrNgsGNar058GLHG9ALZWYgYCIcPsTxv76cOibG99OnLcvAsWtxdjxZykNaIzaDGnuK8piSQ7SeGF4dRtaBrtrpP2uYni9jGkf8pcvVV5GAMEt/L1hSDW31lXBd6nHLrsrAUYQ90GZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTZ8PljX/KUFo44quNY166bkZOy8cgps8qRAFzPFgz8=;
 b=ANJjkFloh1gUOuH/nviE3mZzp+NuyPe9ItTSzF7MObtdl8TxbkxtvTAjRSQ2/jU7HLVbtkGAJy3so7tPjLh2qD6qIAh1FlHT0uZB5fN22wnAlV3Dg4tElXGYOWw9kC14C7/w9QE104cLl0xv6Jq6a/rIZNEtDsqRv2n5plOr7V4=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1220.namprd21.prod.outlook.com (2603:10b6:408:77::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.3; Thu, 14 Oct
 2021 12:51:48 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::297f:262:dd3c:555]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::297f:262:dd3c:555%5]) with mapi id 15.20.4628.009; Thu, 14 Oct 2021
 12:51:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Add comment of netvsc_xdp_xmit()
Thread-Topic: [PATCH] hv_netvsc: Add comment of netvsc_xdp_xmit()
Thread-Index: AQHXwJqJRtOmHDL5Xk+iISMAX9KcJKvScnUg
Date:   Thu, 14 Oct 2021 12:51:48 +0000
Message-ID: <BN8PR21MB1284BC427B0AA4C01C263BDECAB89@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <1634174786-1810351-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1634174786-1810351-1-git-send-email-jiasheng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3a766eba-2401-4220-bd07-aef53ddbb9ca;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-14T12:48:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84b35a9d-0a2a-4977-8ab9-08d98f1162ae
x-ms-traffictypediagnostic: BN8PR21MB1220:
x-microsoft-antispam-prvs: <BN8PR21MB12204ABD44DC8F6B252B88F0CAB89@BN8PR21MB1220.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JxBjy4UOJTVYPwjobr8M/9+QJGV2FCHEbpWP2hgEFZhZ9PZ5SLunSPYHXmW8tuhDZoQWvHQY27zHbU3pQZy5cuFymVpwsUYfiErKtXdX73LJurjvQayV4PC00jhU+befQ1b1PGNJxqggLhADTISXGDYq9gAaX4OxEoT8VIKmIkfNkw/Ec0Upwfq95YwKH2RjF6hDs5WSVaysaSrqRqJ/9mVejcKnhske46NfSzVqYJCtBfFUheWAB4jv3tXt3IqIfn8VVMNbm8moPtLOmyIOmmt5Fzauq9A9+WevNrEtxAqGTb50JEUfO1OoqkG/zwvpHC1pGd1YP3o0d0pvS4F0jZWn8U4j52G4XJxgzL9JmHnUuX9Z/rsGJV13GerLLpj4/SG/SbCfA0HP5/yK5q299RDaUM4P+1oqWspefT+R/sHMoCj0A9Vf4kyiWQLKj9PGmu44zCWYmUQ5zohmnYbak145vxdvgVTJC7mLJpQ+XivUsjbMdp3j8kJsWBLWnLtv6GJAt5wQuJiFHV+2I6/xYBsDQAaaTeRUECEOrFFn4EWwhc5ir/6hyhRAmnTe/SC/IQa8P6FtZwlcszwcF5uVlTJHkB2xNxugFTy1EDpF1pWR7iBySWLFa8b9b45IfzbP//ZfXtEhO29VSEvO/kmi7UEuiICWJ0H4iL9CYeSsp0Mk2QnwccVA9iDSpztsC+J3Zttb07dz+1h1g+1+oxww9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(10290500003)(9686003)(38100700002)(82960400001)(54906003)(55016002)(508600001)(83380400001)(2906002)(64756008)(38070700005)(66556008)(26005)(122000001)(6506007)(4326008)(186003)(8676002)(76116006)(5660300002)(110136005)(82950400001)(66946007)(66476007)(53546011)(8936002)(33656002)(8990500004)(52536014)(71200400001)(86362001)(66446008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KSen0njkRuMTXaeSY8WfPITGTI0Xm9J1kipSR3qdWF9Q2oqcA2rT4EWVz1Pl?=
 =?us-ascii?Q?ZOqzV2WLRXhDKPS6uzpohI/utg8/Qa4wH6hCu0ijUMYT3Pj1hFXS7Y6a5pp8?=
 =?us-ascii?Q?CBs1KckJuYdVS/lm/08PaNVZVmwUsiEKqOA3xrrzfXL4N/SWn13ez3LRXZZj?=
 =?us-ascii?Q?SZt8TSVzNMLnF8I4V4Fc0ytZ3ysL2vnn8s/hHqQ+BWPBCtd+dS981Xyyku8c?=
 =?us-ascii?Q?Aet+MuJrOzaSSedsvWr0wwFfMfZ4JN67fDl12f7KwMLWz3Sbe36Nt6xGg/Js?=
 =?us-ascii?Q?br9TXqoexrABEuqBAjyleWWXgHw1qv7r2wVW8f+YKljRjac6D/L/kWCP3Qz6?=
 =?us-ascii?Q?lYU4KpzW2z8Mk750LBzALGAvJGLVVJTISfruyNSg+x4nV6TRDL3GcNziru2L?=
 =?us-ascii?Q?Z3ksuA4n7d1d+OSzaI93wHVs3PzrQP4DCOaEl5RYbqc/sDE+eq867gzgLDBO?=
 =?us-ascii?Q?57hq7kWwaGvzwk1SvbQZCFPfFJYZi0fILbobYba53Z8y2d44xMpDnFSrNZof?=
 =?us-ascii?Q?YcLFBsho1JbCzOW8dDXOzarqDjLOQChtoqg8SrDHQRGmHzkQK99lJaz7Opm9?=
 =?us-ascii?Q?IWhVJZzr2keUp12tSYRB11tIRaqX28BfCOh+MLqzoV3M1+1nxbJpilTmPt3I?=
 =?us-ascii?Q?DseYE36cQCHbbm5cwsyFzyHFQ4Nwf7lob4BFRtx3/VlGGRIeBBqy219p20e0?=
 =?us-ascii?Q?CRJPS01iAdMjxMjx+sy/n+3nmbcg8uvhqI1MXw6G2nOxdeaFNugDexIF9ccR?=
 =?us-ascii?Q?KS7WJE1QREIxcewMKmhxINumyhSfr0bWUJMO4ZVHyj2hA5czcs/JW36PgVAb?=
 =?us-ascii?Q?ZLtlCl652KkP3oM+B1CbarDkpZR+0t/AvI8IaKqQAniZCKBzOKA2yLAx80vO?=
 =?us-ascii?Q?V9s2yAhjh2CWqBWKPjltOZQW4SjrI4vtKy48/gEvwkWXvup7FlFoM/j/zyFl?=
 =?us-ascii?Q?XjBZSovAz7S4g5rSY/0kgro3hUGFf5bLtqq9gJY6G0wq6Ap/xKLWNIpVhAW7?=
 =?us-ascii?Q?KQflcj1g6fAqBIjyC/72fqwSJcEJ4wSiIdW5hsqV+MlpA88WIpQdHWwKn9gW?=
 =?us-ascii?Q?7wprIReuXEOw+V5HmU1PZL3r3XTzoNshBH03YqBXiBsrq46iXhVqA17gbTPC?=
 =?us-ascii?Q?zAFSl7yWRhNs2xxmr0No7dtURhYzAITKlFDaXNANSDudwlRG79f5fL8h9kjO?=
 =?us-ascii?Q?39HbDhyU8UdMAoXt0n9r0Y0vZWxB3OF+8gHzwoMNnH+Icy8NcoPDAOyIwyLs?=
 =?us-ascii?Q?uTqZhnBUCg+LQzFIVbbEx7Iq2eB4+4a26Y1E01J2ot1NyGqSaTCvgokglPzG?=
 =?us-ascii?Q?/UkfK5r2VaoFL9h4rirhvak6S7iulF53LUWUFmyJCcr25Kq5kxH+eThm4Dy8?=
 =?us-ascii?Q?T80NU6mXv/iXvMq61j0cnEmhJOQRTe9/JAJ+0YZW6pNuYK7c0jkRX22Oo2a+?=
 =?us-ascii?Q?TZDQKNxYA9hTd5OkIbDNgzUc+dxI6RLMt3aMmb/i3mIGoUn2zTSBH+tX92RA?=
 =?us-ascii?Q?NoUcc/3qPOpfrWneReGKL/gti9WwrBKpDDrbAqBQPDtTGmkrqfcZK7nW43dF?=
 =?us-ascii?Q?ssyyWnomuBXnW7dz6K6gyeXI8EoPxIWdQQaUj+Xj/KyxAwUKp3A3Pv+a8fRD?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b35a9d-0a2a-4977-8ab9-08d98f1162ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 12:51:48.1638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yr0wMZmEzgINTZAHLmhuJ0Rn/T14tlSWbcm6fKzXc8WA0LbXc5U3y+yaKPAEP4KtuCbDn9PWJs9QCrH0qvzC/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1220
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Sent: Wednesday, October 13, 2021 9:26 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; kuba@kernel.org
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bpf@vger.kernel.org; Jiasheng Jiang
> <jiasheng@iscas.ac.cn>
> Subject: [PATCH] hv_netvsc: Add comment of netvsc_xdp_xmit()
>=20
> Adding comment to avoid the misusing of netvsc_xdp_xmit().
> Otherwise the value of skb->queue_mapping could be 0 and
> then the return value of skb_get_rx_queue() could be MAX_U16
> cause by overflow.
>=20
> Fixes: 351e158 ("hv_netvsc: Add XDP support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index f682a55..ac9529c 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -803,6 +803,7 @@ void netvsc_linkstatus_callback(struct net_device
> *net,
>  	schedule_delayed_work(&ndev_ctx->dwork, 0);
>  }
>=20
> +/* This function should only be called after skb_record_rx_queue() */
>  static void netvsc_xdp_xmit(struct sk_buff *skb, struct net_device
> *ndev)
>  {

Thanks.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


