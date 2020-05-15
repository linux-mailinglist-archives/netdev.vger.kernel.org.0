Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0420A1D5AEE
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgEOUsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:48:33 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:57452
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbgEOUsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 16:48:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7n0l5Nk8rVJFocw+CE8ftVqggaLa/tTPD0EyfiUIyNXGhEE+pmBTYwnLt2dpINyZn7/PmyuQJsJc4l9etRTprDji+WdqNlYrYl4TeDCWje7rDpOveFsy58ngNhHfX1a6aNRyYtRM8/GYraV5zW64ACCHp56dGVR/Ss3exsGKXY6v8ER/yn/HOdJvbqose4q5DOY+tfPbMrlPQ8q07gi16NtjuxstUxjkV2hcR+3QQ4r4ypdEN7SHVcxfNtTcIvhdBJRIJOpmBmDWzF6XPhKotmIlzfbHcgIEOfQJ9CnO3O+gNynqY2ldglrv1bna5ca62Ne3O1IjFUg4Vcqr/hXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rH7IUkidrQM3pHrMHVG3qSz3qWuya6v+YuxJqbJhD3o=;
 b=HqgXtTLLvAlkRS/CSYPN7OT4JtTI4hhtulXjm+EjY8QsT6sP1xzQNZ6zJVgmjsxutNYrudHrRES8lQDeEtXJM7LgiIs7TwK6JoSfZBrmI/881kDtJS/0jxrSYrGxf406LUKqt8L7KHWawOWHfi2/xFDVQEtgI+oygsrxSPgeNBQqQs6fQ/Fd/90sOtvQFnu0ndE1gWpTU33ZBYF5xvQwZMCTUsR+fjUTzvjHm5Kc+aUkIlFS1b1HvampMs4bx30YLAyoS8zZ+9nau29AJX0vatle6OGDRMnUWvjFplb8NNxDcbZNSMdfY/ZgzMTylueewMvwWdtmh8O7WfpcIgmCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rH7IUkidrQM3pHrMHVG3qSz3qWuya6v+YuxJqbJhD3o=;
 b=dRfbl+XsCrKV+sq8UvoQZfmm/1E1wFGVKogrcT3I/7GFcq19w5m7wbNu2EwCvNPFAokxeWMU7U/p56U+etmHl8v4SYqV+CIrckXY0ooX10cgv8hjVMFRq0t+Z9Xlw03EAofqXH+j61mxmy0oyBvUbqQJ5iIHhLXT1ugL3tppe3o=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3901.eurprd04.prod.outlook.com
 (2603:10a6:803:18::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Fri, 15 May
 2020 20:48:27 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 20:48:27 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFg
Date:   Fri, 15 May 2020 20:48:27 +0000
Message-ID: <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8aa9398-fcf2-4b96-6ae4-08d7f91151aa
x-ms-traffictypediagnostic: VI1PR0402MB3901:
x-microsoft-antispam-prvs: <VI1PR0402MB3901B7E097B6FC7FB5CE3FB7E0BD0@VI1PR0402MB3901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z0RDq8+cR50GnyLILR+DtGcVnXcdJQ0MB68Dog6yL3Ih7LF5xahxAJw5BlBkduzBRzabNhRSBPfDwVe9pG6aF8fR++W767io/7VBfpfYgkIp3QXU77QZ+Trlbj1cvbmtnD1F9jy2in5Ra6gFiFA/Z45mxjZ++M0tp2hO/PMsxFZK9jWRxiwqCw7MAoBe5ix/MPQWegKcmBGkzsZKEoYcQjrq7fWckIh56LWrbdweLFtEehfScbeL/TmJpknQIW7kyslnDotONX0/FmD1s+1F7lu1T2N1dW8w6tkBqSbvhsu/GdC+rbAOFlYGUQe1WsWoy3tdwH+s7wXoAjZZf6ZP3Ldbt9tOpGPEt/PfrsE785Lb2f+3IouRrLIrqKJU5xjLpp9hOGiy3f+ojvx8WnKBUWf+FbgJDdGx5wUya3b9YsjfIgPOCclqmChqAdDo4Qro
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(86362001)(54906003)(6916009)(52536014)(2906002)(76116006)(8936002)(316002)(64756008)(66476007)(8676002)(66446008)(66946007)(66556008)(44832011)(7696005)(26005)(71200400001)(478600001)(186003)(4326008)(33656002)(6506007)(5660300002)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: L1O5MxPCj1MjVdyqSYKP6OuqfIFu+CEBo3IpskpDioV1mtPrTDwYG+5M5SzSnTUdrO3SPXKnD28giyJ1Gxwy8bnFRnb7OT8Kn024w+GQ/S4WDYg1R2X268WqVh35JyMTG1GX91CR+gUxsQAL5/ZysljTSXfNQ8kGOzU4/LjTLArGYYk2KUBEfg+KnRYu9L4bivTfj7oNEWQEwluik/a2xNn3sqWDJcuHVpVhUEbxxH3/Jd4bTwmAKYshisHz2ZJLYOJiXHdoZIzdvrUcpd2CAczYn437KhhZS+AhfgOAJGg/nVRS3gN4QkKIA57KbBOxpYVwY8NdrXx8cs5idgeADDlDdtiSHBqHyOcw1VvHMeyJjoKO3YaiDuhpBOv4lTcbOvvio3eAwnPa32LsQ16WdVNj8PZ7EcXmpWizvG6xQgPg/jsrk7nW8IREC3+J/e1mSa4WguSuwEBk1bQjpM1rUqvWztTPXRXm3ksCUHMvel0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8aa9398-fcf2-4b96-6ae4-08d7f91151aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 20:48:27.4008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MYfVZixvBKHlJZ01gPPS1ImoOE70PlwiKhku9i+/f6m9ET6Fvz7SWhBv7TIu3Z8Zi5iLoydIC/yTQ/vGMnmxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3901
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Fri, 15 May 2020 19:31:18 +0000 Ioana Ciornei wrote:
> > > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx
> > > traffic classes
> > >
> > > On Fri, 15 May 2020 21:47:46 +0300 Ioana Ciornei wrote:
> > > > This patch set adds support for Rx traffic classes on DPAA2
> > > > Ethernet devices.
> > > >
> > > > The first two patches make the necessary changes so that multiple
> > > > traffic classes are configured and their statistics are displayed
> > > > in the debugfs. The third patch adds a static distribution to said
> > > > traffic classes based on the VLAN PCP field.
> > > >
> > > > The last patches add support for the congestion group taildrop
> > > > mechanism that allows us to control the number of frames that can
> > > > accumulate on a group of Rx frame queues belonging to the same traf=
fic
> class.
> > >
> > > Ah, I miseed you already sent a v2. Same question applies:
> > >
> > > > How is this configured from the user perspective? I looked through
> > > > the patches and I see no information on how the input is taken
> > > > from the user.
> >
> > There is no input taken from the user at the moment. The traffic class
> > id is statically selected based on the VLAN PCP field. The
> > configuration for this is added in patch 3/7.
>=20
> Having some defaults for RX queue per TC is understandable. But patch 1
> changes how many RX queues are used in the first place. Why if user does =
not
> need RX queues per TC?

In DPAA2 we have a boot time configurable system in which the user can sele=
ct
for each interface how many queues and how many traffic classes it needs.

The driver picks these up from firmware and configures the traffic class
distribution only if there is more than one requested.
With one TC the behavior of the driver is exactly as before.

Ioana
