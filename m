Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD83707FD
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhEAQ5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:57:23 -0400
Received: from mail-eopbgr30132.outbound.protection.outlook.com ([40.107.3.132]:12417
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhEAQ5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/t0/AxWddly2z3Y9FvzxBkGHMoJ4+shEpYTFJuqW7eiQBVVss6rQIOJZv1iNoceYZTv2iJ5PN624gRfLm08iL0hn3Ou08/Q0HoBjN0lhCwMxMjKybsOsZe9FtFCUSo4hNll+jmDQRgfRVl8ru2OIkK8MYtBJkRC9+8mS/D7pbutPYnXNU2efALBUwUdrn7ZS90Go4CNon4l2+sioOns9t2dArRaDVvyNlVPo6BbCRod39h/gCedoEh/+L4Z1ux1jkheP342ZiGKzsJqlJbMWd+eRrDUuBhEcg77rjyzeVlROhw5agI0r9EEoxaeb9BBhn1gks8/YDIT0pCSV8bPKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4pWMueRnBknnSW3hBBMb15BKWfWq0081G9eC1eX0hA=;
 b=OsdTdVZHbyeh4915qkynL4PfONd3/hr3qnS85xCtSDkoJaZsBP+yBN4C9oC+q0DPYFucuKppydxdJO7cprYJ+n3MYXJvt71gEBVvhMKpDRji8y2MG8qRAcosioPsNNTs/6l/XF5F/kZrKktb1j0sZYzsITBHUdPIxl6Di+6FD2TqDZeH794w16iuqF/EV4lIHtndYd0CrON8gy0nsZImZPHibDfNHW7j0ByQmbadXh5hSd48ln2a/GNDRXhj6tNR+wHsdvmkMf7L2/YSdaJej6U4nqtXgWcF74RLQfbUf6DCZEjTqtP0kIkzdiYC6knKuoM49WQGu2/YXf57S4YxWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4pWMueRnBknnSW3hBBMb15BKWfWq0081G9eC1eX0hA=;
 b=WCXsxAdiaXyhDhxHiGxl/3zF2BSELAsKOgI3puX0AOCs682JkF7htJLsR8dg6iedrV8FfSjO07DzHCqvIUf6bO3Mfi+YG/1Xe7U7JAlj0BIDl3s/n9TRQ8iDKVdEUDKqcF1XhyEV2mv3U0xdU839zA37Wtxi0cwkTyAnmTaRzdA=
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3658.eurprd07.prod.outlook.com (2603:10a6:7:8e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.22; Sat, 1 May
 2021 16:56:29 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45%5]) with mapi id 15.20.4108.019; Sat, 1 May 2021
 16:56:29 +0000
From:   "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Subject: Re: [PATCHv2 net 2/3] Revert "sctp: Fix bundling of SHUTDOWN with
 COOKIE-ACK"
Thread-Topic: [PATCHv2 net 2/3] Revert "sctp: Fix bundling of SHUTDOWN with
 COOKIE-ACK"
