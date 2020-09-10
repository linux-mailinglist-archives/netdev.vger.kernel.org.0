Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1642263FF6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgIJIbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:31:11 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61294 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730356AbgIJIYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599726278; x=1631262278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Yyq2EDCS2vKZmH5eLOYYicNPIXcRgkd+H8Ca+7FcXOc=;
  b=cj/9uAeAlzEQFS2eT6rVQ1IFXEBDChgI2LEhqtY4jULOSg+toOJ/EPDz
   fNwmimX5eNLs3iyo+7O2YceRwhb9OjNUoZI8ftb9utA8PClcPnH7MpT1G
   B6a5d2HZh3q+SGlLj0Pbsqa/hCRIPnuBHpdhudv4uhs69zm1L9c5ktYw1
   9PTVwt0Cv+rCyC7qXPtBQ2GMQwonSg3jWbTZcRAGCIgPV+Ln+ugGRPtBO
   k3K/WKJbsdPkSSfjZ503xX9W6ZwYmyBwxYG5DNA1VQCA/kuEe3/x95wD5
   mOpdLX6I4EyWUalzUhElLrvDCHUugaPehbn8/DGdfAgFUqTYgr108q8ud
   A==;
IronPort-SDR: ftLnKVJWWVARs6xE60k80lvcWvEF9LnNReTXi2pIeHcFd1pOvCbq5YtWKyNQKbgntoF3PJrEzZ
 yGkW+CSPkTanXwFzN+yaXQvli7N+J9TDXD7EYbxy0puKvjPuscpCKfJznonLOJ1RssHzyGXWld
 FEmXkljrjgcGdATyyJ52ywdn6YOedSeAiw39Unb2/iAlFSlX4xOSaPEQ1oDzJo6jB0orKUYHob
 8TPZOmriiXyQ/YsxyXR92KLsMxoOl9I7rBMGKN1j5VU4WXWSblm45hfVc18o3BtgyAUNaPQFAh
 yGo=
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="91279822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Sep 2020 01:24:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 01:24:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 10 Sep 2020 01:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itElKv30dbsNhtpfiKLkCOXYopTjtkZ9zEAzRioxDAmgifjIhq6QVV/lc6kfk0TIuSPX1OZAUrSDWVumK4tLXffHjOu4WRZugnRrQRvvAAgpCE7V1+zJn3PyPC0j6/G2aAtgoGzj2pGQVkq35HD5i3ZvkV68QA+ILQVSTYqBA+q+9/IrmOIYHSq5T7WknjE5tqhKpcoEPyxu0LHlp9MR91+nL0ffI8mb6UZ8R19c1Z8LDep20pLw6r6tPamTWrMJ0hAxNX35wsV6GMNcE6JFgdV5g0JfNl3CssuMyPR0eMKE/T9DeShiio5DN/5SR2TytdQ7bAPBSy6lDzF4x9zLmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BE3UD6DmJgxUoBN4fm1O92DvDQlokRm7L2E5H8tZ/w=;
 b=aw+E7ncriQCfdGAUGrQZUE/X01NpnQkPaMKg98SJOA6wY+Umt71j+ZM3yJT4X2e4Z3a1Nf1QLyhCWVWM5woSGiSrFRCtJ7Y+axoK5muAMFzy8K/q5zDKA+XhU43kGZTFp6nun78Bc4vdtny2nuHntBDykocQKzISfMU5cKF8KWDvMYiCfneJuxF9RID1NNZC8H0s/Flemt9H/8te0Tc5X4Wgyt0zHH2qftbjcUtGDix9JdV3FbJj+OP489jnkeYYjXBTFPWiX1axHsYPxivLdaeMUWo+d8svoqnPmKjaFYR7H+Czrws9kPnJiEDFXxT1EnrZJjVbs3wTlpHvyWTwVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BE3UD6DmJgxUoBN4fm1O92DvDQlokRm7L2E5H8tZ/w=;
 b=nHI74pvWX9voKu6qjF0Kfqy5Sc0AGs+NSCuuZ7eJDs13Cd2LSPaaZXvb/ZjcOfT09uuWHM6p5pmozbJumZzu3LweHgExn3n4A3SazKZjxpV5HJ3Rfd1IYhfQ1vrLcAgTG/9j9wdLhYAt6RaeZr3RJVUTfyzdVhJVMpRZmeQD3Xk=
