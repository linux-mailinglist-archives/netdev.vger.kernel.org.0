Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466E0580BD
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF0KsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:48:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbfF0KsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:48:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RAkRTh011519;
        Thu, 27 Jun 2019 03:47:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=HC8HPV1nXzf+zyxzivDRxnTyzji4ZLCzwla40vLGVw8=;
 b=PeTlCu19bV11HDj9CiZXOii9XxZGBhHKvm638Z2WjI2cLKSV+Ek9dhsAurQkBDDwEKJZ
 x2HVTyb8mdiMg4MAzkWGjBfsShLBS21TOaFe7Fj9XlnJWJoNQMly0x9IfinyZbE/t9XZ
 EQvYBLTiMOHbt45HYg1W2WVCHWOSLZK3RULKvFfNQUuaH7RNPrPVnbpYyWfVJJFliWa+
 irYfFg8Dk0Ov0bdlAMy+ky3Yje4MLwKOuvMPOslr5tXymqW1tHP42/nNkPFmuGwrPVob
 3qXvoLSbKOP93JYmkgrzT39HfGB28nP4rE09HkOsGxwnsI60bsxURLP4xpgt24c4Nk6Z Qg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tcbgcbvwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 03:47:56 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 27 Jun
 2019 03:47:55 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 27 Jun 2019 03:47:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC8HPV1nXzf+zyxzivDRxnTyzji4ZLCzwla40vLGVw8=;
 b=WyMFhc334dS1tpnw0UZQDb+jrdSw4uiOCZsHi2JADhQ0GMCZVa26Luf1TCbcXDurOGRc/TszVICIcA5B2eQMZd9NDHAt8nGsGoQrcV3wuLGyEM0I8uQUKP6TCOxrALltyZeOhyfRohfYI2zfXN+qZ+lv6d0/T8QBrEhzalh27R4=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2764.namprd18.prod.outlook.com (20.179.49.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 10:47:50 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 10:47:50 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 11/16] qlge: Remove qlge_bq.len & size
Thread-Topic: [PATCH net-next 11/16] qlge: Remove qlge_bq.len & size
Thread-Index: AQHVJOFPzIZLHr1fM0+84eVMN3MVSqavYKdg
Date:   Thu, 27 Jun 2019 10:47:50 +0000
Message-ID: <DM6PR18MB2697E84A8DD54483832AD202ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-11-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-11-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:2192:124f:91a0:c28f:ff45:18bc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c3f1d1d-7f4e-4414-2505-08d6faece69f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2764;
x-ms-traffictypediagnostic: DM6PR18MB2764:
x-microsoft-antispam-prvs: <DM6PR18MB276453AA2E690CDF58152C9EABFD0@DM6PR18MB2764.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(346002)(376002)(39850400004)(199004)(189003)(14454004)(86362001)(68736007)(476003)(71200400001)(5660300002)(46003)(71190400001)(2906002)(4744005)(478600001)(33656002)(52536014)(11346002)(446003)(6116002)(25786009)(76116006)(66946007)(73956011)(110136005)(66446008)(55016002)(66476007)(64756008)(6506007)(229853002)(305945005)(8936002)(316002)(2501003)(256004)(74316002)(186003)(7696005)(99286004)(6436002)(7736002)(53936002)(81156014)(81166006)(9686003)(102836004)(76176011)(6246003)(486006)(66556008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2764;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aLPXWBbcU9BNuKv1nRjmCD81bCMPKGQ5Cb5wV0lJ/AHs+sSfB4HHA1y8mFr6kvZcrYC3wvf9J6Ig7oAI9KwAJNz+E2fLOz0UDUwmipLXi7zxi0O5XofFtAN2q1o0eVbdRcTgDe9smLaXBSVlaQi8+PJzHN7X0Xa6605oH0DbLqismXrYAQS65Zd4hyUKH3drhfPKqNwwpH/fxGsF/5QcmYlkiKgtrRUKiM7VBulxprJyuD/hLRtnSKYFd3tDsOEOy45vOi55hNCqHgiJ+eMn6ZA0VE3gIMs0bqxWTlQTksGJWfZojOmqqIXH0wUglcra+85nLn2+uJmt0eqSuIkwMH1HncqrR0pmKLQwekttlbvoKTbGsAcKYt7PK+2+RbOdsPoZI39TwrAk/tU2BYEIRZCtQ8EMsASpLwOAMO+ihho=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3f1d1d-7f4e-4414-2505-08d6faece69f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 10:47:50.6709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2764
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> -	for (i =3D 0; i < qdev->rx_ring_count; i++) {
> +	for (i =3D 0; i < qdev->rss_ring_count; i++) {
>  		struct rx_ring *rx_ring =3D &qdev->rx_ring[i];
>=20
> -		if (rx_ring->lbq.queue)
> -			ql_free_lbq_buffers(qdev, rx_ring);
> -		if (rx_ring->sbq.queue)
> -			ql_free_sbq_buffers(qdev, rx_ring);
> +		ql_free_lbq_buffers(qdev, rx_ring);
> +		ql_free_sbq_buffers(qdev, rx_ring);
>  	}
>  }
>=20

Seems irrelevant change as per what this patch is supposed to do exactly.

