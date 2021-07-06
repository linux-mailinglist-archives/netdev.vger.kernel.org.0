Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1146E3BCAB9
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 12:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhGFKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 06:50:22 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57593 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhGFKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 06:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625568457; x=1657104457;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0HeHvxQUl+uSbvupGsQSNn3KcUykvFBbNZ+O9GrF1VI=;
  b=XJf0mzQrEWAHXE3Rb+ItgxUH476DZkl9A88uJztLt6TMA7HK11LVjNny
   7bM4VBuSWsHHAXwQpez3DCMfMDp9pVj4kqWCaCgTqFdZkdx55DRjP1VDy
   dx4nnURcVPMmPi7xGlb56eNJQr3WsUU/0YYmUOlevvmnOVWEdSUanbtO1
   aoBGzEAyVi0gLenJ13SZ68arHYmk9f28nX8BXxBU/uFNJ8pyupOAy5hbV
   Y7yainUyFPXaUGSwSSSgupBaXra/pZXbbDovsDUudYbZrwONOiPj8pdmC
   HJGUANgQxgJO2RyyyVTfhlOGPgRK2DiI6SgXB2fKce0wbYcaWoVJi5lbl
   g==;
IronPort-SDR: icKNRiWxHG7lNdL2j1zG3AM6Rff9NRVHa2U8qq5PN+w3lnrwv88m0NJ+vDnvjBPTnlvQlLSWiY
 oV40So3615VozUwETZcrWCJ/Cag/SBsZaRNZu0wtfu8G1FzbF4vtPT4aMn2gGoVyzGOc6RbbiX
 19qvZ/iopksKzx8CU3FNDuGYacgHlYkfjA5T2x57XQ0pa0KYLrP1gjhgIeShC+Z6g6gsjr/iGV
 dx6BXlJlasDPN9f96BmY2G47ZRWHnAhVl88LxfDWuGPlVs3ZxcLDBykvVEkgDeRA3Z8Qw8Rdrz
 sMU=
X-IronPort-AV: E=Sophos;i="5.83,328,1616428800"; 
   d="scan'208";a="173811830"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2021 18:47:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1PBQSNbLP7XtlGmB5KcSs13NdQIrRYOzUBf1Qey9dUnfluE1uXynE5g934ofcbQzWaUeXuECqSDR8e/yRvrMfmTiLeqqPPVPf045Fbt7ltBfAT8enS3QHixZxWMJOu71GhKqpQg2xTAXNN/a2mVS5f3ov34/X2RQY/IkT7/m4i7VKWjBa2qs90Kv+vU3WnP+k8c8ByqPYQH/SnPVAoBKYpst36KIbUUi+xLGDhkVh9Y6OUugKYZEIzIFCQlvbbMACbWvgGBvWbtsat3IqZ+MLh1sKJFihve8nMAHdhWXqge/x5CndAzpKbC2mcVNlaIMA0/nGu/sPSjvDilqtR1kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WRmmxKbjWu7b7FYVCfBytnp1iB0TACw0ikNuib3atc=;
 b=RnbmuVZgg01FnMDB4YInH3bMKjHBXR/MdX2S6O6E0SZ65EHgJPOYeOjKzliPtAst+UkSXL2uSu8ySk1UEbXsZbkvnBhMvQD6oS++WR1n7rdeGyBOIVaLaXuW/R9TOYVGThVfsn7mHlzUADYIoiP2Yxzkk8rnFuzQrhHhT8EmMmt0ORzyjjMx27DhxAfg3hLJtN58x5EL65V2/438yY++lWrQeCuVRAU093zrWCmVuMNLdC+5FfjRETIs8oAj8Q+dXD41Gl49RJGX2+IsTkaNjWS3mXlO/u2Wm7TbbnW1qslo+mdf40b8J30t4aD+/9ME1EuhDzfZ0P6BoBL/DOVWMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WRmmxKbjWu7b7FYVCfBytnp1iB0TACw0ikNuib3atc=;
 b=rLwdpXkK6Q78IHG9Q1WJvNUeCZg6kPjSrovy5PgxOhwrhfUCzjk1umY6g2M4H9gKmS0Jy8zEwWcb5FsXkbyPu7fwEqCsRPgkxoMm+DIPL9A2ShiY66nkulRkOuS7Xy9VIVGaVpJ8TGXsf9n7on8l+mkyqLl93iT3dX0RxUPgfmU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7702.namprd04.prod.outlook.com (2603:10b6:510:5d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Tue, 6 Jul
 2021 10:47:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d978:d61e:2fc4:b8a3]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d978:d61e:2fc4:b8a3%8]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 10:47:28 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "industrypack-devel@lists.sourceforge.net" 
        <industrypack-devel@lists.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "greybus-dev@lists.linaro.org" <greybus-dev@lists.linaro.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] bus: Make remove callback return void