Received: from BYAPR11MB3477.namprd11.prod.outlook.com (2603:10b6:a03:7c::28)
 by BY5PR11MB4307.namprd11.prod.outlook.com (2603:10b6:a03:1bd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 08:24:22 +0000
Received: from BYAPR11MB3477.namprd11.prod.outlook.com
 ([fe80::d1dd:de76:4e99:7c85]) by BYAPR11MB3477.namprd11.prod.outlook.com
 ([fe80::d1dd:de76:4e99:7c85%7]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 08:24:21 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <joe@perches.com>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>
CC:     <kees.cook@canonical.com>, <ndesaulniers@google.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-mips@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-ide@vger.kernel.org>,
        <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <nouveau@lists.freedesktop.org>,
        <linux-input@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <dm-devel@redhat.com>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <intel-wired-lan@lists.osuosl.org>, <oss-drivers@netronome.com>,
        <linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-nvme@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <storagedev@microchip.com>, <sparclinux@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-parisc@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-afs@lists.infradead.org>, <ceph-devel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <linux-sctp@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Eugen.Hristev@microchip.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Thread-Topic: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Thread-Index: AQHWh0vIy44IYF5A+kuaVLhVJ6ZdVw==
Date:   Thu, 10 Sep 2020 08:24:21 +0000
Message-ID: <c2929349-ca60-486d-3cad-a83321587c5f@microchip.com>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2a01:cb1c:8c:b200:d11f:426b:f805:cbe2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e351a690-85b8-47aa-f38f-08d85562eb8c
x-ms-traffictypediagnostic: BY5PR11MB4307:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4307E000D4DA0597A74F9A31E0270@BY5PR11MB4307.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rwdyTK6oNx+pJXY+VYO8jlUUcB5LsJW3ZQhau0YhpysDI1uZrWJ+5KkXmnJNABVwRpL8mxf24YLlXWyB3yirjaXQ/srQXMAk73DmLRMX7FFSd/uWs59kXpR0gz7YIDZpkdEHXR8Ks47+GSWaldjUxHW1dDgr9Bml1Ile+LfAjDi5j/2WavAN5DcmiJhVV86brSYApECTF1sqFMiIoIfargGWcDiXjLp0xoZy1wTF5cYKXSjd2DGvBQRASj+UAeO1Pg9WFEX+2sgdqqFJ/HgGUzu9uaOU20bpHBTTwQw7yoVGql5DTXE+Xr30INsHw1gSuTyHpcI3KtFhJi6QDKEIl6ZhO0EwhNcia52tqGsvyefiqtKNAZSsmZhN9N/OPaNO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3477.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(36756003)(6506007)(4744005)(53546011)(31686004)(4326008)(8676002)(31696002)(6512007)(186003)(478600001)(2616005)(107886003)(83380400001)(54906003)(110136005)(5660300002)(316002)(2906002)(6486002)(76116006)(71200400001)(91956017)(66476007)(66556008)(8936002)(66446008)(66946007)(64756008)(7416002)(7406005)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CK3jnFjP+DaxTGoKSfijNwQSDSi+zYRAANKGWEe0w6BHoCBr3jeo8QFCPrdi+OpT1qz3lmVs3mCRxOmBtUGK5WN0AxOt0wvA3bBJRUyjBicAE+lDMsP7vy1cft0wcXBrEZgdgqF7VD1sQj+khtUTD5EsNnntahNSIGqwN+VZCKQ1QzjPtAbjR2oPP/LrPDKYk//qfKAomMDI7R2fpR0tTUzDMz48DEh+PQCCmr/krCP8U3KTB6FIGhilgI7TLOfsJcLS9qlGh0PGNeVy7GIerGvFEQfkR4YdlzVLyEKvYmf4EXR5wArGM6eS5MMbLL4vYVjGrhiNaJt+earGuTqyYiFZbc+uujPQG9qCWcGOhC7tSaJvV/BIkb7lV8g/yXvxSbayqkCXQ/s7jX+D9fM+ZWNqgoWbSd/P+uuCP7/8e33PXHOet1lAM1sUIHpLxk8RCyecYucN6ijlgMa8IdFcV7U+ZA3zH97/7OWVEtd6OgF0CR21Hki2raxtlS5sca+cVURYu2gcHFAMLULSgaOruMk5qcKurGsgOTL9NDY1H7Jpn1+7gJ+bMQIt2b5OxDFW2nSizeQSfqlNFoprGc6aS71OSv+MwkoEfhBi640q5sGrdYfhliWNj5HhbdiTLJVy1TBmrhSIzi6KODxmStaMlQzfe8a1Otv3042csYwXaPKEPC9i6WiYuHbWrvEwzSbxIsAABeXwAiTaxYC040N9rw==
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0B2726412C35D14B94E876CA5EB14904@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3477.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e351a690-85b8-47aa-f38f-08d85562eb8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 08:24:21.4887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JW3oElxXZwEvl6R2z5GFIVkcX/+UpGKsEW8MKFxofB9W1y9KDMUkM69WnQUZrCOB/0mudh2ADBhfj0C34gWZhgepCXhZk3LC9prwi+CGg3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe,

Please drop this chunk: it's a successive controller version number=20
which are all backward compatible with "fallthrough" on each case so=20
removing from this last one makes it inconsistent.

In sort: NACK for atmel-mci.

Best regards,
   Nicolas


On 09/09/2020 at 22:06, Joe Perches wrote:
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 444bd3a0a922..8324312e4f42 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -2435,7 +2435,7 @@ static void atmci_get_cap(struct atmel_mci *host)
>          case 0x100:
>                  host->caps.has_bad_data_ordering =3D 0;
>                  host->caps.need_reset_after_xfer =3D 0;
> -               fallthrough;
> +               break;
>          case 0x0:
>                  break;
>          default:


--=20
Nicolas Ferre