Thread-Index: AQHXPfviEh27kh5DoUepTkLyPpqf3arOylNu
Date:   Sat, 1 May 2021 16:56:29 +0000
Message-ID: <HE1PR0702MB38180256C324E2C9A234AFA6EC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>,<a9f65034deb5ffa57ea704f99102fcefb9bff539.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <a9f65034deb5ffa57ea704f99102fcefb9bff539.1619812899.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [91.153.156.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11024919-fd31-4343-76de-08d90cc21115
x-ms-traffictypediagnostic: HE1PR0702MB3658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0702MB3658F3D3F09795F600B17B54EC5D9@HE1PR0702MB3658.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nkeiEZba//l0WDCj8QVSvD67YfiEM1Gi5IjYgVS6BMFZXZVW8di9eS29ZpnEnIn6gqfULuXIpDwEt/D+eSFwjqXHNcNChROc1XQ0DQWCODZ578ehfDMGHvxzyawJ7AATpTX4sTClttD9jeLc6PZvYOo7FhyGF7hup0HNVZ3kcTXM1EEo8JC5//JnpqZQ/PcSIebYf0cfRo8NX1c8rPFg1IVQ8U5NXBIgNsvs97af5IxqBYznnqMWPK9gASTGieL8tkeMNWSj2HNndXO8ImB/do6CnnOGwa2cb+Qw6EbMzXDvoeYlR6ypFdfQRWXzBB89pCY5XPmUXisvvnpK3UZKejwPHJQq44EWgs5w6Sp4tpCCKSnb0b+LD9tRcvWE68iN++a8ZarmmqGNe7A/MosVdgeNZKeaGmagQiuvIy/4LPac/nnrNlecXgeRo35D/6zkXUhIhpP7edJMW2iEjIfHrSo9vFNbcSY1Ik8OXyGwtyhGi/OUJ6/78DpfgUZSQmyVXfIlmkITgvhTpJ3M0ImJrCPAlWGo7xgb5bdTGtaQQLPc18N+ZkPKojuthHobbxVNUFAAcYzfPgQyEWPGdMPXSpfbZ+Tw38X1WLfrBSNekgI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(6506007)(71200400001)(2906002)(55016002)(7696005)(9686003)(86362001)(107886003)(316002)(26005)(186003)(54906003)(4326008)(5660300002)(110136005)(8676002)(83380400001)(33656002)(122000001)(8936002)(52536014)(38100700002)(66946007)(76116006)(64756008)(66556008)(478600001)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?gCxbJqLr52BRbfdmZdc/YWgQluMlDm9Nuvji1qzBnSEyZdfDhxS8wTWmo4?=
 =?iso-8859-1?Q?BfT8bIL+UDVNAYnvrtZKs2UIGhbNvmHNPRElCXOVm2plWO0KDV8BN/9qMS?=
 =?iso-8859-1?Q?kCmk/Te38232uL1MVqLnMgrbngT6amVGKu8Zzy47Rp844We9gwXvkiOv3t?=
 =?iso-8859-1?Q?5WW1jl40/qIBJ6iirO7Znj7EM3qxr6sOb6eYriLJqIu0MLcfvmwvdfnN3l?=
 =?iso-8859-1?Q?HVajTKvnIFM36IdouLYvdfsEaNXyddgbwHK8T/dfs7gD33bcHAqvc5GI51?=
 =?iso-8859-1?Q?mJN20c3sWvZgWgFwpHt1HeAG+T0Js4ULMCOHzZ5U7jGH2so+hqlQ++UE1g?=
 =?iso-8859-1?Q?bqpEi2+0ra+YiifTvwedpw52rnUvZniczDO6GzhVYTBQ8ABu025DOMp7mk?=
 =?iso-8859-1?Q?9mWOqEVWPJ4lX+kubkbCsvEPnt5h9gEEgr3HDFkrQWknjaoYpQjNZD+5Eu?=
 =?iso-8859-1?Q?lg1GkfdZfTDAbKVMA7OmyRaztaJN4NpldMrSgMGO1fbVE5/bJzNNZ37DH2?=
 =?iso-8859-1?Q?GdKyiPVCWF7/QnxbhUKm5mS4QL0zfv4SvV22eg0Bym88fm9X2hh0i4Z+Wg?=
 =?iso-8859-1?Q?W6l3wu4ANUZ223Hbq693TLe/P0vvEJYH52TKlcHabfiDMz4y+v/gKoyOsF?=
 =?iso-8859-1?Q?ns0suF2W+qJd4ntEtrf7TMJutnkhwaUW65HVdxPXuhdzF5GbnU6xhqc1as?=
 =?iso-8859-1?Q?vGaV0WUzZ5WOehQS/UUVC3F4qwfyvVVEo7OJDOSq6HSOGxgufeQP5/aQN/?=
 =?iso-8859-1?Q?gcGVpFJTw55lSl7k3pQHrIorIlL0YC+zxe8MMjKRviES6WLRLwq7YStxqq?=
 =?iso-8859-1?Q?ZFCpdA8ndqXC3f368MF7fN02RzFt3xgSpvJaW5YgatrZNRU6HzPJEz5Jpe?=
 =?iso-8859-1?Q?UxycaLLyb5Tf0Du8AyUUZ9lwUhmtPYT7vHa6Jk9ln/w6XTU/6mEhaqxi6P?=
 =?iso-8859-1?Q?Mk0+YyB6X6/j3sqf/OuXqjuC3lG9PabiejDN5qimPSCy8BHDxILMXR+Jj2?=
 =?iso-8859-1?Q?US3HHH5hScw0Lsod93vCtRYM+HoRsQOcTkb1Oo//u/NX7rVb2VTRNheieY?=
 =?iso-8859-1?Q?f1BWHLl5zdJzsEzPR0+DoFQCo58QrwtnR5iLwb+i//XcDRRmcRgEMU795S?=
 =?iso-8859-1?Q?ygP6VQF0g2tbQY0VAwggZiMSzX5TaOmX+XTj+vTZ/hMS2W+j9nJLa+yVT3?=
 =?iso-8859-1?Q?06FvjxhobtFThIG08BWkhUiphgt62Tc0BA/7EtvhOdWzPaTkMJWX21NCPs?=
 =?iso-8859-1?Q?wT1JdoY136qQ/WAAxJXqTyvxMRDkQKDfsXJLVxQGJQoGG3X/qqxydO0uTP?=
 =?iso-8859-1?Q?TGJp5skfWOjoymQ5Qt2WePpaxISQ4yrKPCMztZmNlbF7n2XhCv8p5tYVro?=
 =?iso-8859-1?Q?//5hzENGMN?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0702MB3818.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11024919-fd31-4343-76de-08d90cc21115
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2021 16:56:29.7565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: foBZ0t5nfq5ca8bG4ZHRhBGpZJWpV2+3G9ilvO8M7FQ9tVo8dVAwxmU++6GebSxnISyPQ5Fwel+C7TifuWTcgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021, Xin Long wrote:=0A=
=0A=
> This can be reverted as shutdown and cookie_ack chunk are using the=0A=
> same asoc since the last patch.=0A=
>=0A=
> This reverts commit 145cb2f7177d94bc54563ed26027e952ee0ae03c.=0A=
=0A=
I think this should not be reverted. Without it, SHUTDOWN would=0A=
get its transport from sctp_assoc_choose_alter_transport(), which=0A=
could be different from the COOKIE-ACK transport, which would=0A=
prevent bundling.=0A=
=0A=
>=0A=
> Signed-off-by: Xin Long <lucien.xin@gmail.com>=0A=
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>=0A=
> ---=0A=
> net/sctp/sm_statefuns.c | 6 +++---=0A=
> 1 file changed, 3 insertions(+), 3 deletions(-)=0A=
>=0A=
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c=0A=
> index 30cb946..e8ccc4e 100644=0A=
> --- a/net/sctp/sm_statefuns.c=0A=
> +++ b/net/sctp/sm_statefuns.c=0A=
> @@ -1892,7 +1892,7 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(=
=0A=
>                */=0A=
>               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl))=
;=0A=
>               return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,=0A=
> -                                                  SCTP_ST_CHUNK(0), repl=
,=0A=
> +                                                  SCTP_ST_CHUNK(0), NULL=
,=0A=
>                                                    commands);=0A=
>       } else {=0A=
>               sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,=0A=
> @@ -5536,7 +5536,7 @@ enum sctp_disposition sctp_sf_do_9_2_start_shutdown=
(=0A=
>        * in the Cumulative TSN Ack field the last sequential TSN it=0A=
>        * has received from the peer.=0A=
>        */=0A=
> -     reply =3D sctp_make_shutdown(asoc, arg);=0A=
> +     reply =3D sctp_make_shutdown(asoc, NULL);=0A=
>       if (!reply)=0A=
>               goto nomem;=0A=
>=0A=
> @@ -6134,7 +6134,7 @@ enum sctp_disposition sctp_sf_autoclose_timer_expir=
e(=0A=
>       disposition =3D SCTP_DISPOSITION_CONSUME;=0A=
>       if (sctp_outq_is_empty(&asoc->outqueue)) {=0A=
>               disposition =3D sctp_sf_do_9_2_start_shutdown(net, ep, asoc=
, type,=0A=
> -                                                         NULL, commands)=
;=0A=
> +                                                         arg, commands);=
=0A=
>       }=0A=
>=0A=
>       return disposition;=0A=
> -- =0A=
> 2.1.0=0A=
