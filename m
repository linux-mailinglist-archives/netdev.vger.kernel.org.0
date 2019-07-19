Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBF56E8CC
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfGSQaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:30:22 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2837 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSQaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:30:22 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Woojung.Huh@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="Woojung.Huh@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Woojung.Huh@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Pd3SpoSWCZNc1ql8bM9WKK+WlsPFS/qpJysAO39n7a5RwmCJCKZs8S600sp7UwUbIt8gjwhnKY
 8N4lpHflv3/UyMhd31c+ZaYTVLpuLYo0+iBaF5SOa/1zflKYYGE0KMJj+AL8W7PM1a3PA/w/BD
 P+FvDl5EjH25HVJPIvgci/a2z08G3ua4dkWtVLDS0ERgrNKGh+r7goTer6nhSlv0OHYsbK/0ll
 W+b1iiZCoAbvqfibprBC3JkwcCFpM+GFdE2z6YeVFbzYUTUOpsjPYT3QUFL4skAK7ITdeICiQd
 AQY=
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="40365325"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2019 09:30:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex01.mchp-main.com (10.10.87.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jul 2019 09:30:20 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 19 Jul 2019 09:30:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOQpF0JvIE8yz8GvMGfefPcfINi8AItHe/P70LDquj/RYq0koARZsRyRvvPrVhFeiJy3VHNAxQzZx4Ij1s79DFc7BHW7E56Q76PKOkQuslmVHfSXZA10uiqGKsgcs32VyvVLIjCnI1baj6Gr3g/krRSTHjXZRxdx22WiPluNSmnVrooHCRcN+OW8cLcAEHsStOG6dec5s8lSGI/2eh8wvnLZvthzWuhMK2bDjf/zyfjQjgqDVpIPygKrTOQK1g9fXMF4Gvf1LwNUYHlsRre/hNEochNhgk4SANu2V4P/20gHMADoBQgyMtVjMx3QQ3pQC0PN0xEFTfvm88J+JeL1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vx41ok5ne+uq++xDhDwPawhysxVXsLvAdB2I112yFjI=;
 b=fLi6iMoeVev48Ihc5KPE0DRwQfudmqssKZvgd87kAln4JbpuIu2utjn12AE5lfS+x0ETSuJ9ZQXahX0NbmFPqrPxjBARV2UYgOVOlsUTImlMxfq/KvJHu/n/8awq7T/33fSSWAOfG88beRjujP4OmDx5ciilzq0bz9zIb0P75/mkaqVuZD/lc6xhf/wyfgv2prKd2j3LJo+FvbFiGs26GNxKdOvixo5ODTFX99zLcTctSgX6aXax2FvYgm+PR5Hg64g3fDNaV73Tx4qFXV4Qd6ifDSPxdnjMJPwcY31ANeHpjgTOlKepwDlZbtEkRk5fyVfUw81rvqiFIlo/4oB2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microchip.com;dmarc=pass action=none
 header.from=microchip.com;dkim=pass header.d=microchip.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vx41ok5ne+uq++xDhDwPawhysxVXsLvAdB2I112yFjI=;
 b=zkTDfDPwu3fB2dIrRTE6VENgeUYH3lzo3WbMPY78PcE1hWwqRD5E9gkhp8GQYB6nvGSTlu8cXh/j9I/IE0oPg0YKXSZiIl6o+/yJUek+nxDjeIlpEVVrkPXAUNr0j8a0hOhKCnTdK3swHwNCVBB5W364MrzIWZXsMgIqgPzn790=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (20.177.204.78) by
 BL0PR11MB3105.namprd11.prod.outlook.com (20.177.206.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 16:30:16 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::ddc2:1e17:4240:66c2]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::ddc2:1e17:4240:66c2%5]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 16:30:16 +0000
From:   <Woojung.Huh@microchip.com>
To:     <hslester96@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: lan78xx: Merge memcpy + lexx_to_cpus to
 get_unaligned_lexx
Thread-Topic: [PATCH] net: lan78xx: Merge memcpy + lexx_to_cpus to
 get_unaligned_lexx
Thread-Index: AQHVPgTHyJaBP0f9DEmIPm44Nph4NabSIkjA
Date:   Fri, 19 Jul 2019 16:30:16 +0000
Message-ID: <BL0PR11MB3012321DF5FF319EE0C50D86E7CB0@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20190719073614.1850-1-hslester96@gmail.com>
In-Reply-To: <20190719073614.1850-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28ca42f1-7cbe-461c-ba43-08d70c66621e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR11MB3105;
x-ms-traffictypediagnostic: BL0PR11MB3105:
x-microsoft-antispam-prvs: <BL0PR11MB3105F00E383DD55C043750FDE7CB0@BL0PR11MB3105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(366004)(39860400002)(346002)(189003)(199004)(3846002)(25786009)(14444005)(6116002)(86362001)(256004)(446003)(11346002)(186003)(26005)(6916009)(229853002)(476003)(102836004)(7696005)(76176011)(81166006)(74316002)(2906002)(14454004)(81156014)(6506007)(486006)(33656002)(5660300002)(52536014)(66446008)(71190400001)(71200400001)(66476007)(6246003)(53936002)(8936002)(4326008)(66556008)(305945005)(7736002)(76116006)(66066001)(4744005)(1411001)(66946007)(99286004)(478600001)(6436002)(55016002)(8676002)(68736007)(64756008)(316002)(54906003)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3105;H:BL0PR11MB3012.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DgXDteNGMROL0fwnHKytJFNE8fZcglPq1GjPSdS2BgewhgrhidEEKQMnR/gO45DjYvgpUqQMg+vQY6gUQFe3/8UF434McMUr+rtHrahmx+3/CJG1ql8PAriZ4cZIR7KEMNtgNVOijeyvs0pFwiNlv2vxOWa2HQOLAYddFD46TmH+crgnBTfBSwLDaw9HmLymOcKIxgtshVBJA2c+veOy8384sxuzElz0j3Lh7IphuNX8fZjj7S+F+hP5xA0oeXFLQYoFKwve2QdGnTAFD1aRriqACwZK5Sax+zj2HPSt+RE38WmWzbVIfiab1XVmB061WRjLu/gPmN2QLLnexRv0aoZU4KAL/0nbPMTfO8HDYQGhJDvVDFJOAoOl9QWk6kH22diqGDebvMlas9X9kympjd9/i1+8WTbVWiyf1D1KGbk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ca42f1-7cbe-461c-ba43-08d70c66621e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:30:16.6594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: woojung.huh@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Chuhong Yuan <hslester96@gmail.com>
> Sent: Friday, July 19, 2019 3:36 AM
> Cc: Woojung Huh - C21699 <Woojung.Huh@microchip.com>; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; David S . Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; linux-usb@vger.kernel.org; linux-kernel@vger.kern=
el.org; Chuhong Yuan
> <hslester96@gmail.com>
> Subject: [PATCH] net: lan78xx: Merge memcpy + lexx_to_cpus to get_unalign=
ed_lexx
>=20
> External E-Mail
>=20
>=20
> Merge the combo use of memcpy and lexx_to_cpus.
> Use get_unaligned_lexx instead.
> This simplifies the code.
>=20
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Acked-by: Woojung Huh <woojung.huh@microchip.com>
