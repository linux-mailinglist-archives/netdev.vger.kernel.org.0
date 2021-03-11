Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5F337EA3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCKUCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:02:46 -0500
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:65019
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229675AbhCKUCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:02:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKjaQpoHX+oTy8Xmg1CWuOfsD0kdyRpFUs2Tjo8dGPeklRU7PHFB8knenpTIHiX8eL9DlU2RAoNbEYVuOyPhQ9vwUYB9jiO2FDeXTWvGsGjUTJU3oyQxtLJYZ3kArV+z1lc5sLwbJXxbK+Ur1/75QFlFop578pa17sA5+gm1B+pk+07JY2xKl+UU9Y6UTTjsMLonYYYvTPwjfZMoXPqaXQ7N8pqeo49qFT4SaHF+hGOjYHDGqNex0a7Oeu+T2Y3jXZFJ9gPqNFw+J8iKM7qwc3jE5zBZ8X6hWMbkiF4+oiNZdWyKSOc1MYa33SeEbxZpASWX5dTt946FM5RZm4IMrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OxblKuxqr4+O9YqYOXIcT91iocF0pSRDo5jw5CICXY=;
 b=dkNJJkQP7f+nIr5zzBgc9JbVedotfbOi25V3PzM5T3WGdClBKmyyk+SBqU+fIbYbpvTRBYPqI+86EzR7T9et6JxhsqRwa8TRXwOK8HkmmN1xAC+s4OZAoc3gG0kG78KSHnXPnsYErnLOHrInJfsgWYJsPE3x043eWZcntIAmz0e/4NoiRE0zLbvl4QXNMUrWyny+rOAWDZv3OpHLgvrfOTZx9/CF/QWCx3m/E3nLTs9OqPVev89T+n+j+t/tlkfRuZn0yzLvGEeU9o4pzYn1DDC1s33m9dF2ZYUqzJbuV5kiFtr6QmsKwwf2XPR+nRDw31M9csntmDox/MEy0Ke1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OxblKuxqr4+O9YqYOXIcT91iocF0pSRDo5jw5CICXY=;
 b=Fck2u+rdmtT9goGqmUUgO4tIeztj8CMMSLQawWzjkP8FPsMsuiUxdmXRqLZ6/IKRq4nN9SSspvdg0dRLf2MGmDILUq4pFOKq1vsRDUdXCfnD/PuIc+MUGrOMvcGbWLROGpmbAz9v/mHFUBEgM8RBe7yu2aKAjw6QyzoUc9g6XD8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 20:02:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3912.028; Thu, 11 Mar 2021
 20:02:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ocelot: Extend MRP
Thread-Topic: [PATCH net-next] net: ocelot: Extend MRP
Thread-Index: AQHXFe9o676ST1OCi02wgkx0HQevhap97k2AgAE/uACAAAkLAA==
Date:   Thu, 11 Mar 2021 20:02:30 +0000
Message-ID: <20210311200230.k4jzp44lcphhtuor@skbuf>
References: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
 <20210311002549.4ilz4fw2t6sdxxtv@skbuf>
 <20210311193008.vasrdiephy36fnxa@soft-dev3-1.localhost>