Thread-Topic: [PATCH] bus: Make remove callback return void
Thread-Index: AQHXclKxeSX1CgceMkmBp4EcubGaMw==
Date:   Tue, 6 Jul 2021 10:47:28 +0000
Message-ID: <PH0PR04MB7416BD31D84E2F63346A6F709B1B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
 <YOQxRS8HLTYthWNn@dell>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dc4ccbf-e097-4bf2-f839-08d9406b7312
x-ms-traffictypediagnostic: PH0PR04MB7702:
x-microsoft-antispam-prvs: <PH0PR04MB770242BAE89F9DA372A8EAA69B1B9@PH0PR04MB7702.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TDUwnoFGZT63FYynAb9ayiBh3n+sY5VDEM1e+DTT8NErFTFDuJP1XD8Yrs1G94p3yHBvxbPO1fdGSVpQUSd8BZbq62HCj9iPXqXzJBNS1Z4vbwuDSkDoYZElAI1o5CiEQj/Qz9zof9EOvRqaCkYb2RbGE8LVpJ1BrlxCJA2Jttgo/MDIX3LauPfnocQ9XOMNsDFSGyrLZKXB+pNAR9baWItvKqOai1I1tu/pYjvY/bFVgDmehwIbJ2PuN+mLMRC7D12BZNEH5iDNHJXuvdGbNPthrqiFKLBidYUuK4eAIC1gAmGIkvP4OJeEcc1q12LMtZIIgpJvMQ5ZOeA+Qpl8fiInGsoQLOn7IJIwdtQL0oA6x8Z++uBx3ECIzNo87GL9Eice7ElyS2VgC422ae/08Gbb70wcJohOpwEn/HDSo4OhZ5QtADxDkSDpFOQ9pONfEbwKk4l8BqZldLDV7Zz6SDNuzUBWN+l69a7dlxX+xMO4SWtXWRqKoyKVZZN2K3rx69YzKk0kQVgepBVegycQLwfGYoA3pdzBuLe1XoPdLkVArBFhUfCEs71wUJwSeIUGXDOOESjtgyoHIvYK8gym595gz+unxZl4JVV+BilanfDksADGOfe47kea48yKLA/Qv6lje0VEsp1y8wUcvUa9fX+pjZbPI+5CXqFZVswJFDYlsx5nsOcAQUo6/hI6mRNRGFEdJwZxsdQ7IbOjGQVBHlpCiLeXDONaki0sfmfevHWbp9bVyfC1FbV2wUch9/pu0kqRIc53B4tRPF/mjIO533d7FgMnqEiHYFvcJxuX54I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(5660300002)(122000001)(86362001)(52536014)(8676002)(4326008)(76116006)(38100700002)(8936002)(478600001)(316002)(110136005)(966005)(9686003)(6506007)(186003)(54906003)(2906002)(66946007)(7416002)(33656002)(7696005)(66446008)(64756008)(53546011)(26005)(7406005)(55016002)(66556008)(71200400001)(66476007)(83380400001)(66574015)(557034005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PNShz4sX/Zuuhh+uYepc7ZyM5a0DhCvQW4A4hBKEq08a3mtue7NlLZzIoF?=
 =?iso-8859-1?Q?1v6cGOS0v97K8wa3LN225ORoGZSneLip/2HF/7lHe06l0VW0lsaXB9N6m3?=
 =?iso-8859-1?Q?57ussSpboi6cA0PQstpKctbjttU2s5Ftu8PFDY/kSd8jRaMl8a/lIUi2EM?=
 =?iso-8859-1?Q?M3d9Oxi8gVklIxKdmUtZWMYkuzYLbZQqdr4ahCvTAOzeH77at0HjHor6nS?=
 =?iso-8859-1?Q?KXRzyQFlYgNXAlfo7XcvAz5bDZs0Z7xVkHd2DqkkKBhWwHLJ+67sYrZ+UY?=
 =?iso-8859-1?Q?hzcY+vAEO5cPj2pS1znhj3Q8CRBQfV52WJ8g8y9X1q2/u2f+zKLbJjDJ2I?=
 =?iso-8859-1?Q?eZ1JBCVWIHh2ZXML2MtW2oZE6OfBEawpZ/kaeFVJwXBzJNs21215Q0hTRc?=
 =?iso-8859-1?Q?4+1ag+YJcCGTfiLs2GHqQh+VJVz9Y5e5kbVA93Oav36Rct/Or4ByGAiWoc?=
 =?iso-8859-1?Q?vnalRtk2WyZ6roBA6Une1d3vJTWNrRZnn8rILP72FYkf6HIOiw4rY2FvOF?=
 =?iso-8859-1?Q?Xc7H63Tt5FMLhKiHp3wc7Z5tQxh24yzXqCoMoxEC7CKRXSS2666TYmHW82?=
 =?iso-8859-1?Q?/IoM0ylpJApNXlsyPpMB6OPRsNJ+FhJwYTWdCtyaN9tKGj4i5TtswnbdJO?=
 =?iso-8859-1?Q?wxSOhWfCHCDURC5SWpMo/PZOekfZvJZKdjuosTuFTCV2gETrYKsJoXheD6?=
 =?iso-8859-1?Q?0+HwTs9hL4rFkORAIts6XgXscr5NXhUJ/r1/my4CQt3ZDkmE4wwEyr793G?=
 =?iso-8859-1?Q?MyLzXY7Vna2ykFNyrk0iBlGpujjoiPWoshxVGdhZp8w9dH9d7TR09vg9C7?=
 =?iso-8859-1?Q?1Ba6R3OK+SvgviLx5DR2kFIs7KfANcgNwB+eSPU2jO+ZheRSrdYE72CHfE?=
 =?iso-8859-1?Q?bcHXBr37H4A9GenN7rA909rullCfnbyK2tMPXMYJ0iQbdu3jsfM9ZyNmla?=
 =?iso-8859-1?Q?KqaNR3BFbMMlvZYKUMD8SNDqAncs27eyay/Nk4eFBecgqLnS66Tno13Km5?=
 =?iso-8859-1?Q?fgdDmwEOxKii5gFgeM5wdA7X8bnqi5l5qzc8ewapTyg9r51UdCVszIe/XC?=
 =?iso-8859-1?Q?OeCPHk4uubgaDN8GZuxd2OMBVYX4C4KRQhZ23bwDCaqSyH+1Ft2RiNQPZU?=
 =?iso-8859-1?Q?x2E9kVh9CuvaZ41I3afmW1ttKDZRhZB4ql8z7i7LTafqM7u2ich51HG283?=
 =?iso-8859-1?Q?3cV/V+bP0rOzwTwYAoK8lLEpRezgYZ6bdjGylovdV0Opd4ZFwxHwOzmtlS?=
 =?iso-8859-1?Q?9BvD3UAnAjOwDdTAnrxgiPZuLNcT8n181celFU4NWTEAieOvvhfD0cHNPP?=
 =?iso-8859-1?Q?h8s9+BRT/uaBvYoWS9xw+ofFTXuR1WGhbQ80Kv+l5Arm/y2mNyXSG81C5N?=
 =?iso-8859-1?Q?Y86jrH9qZgxh2Q8j0zBBheMYwPwwaghA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc4ccbf-e097-4bf2-f839-08d9406b7312
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 10:47:28.4164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mg7dsWqbGzYbTl8uhsphUGed09iNxbd3NjPvryxbiSZXjb4yBk9mRE7zbRlhN3hByaJp5uI2xkek3a+5ngeLOZVjO99t5dCIyDknas4G6is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2021 12:36, Lee Jones wrote:=0A=
> On Tue, 06 Jul 2021, Uwe Kleine-K=F6nig wrote:=0A=
> =0A=
>> The driver core ignores the return value of this callback because there=
=0A=
>> is only little it can do when a device disappears.=0A=
>>=0A=
>> This is the final bit of a long lasting cleanup quest where several=0A=
>> buses were converted to also return void from their remove callback.=0A=
>> Additionally some resource leaks were fixed that were caused by drivers=
=0A=
>> returning an error code in the expectation that the driver won't go=0A=
>> away.=0A=
>>=0A=
>> With struct bus_type::remove returning void it's prevented that newly=0A=
>> implemented buses return an ignored error code and so don't anticipate=
=0A=
>> wrong expectations for driver authors.=0A=
>>=0A=
>> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>=0A=
>> ---=0A=
>> Hello,=0A=
>>=0A=
>> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remove=
=0A=
>> return void" that is not yet applied, see=0A=
>> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengutr=
onix.de.=0A=
>>=0A=
>> I tested it using allmodconfig on amd64 and arm, but I wouldn't be=0A=
>> surprised if I still missed to convert a driver. So it would be great to=
=0A=
>> get this into next early after the merge window closes.=0A=
>>=0A=
>> I send this mail to all people that get_maintainer.pl emits for this=0A=
>> patch. I wonder how many recipents will refuse this mail because of the=
=0A=
>> long Cc: list :-)=0A=
>>=0A=
>> Best regards=0A=
>> Uwe=0A=
>>=0A=
>>  arch/arm/common/locomo.c                  | 3 +--=0A=
>>  arch/arm/common/sa1111.c                  | 4 +---=0A=
>>  arch/arm/mach-rpc/ecard.c                 | 4 +---=0A=
>>  arch/mips/sgi-ip22/ip22-gio.c             | 3 +--=0A=
>>  arch/parisc/kernel/drivers.c              | 5 ++---=0A=
>>  arch/powerpc/platforms/ps3/system-bus.c   | 3 +--=0A=
>>  arch/powerpc/platforms/pseries/ibmebus.c  | 3 +--=0A=
>>  arch/powerpc/platforms/pseries/vio.c      | 3 +--=0A=
>>  drivers/acpi/bus.c                        | 3 +--=0A=
>>  drivers/amba/bus.c                        | 4 +---=0A=
>>  drivers/base/auxiliary.c                  | 4 +---=0A=
>>  drivers/base/isa.c                        | 4 +---=0A=
>>  drivers/base/platform.c                   | 4 +---=0A=
>>  drivers/bcma/main.c                       | 6 ++----=0A=
>>  drivers/bus/sunxi-rsb.c                   | 4 +---=0A=
>>  drivers/cxl/core.c                        | 3 +--=0A=
>>  drivers/dax/bus.c                         | 4 +---=0A=
>>  drivers/dma/idxd/sysfs.c                  | 4 +---=0A=
>>  drivers/firewire/core-device.c            | 4 +---=0A=
>>  drivers/firmware/arm_scmi/bus.c           | 4 +---=0A=
>>  drivers/firmware/google/coreboot_table.c  | 4 +---=0A=
>>  drivers/fpga/dfl.c                        | 4 +---=0A=
>>  drivers/hid/hid-core.c                    | 4 +---=0A=
>>  drivers/hid/intel-ish-hid/ishtp/bus.c     | 4 +---=0A=
>>  drivers/hv/vmbus_drv.c                    | 5 +----=0A=
>>  drivers/hwtracing/intel_th/core.c         | 4 +---=0A=
>>  drivers/i2c/i2c-core-base.c               | 5 +----=0A=
>>  drivers/i3c/master.c                      | 4 +---=0A=
>>  drivers/input/gameport/gameport.c         | 3 +--=0A=
>>  drivers/input/serio/serio.c               | 3 +--=0A=
>>  drivers/ipack/ipack.c                     | 4 +---=0A=
>>  drivers/macintosh/macio_asic.c            | 4 +---=0A=
>>  drivers/mcb/mcb-core.c                    | 4 +---=0A=
=0A=
Acked-by: Johannes Thumshirn <jth@kernel.org> # for drivers/mcb=0A=
