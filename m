Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209806E553
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 14:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfGSMCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 08:02:34 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:58976 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSMCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 08:02:34 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: hhSV7vdT/xgJZPhGXy0G9V7ZGej3qs4f36g0OTva6tWKDgq21ZLikgcGiaG3YNP0i2MqnvCZ7u
 4ny+vyQA2Ygy5AgUHNMhHURqYQap12nwJjqXO/LxOp0f/BYvGdFRRbtL85bceV0JFjQ7t+gtFt
 yEAHQnCv28gY/qJKsM7ELB2vs/xfZuOX3ZJKWpdvrb3qNtAwxHwerAjZyXmwnHsnv7B8NYp8fY
 /TCcuwAgYWbFp5s3rzzq6Di3NhzJLLZuD8GCVzhxrjF4uTL+YCH5ijFWt99rUTOw2WicUBi8Y7
 aIQ=
X-IronPort-AV: E=Sophos;i="5.64,282,1559545200"; 
   d="scan'208";a="38940474"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2019 05:02:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex04.mchp-main.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jul 2019 05:02:28 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 19 Jul 2019 05:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Se9fsUH9xmiGFQB03qMb71NGcjI1BoDGwgI0BZOiNVFGqAF7jYLGuFumJdJkWq6rXkOqP0PQOf0OUQO0p+grsWaS1wVVBBH5ZGKNIIuOS8BnGsWCIFLbHP5Xpir3Q8tKXdHzfWa9pKH5sordFHTN1tTi7OEeAHRNFFBCRinbx0F0rM2G/OOUzX7BHYnZUKPiUMA17LgI+QDdenH0uOVGw0ag6lFGMrZ/PqIwegjgySxgmtD4AeU9H3MqjtF90Y/Ejr0x8gteVhv6ZbKJiTEPpf61Gmvq0nj99Mks/vwC8lq7m9L2t8C4qkFbueYi4VSY3UsrtNPfi2LwErIkGOUtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLgSdNheLBYoV3cZmJMyKa3Av1xxH32HlakjFSalh+Q=;
 b=H6vJvNXTabgcUvtdDLAzlyFea16pkIlj7rCggnLkH5iH9//SWMVlFlqYEzSKXyvODCfEdrAMzxQ8j4Y2o5XzPGO+OxueZRb9IOC/3GKHoOi7vdC4739At2lDzpPCUa2Lt7jZD+2Q3d/+DuQNa9UgJb0jYoeVA/PwqCdqmUcM5zORiZ0cboDBr1Shc2B2naod1LmUZkyHB2RdrqvbemaN+5iBs962K4RZLdkciJQv26HEI917+uyqgl09cz7GvmQGIDeY5gm6VMBLWAkx4/+NnyNS6Xv62u5ql0AM4RG0C8iDWGj/fMn7E6huVfAvbVII8zBLcPB2h4jCPbh99539fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microchip.com;dmarc=pass action=none
 header.from=microchip.com;dkim=pass header.d=microchip.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLgSdNheLBYoV3cZmJMyKa3Av1xxH32HlakjFSalh+Q=;
 b=f8l16urF7kdiqKR2LnuAIel4q7+JWlo0Mhaz26eOhABceCex/Q5aB93RZYwJIdosN5AbP5A0Z9WWliGlQWAFfzqtA3skFy/Q+BzuHtIEMi7UeYZ2UCG7f7rWdhuYAPo9OoHYfGuQcCJKZXxzKqrqtSetw5pY+Qm+CkQll0V/TIM=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1998.namprd11.prod.outlook.com (10.169.231.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Fri, 19 Jul 2019 12:02:27 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::558b:94f:fdae:3af6]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::558b:94f:fdae:3af6%8]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 12:02:27 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <yash.shah@sifive.com>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     <mark.rutland@arm.com>, <palmer@sifive.com>,
        <aou@eecs.berkeley.edu>, <ynezz@true.cz>, <sachin.ghadi@sifive.com>
Subject: Re: [PATCH 1/3] macb: bindings doc: update sifive fu540-c000 binding
Thread-Topic: [PATCH 1/3] macb: bindings doc: update sifive fu540-c000 binding
Thread-Index: AQHVPiK7bneqVw6vtU6/SDl9i+uEO6bR11wA
Date:   Fri, 19 Jul 2019 12:02:27 +0000
Message-ID: <443fd93a-ff6f-1641-89ec-f35f39de3688@microchip.com>
References: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
In-Reply-To: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:40::41) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5af331b2-9e24-4250-dc59-08d70c40f7e3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1998;
x-ms-traffictypediagnostic: MWHPR11MB1998:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR11MB1998F508E9F3E3DC04A229BAE0CB0@MWHPR11MB1998.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(256004)(316002)(186003)(7736002)(305945005)(110136005)(486006)(52116002)(76176011)(99286004)(68736007)(2201001)(36756003)(229853002)(7416002)(25786009)(54906003)(2501003)(102836004)(26005)(31686004)(6116002)(3846002)(6506007)(53546011)(6436002)(6486002)(386003)(476003)(11346002)(86362001)(2616005)(14454004)(446003)(6306002)(6512007)(64756008)(66476007)(66556008)(66946007)(4326008)(2906002)(478600001)(81166006)(966005)(8936002)(81156014)(71200400001)(8676002)(71190400001)(5660300002)(31696002)(6246003)(66066001)(53936002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1998;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NpnGsfApiMFCuWUxAJRkfcAmIm0cArJDy61GtovnqPBqI45wdayHfIcWA7fIKLX5W9sLp/bwZobZCF9EaTI1nBhBHOB2pvdBgmuWv00wOpz0/EDjBcMVGI4qj5VcVopHvOGIgoxLOf5KmDrJ+VZ/JTzEoNnUkQFDjbRK3scVRVIaApJblUXs9hPyo0Vvj89lGlfa4bF/SM3nHdaNNkBG3SZCvy7+kd1gQND9yq8LfSOeKKS22VxsTaPXxRIX5hRF4/p5QbZVXhunjKEfu8kDJxSLCpJOnt3aoFDlVnfRG7SC4RjT/PSTUtZCdwLq3t+I6++IYI1yHiT+vPpWk6o/MGWY38Rh5E/jcfEld/z5uxuWsnJQdWuOJR4cWxmAATsEId8kqzWbyfELGKjsZQ+jZbsByk+orVczJahn4SlrgEk=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <165F3368D1BE9941BA62F18B715B2CA7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af331b2-9e24-4250-dc59-08d70c40f7e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 12:02:27.4321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1998
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2019 at 13:10, Yash Shah wrote:
> As per the discussion with Nicolas Ferre, rename the compatible property
> to a more appropriate and specific string.
> LINK: https://lkml.org/lkml/2019/7/17/200
>=20
> Signed-off-by: Yash Shah <yash.shah@sifive.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   Documentation/devicetree/bindings/net/macb.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentati=
on/devicetree/bindings/net/macb.txt
> index 63c73fa..0b61a90 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -15,10 +15,10 @@ Required properties:
>     Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sa=
ma5d4 SoCs.
>     Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
>     Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
> -  Use "sifive,fu540-macb" for SiFive FU540-C000 SoC.
> +  Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
>     Or the generic form: "cdns,emac".
>   - reg: Address and length of the register set for the device
> -	For "sifive,fu540-macb", second range is required to specify the
> +	For "sifive,fu540-c000-gem", second range is required to specify the
>   	address and length of the registers for GEMGXL Management block.
>   - interrupts: Should contain macb interrupt
>   - phy-mode: See ethernet.txt file in the same directory.
>=20


--=20
Nicolas Ferre
