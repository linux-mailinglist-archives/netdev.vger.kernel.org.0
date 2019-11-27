Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04D10B5C6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK0Sb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:31:58 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:38711 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0Sb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:31:58 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: To6RpGLb/CIBhVybQX3Ldd7xATHcKL8VUSAk1l3EbS8NIKJRSWW+H46On0eQjxEZiygUWGllGb
 3nIkGeuEM1O7cEEywoZkpqu9bcCG0CtUWwOB1D9eyqHRNlsxDtCmtMszeZ4lo5d609YAQjGvc5
 4Nwwrxvn6E1345hCfYVojmBgQjhHz//AfwQAS7xrTayjp5Sl210Li6334HdsttFSJJZU+l1F7j
 RgHXu0XeAVJv4UmHC1ZvUz0y4jb3v0ooMddox9KYsitrrpAjhhKyW4gZ/c0WnzO/xqf+VLWRcV
 DXI=
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="57086443"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2019 11:31:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 11:31:57 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 27 Nov 2019 11:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3jdPzndjiXvkGz90mz0AeIf3n/77CejMRdgblkAZegdAhlBt8gr3vA7hEqcDJJrJakOBno7qgnKpjNCVkpdZOC7zqtROZnjft3yNbht3S+Vi2FD1oYWXE8WI5/N9Hce/StMM+YliPP1inzZGpPsXqCl53md7Qdv/2RQ7mYCfSggDBMQyJlcXhpBWPMF6NQxbI7EF02Xf5+yjHuTjLZe7NGBtWEb+38zl1ETY/Pwkd5JjSmfjMRRw8VJcwBgGDMu1cpT4JpCtXHyXbBizc9FaCGhLoBbFpTnZ8CDxqWm2z3/N1i1VvLw1WGtEa2Nr8SJvRSVn08CHoGx4YQViWQ4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w17MRqhRbdOeqVeduXVBd2LnN6kXWKpGqRP7PuX0rXE=;
 b=UvVRnIM1j9dR9YyvS94cmzKgCScdiZtbNsa2BonMcyq53b4l+J1osAaHALwZX+nRqlyU/CjwEkCx/5AccFCYLFSMBcCLOUiGru1k40A1hd63BgiymjUyBojqqtrWqUQ5vFQ/bHoFpwr5jmfllCNY99VCdKJUgavRcq4SI+Uy28kSg4R76G8QoPP8uJHtXvzeKLznyZMwC27EIuDSXcA9ruhZgcV45Ntf728cqRtjy0uHQEhUW7TB0p1O4aLGHJPOqJfmsYOiYASHxHlbwaM1rGMmdEnyGutCYJ39P+SkWJ8vhNp8fmQwTjxBWQe+QEszFQSVsqQpPAQKua9wUL5c7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w17MRqhRbdOeqVeduXVBd2LnN6kXWKpGqRP7PuX0rXE=;
 b=oAJpEw83m5NT3kbwTs9wM8QUHXT4xePCKtGzRMbwQtebhPO2AbXMxCEVg6NBoKkJgb9XUZ5qcAcokgENRglMEELmRefRRxDnQ8K8r84sHHWMClnCQ8I8yXceTDURojkkNVefVNFS/zztx0s9GTYkbFqOKhafgpeSBoOWxJf9knU=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (52.135.93.21) by
 SN6PR11MB3024.namprd11.prod.outlook.com (52.135.125.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18; Wed, 27 Nov 2019 18:31:54 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::74c7:7e0e:5565:a0e5]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::74c7:7e0e:5565:a0e5%7]) with mapi id 15.20.2474.022; Wed, 27 Nov 2019
 18:31:54 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <andrew@lunn.ch>, <mparab@cadence.com>
CC:     <antoine.tenart@bootlin.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Thread-Topic: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Thread-Index: AQHVpVDxAflWsMDSIE2xhPpOe+lx7Q==
Date:   Wed, 27 Nov 2019 18:31:54 +0000
Message-ID: <19694e5a-17df-608f-5db7-5da288e5e7cd@microchip.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
 <20191126143717.GP6602@lunn.ch>
In-Reply-To: <20191126143717.GP6602@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0158.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::26) To SN6PR11MB2830.namprd11.prod.outlook.com
 (2603:10b6:805:5b::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a01:cb1c:a97:7600:4101:ade1:25ee:c9ca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e21f681-a5f2-4e86-7263-08d773681393
x-ms-traffictypediagnostic: SN6PR11MB3024:
x-microsoft-antispam-prvs: <SN6PR11MB30241E70680D93AC82E9C769E0440@SN6PR11MB3024.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(366004)(396003)(346002)(199004)(189003)(7416002)(2906002)(81156014)(5660300002)(14444005)(64756008)(66556008)(66476007)(66446008)(186003)(4744005)(99286004)(81166006)(46003)(8676002)(229853002)(102836004)(14454004)(8936002)(6486002)(54906003)(66946007)(256004)(76176011)(6512007)(110136005)(53546011)(52116002)(316002)(386003)(6506007)(86362001)(71190400001)(4326008)(31686004)(6246003)(36756003)(2616005)(11346002)(6116002)(446003)(7736002)(25786009)(478600001)(71200400001)(31696002)(6436002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3024;H:SN6PR11MB2830.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dImwJnts1zrpeqTXxpVCUvztSJxjR2CEgiOWz5KBpLwOcGMgOV+E0Sshs5AoZOuplEiz9MGMbptVXe+FVoK2ZoHjBKfz9il8uTIRIP6Lzve/xfqMjg4+heeUWJse2Mpuft2RllpLaFkPI1dhESbhol03FK0wzath03F3EWsEbuUXpXXIrsVfWBOtUB1PEoCikvMrb2h2hR1KZbtAA+HgSe1zrkmSQpVA2GoFoifPhDqQ2CxvN3DxXy3cGN7VqzS5VYFpTdmNctssFrZ3OrOXVSBo7og/akLpRSuw0sgL4jaJPpxzYP1+TwkS/+rUOf8AcGkTJiFKKvY+Y48tag7MYQ0ZulXzc1nkli4jokJej/Xkh8r8Sqbimv0tI92yMqgX5ZnW+f2b943z1K76FsAtF6M19h7Pkj/oGqJhOX3KS704AqB8XbhaXXJLBoI9/Tc
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <EC2B433C43DE0D4082513FE2CE2F667F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e21f681-a5f2-4e86-7263-08d773681393
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 18:31:54.1825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emNRPWA8Xz9s3BV/otf569r9QdM2z9YAaZID2L74s48DLJ9KzYZz3rxpsq5ZLu55jwWXol2GPFSclTlprhhXHXp4fe4/JXZ19dRj6/Le39M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3024
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/11/2019 at 15:37, Andrew Lunn wrote:
> On Tue, Nov 26, 2019 at 09:09:49AM +0000, Milind Parab wrote:
>> This patch modify MDIO read/write functions to support
>> communication with C45 PHY.
>=20
> I think i've asked this before, at least once, but you have not added
> it to the commit messages. Do all generations of the macb support C45?

For what I can tell from the different IP revisions that we implemented=20
throughout the years in Atmel then Microchip products (back to=20
at91rm9200 and at91sam9263), it seems yes.

The "PHY Maintenance Register" "MACB_MAN_*" was always present with the=20
same bits 32-28 layout (with somehow different names).

But definitively we would need to hear that from Cadence itself which=20
would be far better.

[..]

Best regards,
--=20
Nicolas Ferre
