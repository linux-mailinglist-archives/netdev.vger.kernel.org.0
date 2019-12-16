Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE0C11FD78
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLPEIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:08:18 -0500
Received: from esa20.fujitsucc.c3s2.iphmx.com ([216.71.158.65]:23351 "EHLO
        esa20.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbfLPEIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 23:08:17 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2019 23:08:16 EST
IronPort-SDR: vAM927yqAbfiRuEEFjlOuqeeZ996YDdE4hmv1BMzuDkLJm2N3UadsLun6s7J+XLOCFtKdXugu8
 E5KnaCr87X4y4v4nI3HfkFbYpptlJ6777T5qwcJXmu8oAuBl+mzfUNdks1+uJIGwOSs+Bu6GPM
 +6b8iu3HU/EMA5g3ifweWq7vOFo0TUzbJUoJ8RHOhM30ot31pYInJw7BrpzlRY9ytGaY7h96IH
 nqNPJv7TdgyC8DTbgX5AaCplJ1A87NO5gwQGL+6b+z5ATjMhka/0mstlVwkB3ji1rhPLu5323I
 DyE=
X-IronPort-AV: E=McAfee;i="6000,8403,9472"; a="8601957"
X-IronPort-AV: E=Sophos;i="5.69,320,1571670000"; 
   d="scan'208";a="8601957"
Received: from mail-ty1jpn01lp2050.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.50])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 13:01:06 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEy9Ciuv9jgVBycHgH7y6oyKX4sbcxtJwIoMf/GvEK6mWDu4EyNxjlknCuBZ98JNvNnXLFGt6FiGBUh++ff9IyqrTU3s5H0Ybb1uACyiU6J9qrc1//XiqdmI5ooW0s0blHeqMvpoZLVf8esOestXJ3GR/uNl5eqsiD5uAs7BcuLYbcuL73jiKW0hLRMnU9uvNXopi4JOgoK1iSEOu+CboGz2yaVGxDqjL8/ndcEIK/b8QBAU8sxZyVxIvVTz9QDn17lR1wgd8ZliyybuEOQZs1pMWVNdhegsBzulofn9pwUBPJfqHj9YD363LdDD7tImesoLpFxw3hMjigGx6fozCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgp3WqlbDj7BUY3bPvDEy7V1dzJrSOK//K17T5m4EWI=;
 b=hNOMW2xnfAMd6RARaZevkX/II0ZUIfMS9m+ZvlsAixbFPhnd7GW76SipgVGhM9iRk7bgqEIXKaLOfY8A3IyliJjgOUiFDYkVz6EeMbB9mW/LSUywozqeDFAdeA1+phzpgVdREuLtVsujbKqjrtstv1qccy6cFPY1qOgkLKCPTtOefbRVp/dO1uNEOk2KEHs3WfRfxz2jcp4I8MbtY87N0sBHuTHFGhE0FSbiXnxcIo7CWOH5zXm3UoQHjWGl7rAPxWD5CuumV1u1vIHXHUm2TrJu521ztds8YomZSOoGpiy4Wto1e/Y3bCk0r7xE6yBLG3/MdUgg2bEIql1RBSQRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgp3WqlbDj7BUY3bPvDEy7V1dzJrSOK//K17T5m4EWI=;
 b=gqv8P4pzq5IOLmOd84rDUJd6UiPULx8wpOC93cpLQ3283mjQrelLdJTXNC7K8qIWUgupCb2JjVVwChmixp++Aeq+7whzZVhHlKkL2XxiB5NUx+tuFY4xf5Dmf4dCbRMCHP861NglP6xN26LATN94bEaSdInT6/R5fIgyjq2ppf8=
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com (20.178.97.203) by
 OSBPR01MB2696.jpnprd01.prod.outlook.com (52.134.255.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 04:01:03 +0000
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779]) by OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 04:01:03 +0000
From:   "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'davem@davemloft.net'" <davem@davemloft.net>
CC:     "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
Subject: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() result to be
 print for each call.
Thread-Topic: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() result
 to be print for each call.
