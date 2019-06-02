Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3232286
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 09:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfFBHuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 03:50:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46676 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfFBHuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 03:50:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x527nnvN018126;
        Sun, 2 Jun 2019 00:50:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=U/Y+saax1dAQ0eNAL2r41Z6lrdj5PTBHu0Vfi43qz9U=;
 b=hEdbjXxt54wN01rX+yV2MhTsZthXjXzbsSErq6QAAMb362V2GA1HbLAwLR20Wu6POJ0R
 /C6GeASQxMhRMMwRf3flSHGEEz0FwHCSjjSbjjz/Ar3szIYgTGs6iqpNByX196CPv8pd
 qQSJ7lJwsYfv7rJh1fVxh5/mB+Qs0Hhz20YN1klvb81YrxpfvwH5lfc6IRaZs+/ObuN0
 h1MAvvkQdSbLAbE+Ew3GkVMEcQMgpYDXBGU0mKLrNAS/hSH5iKM6d1kWgT9tVhANFVRP
 1/rfltXPetwyuj4B8K9SZ5ugE9KKi+p48byEcHGJ9PZjNGnhxgHlBP+MtxOMjAir23nI TQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2survk2xy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 02 Jun 2019 00:50:09 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 2 Jun
 2019 00:50:08 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 2 Jun 2019 00:50:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/Y+saax1dAQ0eNAL2r41Z6lrdj5PTBHu0Vfi43qz9U=;
 b=THigIyw4VT1tHNvFwaSXHCXPE7hy7Agvs50DOA/TT/tqGj6OGt8xGIYkd5gf/3RWvuJ4csu5QaT+PkrhzSAoVCDJkOfm28NRsepqVD7YnsDBrSo9w7jr8b8V//ZvM6Veal2NuuEKPVYYiSaZz+qB2O8BK1w29zbw0U9rojG3AYQ=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2589.namprd18.prod.outlook.com (20.179.82.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Sun, 2 Jun 2019 07:50:06 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413%3]) with mapi id 15.20.1922.025; Sun, 2 Jun 2019
 07:50:06 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ariel Elior <aelior@marvell.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] qed: Fix build error without CONFIG_DEVLINK
Thread-Topic: [PATCH net-next] qed: Fix build error without CONFIG_DEVLINK
Thread-Index: AQHVGFD4gMyJs5ZeR0mTxcaxDoreq6aH/tsA
Date:   Sun, 2 Jun 2019 07:50:05 +0000
Message-ID: <MN2PR18MB31826214544CB3DFD79A2671A11B0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190601080605.13052-1-yuehaibing@huawei.com>
In-Reply-To: <20190601080605.13052-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 760ca41f-ab3c-4b36-21c5-08d6e72eeda2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2589;
x-ms-traffictypediagnostic: MN2PR18MB2589:
x-microsoft-antispam-prvs: <MN2PR18MB2589A52CA4CB31B6122E4308A11B0@MN2PR18MB2589.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(376002)(136003)(346002)(199004)(189003)(74316002)(99286004)(6116002)(3846002)(66066001)(52536014)(446003)(11346002)(486006)(476003)(4744005)(5660300002)(6636002)(478600001)(6436002)(71200400001)(71190400001)(86362001)(66946007)(73956011)(229853002)(9686003)(76116006)(316002)(66556008)(66476007)(64756008)(66446008)(2201001)(55016002)(68736007)(8936002)(81156014)(8676002)(2501003)(81166006)(186003)(256004)(6246003)(2906002)(53936002)(4326008)(110136005)(6506007)(76176011)(7696005)(7736002)(305945005)(54906003)(25786009)(102836004)(33656002)(14454004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2589;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SOxPeklc8bfb9iQHlD6Ec8IX1Q6LV+TMgfagmqIaZpGfPn6ml4s088uJC/Dw4oO1JvBeee3oy3XS5jscNSYW7Qj+SE42QDuhCqGjT3zTKufsCMtrMmFNZ86L9d4Htn93X8qNB7zRWebnOhwpVWelsISjAS4XBnud8MLptgfhsI2XgW7D6sHrBoF8SkjnkrSzTuKAXrCmZeF6gRdKYEZzqiM2gleVbFQ2/EwjWH1E6SA15dQIusaEwGBmPk75TFEBifvAdYMRTK06wWn/bvVWkq9yXnWw9hiAXJRYVn7dV8nyvs/sTpxYvPPXLJNBYsH6CfHLH7gmilFmcD4eVVGRjvx3TkMIl3mWIFFocozzQ2J0zg/g0poyybglonEOqIv1Zcu0ILkOUbJRrW7sI6GJhfUUFEp0jfHMOJP4rXzO/cQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 760ca41f-ab3c-4b36-21c5-08d6e72eeda2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 07:50:05.9761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2589
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-02_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of YueHaibing
>=20
> Fix gcc build error while CONFIG_DEVLINK is not set
>=20
> drivers/net/ethernet/qlogic/qed/qed_main.o: In function `qed_remove':
> qed_main.c:(.text+0x1eb4): undefined reference to `devlink_unregister'
>=20
> Select DEVLINK to fix this.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 24e04879abdd ("qed: Add qed devlink parameters table")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/qlogic/Kconfig
> b/drivers/net/ethernet/qlogic/Kconfig
> index fdbb3ce..a391cf6 100644
> --- a/drivers/net/ethernet/qlogic/Kconfig
> +++ b/drivers/net/ethernet/qlogic/Kconfig
> @@ -87,6 +87,7 @@ config QED
>  	depends on PCI
>  	select ZLIB_INFLATE
>  	select CRC8
> +	select NET_DEVLINK
>  	---help---
>  	  This enables the support for ...
>=20
> --
> 2.7.4
>=20

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


