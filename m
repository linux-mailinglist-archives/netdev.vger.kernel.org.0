Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8E130E36
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgAFHwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:52:47 -0500
Received: from esa6.fujitsucc.c3s2.iphmx.com ([68.232.159.83]:62908 "EHLO
        esa6.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbgAFHwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:52:47 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2020 02:52:46 EST
IronPort-SDR: qM6Ne9oEmfUh7MOmLvpvu79DhEH4W9qL/jofkqA7Cdcl2b1/9YJ1KMvIotm9fooRlgWJqR0GCA
 NozVrOUzh2kN0RNHihgTY7MV6aiG43kc5QZH49T4tJLUKTpUGZzWyhGRxjwsm9nC9yTK2DTnHP
 Q6OJ5r2IuMpvE1g126VkZIeLMaiS+ZXs0RJaqLRmDUS+b9mfUccKeI29izYd9kxQZYk6qgTzkg
 Sof4ldKq2sohZpEyPZlS1QUeIP3V/a/44Iq+DJhDIrgNarnXgrSlOyoVCfqz4YzPXa+bIcejyS
 Ur8=
X-IronPort-AV: E=McAfee;i="6000,8403,9491"; a="9144077"
X-IronPort-AV: E=Sophos;i="5.69,401,1571670000"; 
   d="scan'208";a="9144077"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 16:45:36 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdMVJh+/k31aXLLYsCzUL8ykwa+Q8Kfgz7HZUuv2fobRkwZrmmnirrCiNOO4blJQCDk63PWkpSUkBLbfnvfm8wguplBVhSRKp+jCy1y5oVXRUp0wUVjoDWqQhuOPh4MxxuPbHe6m4xC09TWVthrF83HX3O4IJwkb1/1i/5cdBT3XR+d98rDoFEAlYe0orYU1thCRBbDcgCNqaynsflem7tkLikEQ/9+ZY3PMI7yTDUeCs/xsKuWn55YgPfjBSAIf9M1jynE416bCJeccWAu+63RHb9OxUFqwC0tqBH3YLPNuyORrPQcT3NO8ZNU9Ta7d0pgkXcC2WuvkbbgpI1uE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmoo28a2ae3LDYyEBHpheEi/Qh3pOb0VFe7TGy+Q9xU=;
 b=gGtVkCO7IAHIyj6KVks3aY1+CAfYZHU5sc0wiG20tEB/LsQJggVF7UtOsPgkvIpG9wkK7Vtk3ECmzFruK6xlebNsgtwBG90FpMAAE+LDs+leTL4d6TlEmoy+1yYmern+EZljgDhTrclJSCbDEzgl8hcZuJCdJgHHrFbfwyF87WBj+s5UdG96zHlsuvsDpIpkDEgGccTWFaHS3jLgwQFm2hny8s/4KcR0X8FjX6+DtZLEchG5kAiKA/XphU60zgazawulwUZcktLlshtf3686TlE5o6wEfL+YheMxed7q4Q37Ec2bS1fDugCbZIfLt0icinsyTVUw3nUcdvdKX+TzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmoo28a2ae3LDYyEBHpheEi/Qh3pOb0VFe7TGy+Q9xU=;
 b=RrY8jtgsw5JTeTFAud3qzhk87ATS65quG4aw3UEPXXtb50qNXR7uEq3jSbOC+TMVllGRLH0E0/DYUB649muhhwTMGxRh42OWRBhLGQ9JyDzePMY0vx/lHwDEWB/OiRCNU5b/55dUufIjc/vKXGNy/fDABv2VPq2oAeIfzKlxIlU=
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com (20.178.97.203) by
 OSBPR01MB1685.jpnprd01.prod.outlook.com (52.134.226.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 07:45:33 +0000
Received: from OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779]) by OSBPR01MB3784.jpnprd01.prod.outlook.com
 ([fe80::bc41:1f80:22a5:2779%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 07:45:33 +0000
From:   "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'davem@davemloft.net'" <davem@davemloft.net>
Subject: RE: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() result to
 be print for each call.
Thread-Topic: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() result
 to be print for each call.
Thread-Index: AdWzwSNKr3E94nWRRJqOBVfNqmHGgwA0/DwAA/N3P/A=
Date:   Mon, 6 Jan 2020 07:45:33 +0000
Message-ID: <OSBPR01MB3784EF710275E56AC20B1AEC8E3C0@OSBPR01MB3784.jpnprd01.prod.outlook.com>
References: <OSBPR01MB37842549BE2C2957005AFE498E510@OSBPR01MB3784.jpnprd01.prod.outlook.com>
 <20191216204726.1659235f@hermes.lan>
In-Reply-To: <20191216204726.1659235f@hermes.lan>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mizuta.takeshi@fujitsu.com; 
x-originating-ip: [210.170.118.181]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53685e18-91e7-4e2a-4544-08d7927c696a
x-ms-traffictypediagnostic: OSBPR01MB1685:
x-microsoft-antispam-prvs: <OSBPR01MB16856D9F41D1006DFDF6C83D8E3C0@OSBPR01MB1685.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(189003)(199004)(13464003)(26005)(478600001)(66476007)(2906002)(5660300002)(66556008)(9686003)(6506007)(8936002)(186003)(64756008)(86362001)(85182001)(71200400001)(53546011)(66946007)(7696005)(76116006)(316002)(81166006)(81156014)(8676002)(33656002)(55016002)(4326008)(54906003)(66446008)(6916009)(52536014)(777600001);DIR:OUT;SFP:1101;SCL:1;SRVR:OSBPR01MB1685;H:OSBPR01MB3784.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dUVkq3WcLjoZD9FndvXayUFbzsdRxpWsvaY9CLaUmXRSw6xjpTsAzNsCNrFgLV6w7XdcAfg2Y6u23GE57+RsHw002ww6fjx29hb0xlJ1TaQDslbetRkB3NZ9Iku4i7R6Lo4EICsdODYRRMmYwMg4Ji6RUHGHHN+QvTfZRwqYhAvefzUIKPOX1vb5R7xK2rRd2dopsV6wCva3LuMVMpzbf2KQWA45Ooq/Heifx4zOLoF/vG1mBQHuBTi7Oug+Z5O8rwDyDF7Rsvht+YFQq48eYQkhSLe+wJGKVmcpO6LV+RzVO6YergxShrEuCV3OYW40N5E+jhbroefhCVOSwP66k78LJoYy94uw72VXYXc6ycPiEMQZNZVyTp540+FlX7QLTenO/xXhiiGVmZpTetG6G4oWZFs+DT6MwBnn7QFWpD7r2IXCpn3jVqCn5h94TwtrZPRC1kaxueY7sODfqOK2sKdnBlv8giMVinE/CY7IMEmloVixv3naue//6B9LA1/8Su0antAWYv9j/CGclJwW6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53685e18-91e7-4e2a-4544-08d7927c696a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 07:45:33.7247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTypeOYOCvlwrlkJSsBk5uxuLzesPF2/sKIM2zjk3qbBB6A6MMYh/u38iK2Ks2rKtIwPx3nqpO/MEcuP7i+51/MPnh0RZ0ExEFzcujTCblo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1685
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Hemminger,

Thank you for your comment.

> These two patches do not apply to current git version of iproute2.

Does this mean that these patches are not applied to iproute2 v5?
If these patches are created for iproute2-next, will they be applied?

I'm sorry, but please tell me the meaning of your comment.

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On Beha=
lf Of Stephen
> Hemminger
> Sent: Tuesday, December 17, 2019 1:47 PM
> To: Mizuta, Takeshi/=1B$B?eED=1B(B =1B$B7r;J=1B(B <mizuta.takeshi@fujitsu=
.com>
> Cc: 'netdev@vger.kernel.org' <netdev@vger.kernel.org>; 'davem@davemloft.n=
et'
> <davem@davemloft.net>
> Subject: Re: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() resu=
lt to be print for
> each call.
>=20
> On Mon, 16 Dec 2019 04:01:03 +0000
> "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com> wrote:
>=20
> > Running "ip xfrm state help" shows wrong protocol.
> >
> >   $ ip xfrm state help
> >   <snip>
> >   UPSPEC :=3D proto { { tcp | tcp | tcp | tcp } [ sport PORT ] [ dport =
PORT ] |
> >                   { icmp | icmp | icmp } [ type NUMBER ] [ code NUMBER =
] |
> >
> > In order to get the character string from the protocol number, getproto=
bynumber(3) is called.
> > However, since the address obtained by getprotobynumber(3) is static,
> > it is necessary to print a character string each time getprotobynumber(=
3) is called.
> >
> > Signed-off-by: MIZUTA Takeshi <mizuta.takeshi@fujitsu.com>
>=20
> These two patches do not apply to current git version of iproute2.