In-Reply-To: <20210311193008.vasrdiephy36fnxa@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f3a9d09-2106-465e-e103-08d8e4c89a64
x-ms-traffictypediagnostic: VE1PR04MB7325:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB73259602B0DCBBF2B7E859E4E0909@VE1PR04MB7325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2cNsZSKAnChFC6dpzSXu9CAN1jR1iCUzhnmMoWWWfJ4y39xFRIMlwSuHXeA8Fc+qvd0H5kn+ODQje7G13RTtimwBqv8WQS1zE8nD/LUtowmDQH21y/T/8SK56m7zdvM12rp4K8/qTfPvF69i5mQ28y7t/uzHNEhqL608LVI1yBPo7Zbzx8PCsLmSAiZ+1xgsRdep9zWxTYNDdlrB4WOL8P0Nfcivr4JLlKSwxMhaLlV1N4y7iUgaRyZPXH3jRASmB/55L34bYVx1hQKj0YKH5yZWwlRHKfCSlpmldVnEEqOkYPE+WvxWmEDtSvhRsKPYBc3D0nMYiHtG8yTkl0vpd3eWWYh8SYWuapW0K8nsSi2WaIepZlmvNRv2gX49sZ6PPxAeL8Y96TYSNKPEBDKc57cXzS/AMC9Wjehnvs710XPm65ZQjyhtklfa6hc/Hhjhz3xWBNOO5Ha3/EWgEpDlgIUKOrFEhZOak4tVtjMR8WycWvegmwGLKF7sJteoQ6CBSMKhkCCrNiXcbsJNY+zfE/XlWYGKvCWTyykcVECl8BfnaXU9lA6K9B1k0N5FmH9j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(64756008)(66556008)(66946007)(66446008)(66476007)(76116006)(186003)(33716001)(6506007)(83380400001)(54906003)(316002)(4326008)(8676002)(44832011)(1076003)(5660300002)(478600001)(6916009)(6486002)(71200400001)(86362001)(8936002)(26005)(9686003)(6512007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yHnxJepLhOPRF4kzLzXI6dXbNmdArsUtgSCZwpTU71Ew6OkzEcyGEFUxReRR?=
 =?us-ascii?Q?fPA+uZW24WzCEKIykX4k0tQEJ0//ccT6t7zjmQLMAPqYb7h4SJmhX+mRMlPZ?=
 =?us-ascii?Q?vYShs0pJBmPCOX/auqMy/0IASW9aq3Wijq7GErImZBVkRt3fW0EHkVwa+/Qq?=
 =?us-ascii?Q?xL0LlPHmkBjAEp0ISu6ogQpT6VnX8RITMl3D59JU5NCY4Hy0alqceOW7UZyp?=
 =?us-ascii?Q?blkqUCRkq/60KC5irLXblCKZ19jMQA1gGFCxTZHkpIC4I5MnPAWYjAzHPPfv?=
 =?us-ascii?Q?pAN70EMtRsCPZVju4nAxy86a4jp0XYDVd3ASkOtAkaAeZ+7WmPI7gVz8EtDu?=
 =?us-ascii?Q?7GhrPljNxikTfPM53dbLhupJ/UtdKQGl4D3YQsAaphxGTqEkGFAyU9GtKgDT?=
 =?us-ascii?Q?DJcifkqmWgxeDTqB6WybeHwl3gzpQ3RpCwJKtSAfw8lhQwZN3H6YIXP16VVy?=
 =?us-ascii?Q?Zk8kgLy8WwwxU5VL1f91fkvgQPKqv2Mtux1mFOHS32qbadrT4F8E/zijq6FF?=
 =?us-ascii?Q?CYIydEeCiMp+AqF1eP1wpQDIJbBFbru5hWltqHIex1xdPyRJXk1W7ZIrWg97?=
 =?us-ascii?Q?1TBMKbO/crrosdun0sWtuBm791/W6xZXCfvnFqolaaD779xcVTXxhgGCj15z?=
 =?us-ascii?Q?gu1VzqJ9uqS2T5lYx5MR1PmmxfBNMg5U/fLIb/fHRp9hL6bOkv2UpuTgF/8V?=
 =?us-ascii?Q?1xkhlXnYPCU93whHOxILSwHgGrd/HZq/ZK+kmb4kYDI752fkCrtxk+umNRja?=
 =?us-ascii?Q?H7ZBaTyVkDMQmLAWb8ZScqXIk+0zAF0Jfcl5Egyq3hzHGwL+8h/uDBvq48Sq?=
 =?us-ascii?Q?Z8Fpa9ZlPDywdt3/fmCbqahQChe4DFmEccVhgZZsfmlRLUEuagYiT24kzK0R?=
 =?us-ascii?Q?Pt+X8vYM2QrIa1Fdmo8yZ6P9Eh7hx11HU/KnGMk+iVEjD+AtJ1JpsxF+d+QE?=
 =?us-ascii?Q?c/HzpUDVBh5+fSqqySoAzM8xywZl79khLakwtOL7Lqj5cxBsQWLGGZ4+UvM0?=
 =?us-ascii?Q?wrp0RKOdvZk2wq9Kr6HZVZc7HzEEvmJ73MSTFc2ZIN8HdL2p3NC9IHzv9f3v?=
 =?us-ascii?Q?QQfY+s7bGuDOUh5ZwN0omFNWEcYqwI+cWrJ5GBQRxP16ckSzh0wLKgy6or9F?=
 =?us-ascii?Q?GHZTbsmq6YVc29SeMvKT4Ck/vbWxwRILjoYZDrrYm5y2Gk0j/2Mr6qgiHi+d?=
 =?us-ascii?Q?gog0gHalH+C9RN/zfrsIFvqNxlibgYm12dhHP5kPkYKPmUE64HcFvJPapCDr?=
 =?us-ascii?Q?BctE9sWVfQi3SRcbquNbVksK1UkY9Jn3hph1KEMGStu6GObOF80kXN3OHm1s?=
 =?us-ascii?Q?rgyx+BXkePuqVjA+/nrz/8InC222+v+IX279vNS6Arc2PQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30AB007EA4D5604987404E5805773341@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3a9d09-2106-465e-e103-08d8e4c89a64
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 20:02:30.6590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qPfsQD6r3LzwTOcIaXifp89Su+JZhtk6HOT1v6U2/El4BrTWdYS4Gv1rSzvN3bfWKHDJDqGA5+fT3fDRUt6SXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:30:08PM +0100, Horatiu Vultur wrote:
> > > +static void ocelot_mrp_save_mac(struct ocelot *ocelot,
> > > +                             struct ocelot_port *port)
> > > +{
> > > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_test_dmac,
> > > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> > > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_control_dmac,
> > > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> >
> > Let me make sure I understand.
> > By learning these multicast addresses, you mark them as 'not unknown' i=
n
> > the MAC table, because otherwise they will be flooded, including to the
> > CPU port module, and there's no way you can remove the CPU from the
> > flood mask, even if the packets get later redirected through VCAP IS2?
>
> Yes, so far you are right.
>
> > I mean that's the reason why we have the policer on the CPU port for th=
e
> > drop action in ocelot_vcap_init, no?
>
> I am not sure that would work because I want the action to be redirect
> and not policy. Or maybe I am missing something?

Yes, it is not the same context as for tc-drop. The problem for tc-drop
was that the packets would get removed from the hardware datapath, but
they would still get copied to the CPU nonetheless. A policer there was
an OK solution because we wanted to kill those packets completely. Here,
the problem is the same, but we cannot use the same solution, since a
policer will also prevent the frames from being redirected.

> >
> > > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > > index 425ff29d9389..c41696d2e82b 100644
> > > --- a/include/soc/mscc/ocelot.h
> > > +++ b/include/soc/mscc/ocelot.h
> > > @@ -51,6 +51,7 @@
> > >   */
> > >
> > >  /* Reserve some destination PGIDs at the end of the range:
> > > + * PGID_MRP: used for not flooding MRP frames to CPU
> >
> > Could this be named PGID_BLACKHOLE or something? It isn't specific to
> > MRP if I understand correctly. We should also probably initialize it
> > with zero.
>
> It shouldn't matter the value, what is important that the CPU port not
> to be set. Because the value of this PGID will not be used in the
> fowarding decision.
> Currently only MRP is using it so that is the reason for naming it like
> that but I can rename it and initialized it to 0 to be more clear.

So tell me more about this behavior.
Is there no way to suppress the flooding to CPU action, even if the
frame was hit by a TCAM rule? Let's forget about MRP, assume this is an
broadcast IPv4 packet, and we have a matching src_ip rule to perform
mirred egress redirect to another port.
Would the CPU be flooded with this traffic too? What would you do to
avoid that situation?=