Thread-Index: AdWzwSNKr3E94nWRRJqOBVfNqmHGgw==
Date:   Mon, 16 Dec 2019 04:01:03 +0000
Message-ID: <OSBPR01MB37842549BE2C2957005AFE498E510@OSBPR01MB3784.jpnprd01.prod.outlook.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mizuta.takeshi@fujitsu.com; 
x-originating-ip: [210.170.118.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cb3c020-583e-407d-e053-08d781dc9204
x-ms-traffictypediagnostic: OSBPR01MB2696:|OSBPR01MB2696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2696C376429BEDBA2188354E8E510@OSBPR01MB2696.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(199004)(189003)(71200400001)(4326008)(33656002)(66946007)(5660300002)(186003)(316002)(66476007)(66556008)(8936002)(52536014)(66446008)(64756008)(55016002)(9686003)(8676002)(81166006)(76116006)(81156014)(7696005)(6506007)(85182001)(110136005)(86362001)(26005)(107886003)(2906002)(478600001)(777600001)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:OSBPR01MB2696;H:OSBPR01MB3784.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wpI7n33Uff7ap7qcleikpGVN4XkcQW8F2OT3mEOudHkZkMr9O5JWeA0CQlJbDzqo1QZK5YA/EfKQy+vn8rCQxUicsQdLjB676eDaUFBs3gm5WkieCNRo/m99NOHhKe+58tp7EFa8OThaDPrR71Ciw3izt5870Z1eRuIsUy2dukmvSqPRfIoLE4rOCyuIuHxyqdKESpF33loKUcULUZ+Twsd5XCS7yAS1Qgpucv8wSNFkKuxMASqtdYwYwdEqT12SOv/Y1mWJg9aQCOZEtaYCPb7cTWF2HQZue+TVRaI7omZ15SZ7TpPvfbRJcvjEtEDS+BmGr3ALQ4fshXjVmzu/txvJKtoPzauWkiXzQ3mtbPcUWjotMBl3MWPYAywmEnXTPjNFEntXKIxOKutCnXGbdKx9ZqpoG1gv7xy/iJ6NDSe5OFzl7T18u4Yj+mclW/wge1dHpP3JmKzUEmzpzRz3Muhgqqpxx8ktTMggRyLJlxuwR02Tjlhsx7SEhHKtWHeqTfT5KkfM0okj41Q1dSNOVw==
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb3c020-583e-407d-e053-08d781dc9204
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 04:01:03.5147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhTZ7kkC+ZWJaKHlQqZMfWGW/rr03Wwns+jxVhwhVLecYQhOxt2Ikv8AyIuwgW2OtJEv8xWtkp1ZH/ziH5wRqDOtkqLJbHVclHAgGNpKTjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running "ip xfrm state help" shows wrong protocol.

  $ ip xfrm state help
  <snip>
  UPSPEC :=3D proto { { tcp | tcp | tcp | tcp } [ sport PORT ] [ dport PORT=
 ] |
                  { icmp | icmp | icmp } [ type NUMBER ] [ code NUMBER ] |

In order to get the character string from the protocol number, getprotobynu=
mber(3) is called.
However, since the address obtained by getprotobynumber(3) is static,
it is necessary to print a character string each time getprotobynumber(3) i=
s called.

Signed-off-by: MIZUTA Takeshi <mizuta.takeshi@fujitsu.com>
---
 ip/xfrm_state.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index b03ccc5..e947a58 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -107,20 +107,16 @@ static void usage(void)
                "EXTRA-FLAG :=3D dont-encap-dscp\n"
                "SELECTOR :=3D [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ de=
v DEV ] [ UPSPEC ]\n"
                "UPSPEC :=3D proto { { ");
-       fprintf(stderr,
-               "%s | %s | %s | %s",
-               strxf_proto(IPPROTO_TCP),
-               strxf_proto(IPPROTO_UDP),
-               strxf_proto(IPPROTO_SCTP),
-               strxf_proto(IPPROTO_DCCP));
+       fprintf(stderr, "%s | ", strxf_proto(IPPROTO_TCP));
+       fprintf(stderr, "%s | ", strxf_proto(IPPROTO_UDP));
+       fprintf(stderr, "%s | ", strxf_proto(IPPROTO_SCTP));
+       fprintf(stderr, "%s", strxf_proto(IPPROTO_DCCP));
        fprintf(stderr,
                " } [ sport PORT ] [ dport PORT ] |\n"
                "                  { ");
-       fprintf(stderr,
-               "%s | %s | %s",
-               strxf_proto(IPPROTO_ICMP),
-               strxf_proto(IPPROTO_ICMPV6),
-               strxf_proto(IPPROTO_MH));
+       fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMP));
+       fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMPV6));
+       fprintf(stderr, "%s", strxf_proto(IPPROTO_MH));
        fprintf(stderr,
                " } [ type NUMBER ] [ code NUMBER ] |\n");
        fprintf(stderr,
--
2.24.0
