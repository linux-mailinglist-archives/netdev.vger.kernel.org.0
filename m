Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D492056A47
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFZNWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:22:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbfFZNWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:22:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QDKFdD003088;
        Wed, 26 Jun 2019 06:21:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=gmL8G14AvvOlExnKUUFioYYfBKE0rm6XdqspmX1ns5o=;
 b=LbhAo8BzDksCGBQL0ZWQWePZ59ZMcQFkPY2OXVOx9puj0typSBFzWnNT+KElh869VGom
 dCKH3XjF9a4al+2bSIxyxcdjmbWPafAdChrCE1HBZZie3w74nkK2MBhStaIIRIYS1HFV
 rtg5UB4dvFij7UtNj4TPn2AgJboLlt9BEeivbRdtFd7VRO1AXt4dpC6TtaZ5hEwYp1of
 OLSJtgZxxrpTar/j16WeRrdJY89b67/PLu0agjVT7Tz+tDSrvxDpZWUZ5VfpyIeTcv9a
 YxEKbmQxgEUfUmalugPI96pJzUpqHGyWlnSO8bGMeLFT3gAkJr4O5WrVy7eZX/ud5f/q RQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tc5ht103t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 06:21:58 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 06:21:57 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 06:21:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmL8G14AvvOlExnKUUFioYYfBKE0rm6XdqspmX1ns5o=;
 b=FJ4GrfFM1lrbkj1A6cYrfu/XOrm0OKLpCg7XarAXXLJdGGgi6O7HNFt4n4fx0Xz0IKwQfdRY8XfthOda5kMvM0lvQo2hkG2MXRRDdSGJVlX1Gf0NNIM9bAEVCussX+2KAamnDfpUn2L9yyeo3ZTtAWAkDIDdOYV/pktq1O8QUT0=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2892.namprd18.prod.outlook.com (20.179.52.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 13:21:53 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 13:21:53 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>
CC:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Topic: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Index: AQHVJOFCi7hq2bA2CEicYO6gagSpYqatq44wgAAxbYCAABeEsA==
Date:   Wed, 26 Jun 2019 13:21:52 +0000
Message-ID: <DM6PR18MB2697291D4195683CC42EA194ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <DM6PR18MB2697814343012B4363482290ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
 <20190626113619.GA27420@f1>
In-Reply-To: <20190626113619.GA27420@f1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17399525-aee7-44a6-827f-08d6fa39411c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2892;
x-ms-traffictypediagnostic: DM6PR18MB2892:
x-microsoft-antispam-prvs: <DM6PR18MB28927FA36D46DC6B6CBCA8EBABE20@DM6PR18MB2892.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(7736002)(99286004)(9686003)(486006)(55016002)(76116006)(14454004)(66946007)(6436002)(73956011)(66446008)(66556008)(64756008)(66476007)(71190400001)(71200400001)(229853002)(68736007)(305945005)(2906002)(53936002)(33656002)(7696005)(81156014)(81166006)(8936002)(316002)(256004)(478600001)(3846002)(54906003)(66066001)(86362001)(6246003)(6116002)(74316002)(25786009)(8676002)(446003)(6916009)(52536014)(4326008)(11346002)(6506007)(5660300002)(102836004)(76176011)(4744005)(186003)(26005)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2892;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0rsX3uDl07trJoRJOulkt8Y80MKQFgxskqlScAjOpJ1qnOiHtIN37yaQTIhBSJtWbb0Z/8ctD6/uppMyjcyxdv4b2nJB/xS91aczpIODiYoD3MW8pfbD6eiOUqmiSFbh8gEtAShmNoQTALxgr5Upsdds29r1p+mxsn8FlTvnuY8qEZ2nteqzveIKDGuAPYwaJ+Y+UZXiwmtxtIciJXc1j38xtKmkrJ20D3uJL4nn8YEO5LGTU+dd/4ruhjVl76bhNr3eSstnbdiETpfMulpUBkCVDDYAy9jeO4nyBR8AwzB75e0QevYFV0X4Jb2ghGBc1nZWz/LtYoQa/du8mstYxHLcruF7EDsh2xdnNwvMBx50Y/JTYJxqpkk9RZcNUoVCnaZ0a+yKoDHYgPPQs/FX2TOq5rQPq3uqydp+BQqVSOQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17399525-aee7-44a6-827f-08d6fa39411c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 13:21:53.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2892
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_07:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In msix mode there's no need to explicitly disable completion interrupts,=
 they
> are reliably auto-masked, according to my observations.
> I tested this on two QLE8142 adapters.
>=20
> Do you have reason to believe this might not always be the case?

How did you check auto-masking of MSI-X interrupts ?
I was just wondering about the below comment in ql_disable_completion_inter=
rupt(), where for MSI-X it does disable completion intr for zeroth intr.
Seems special case for zeroth intr in MSI-X particular to this device.

        /* HW disables for us if we're MSIX multi interrupts and
         * it's not the default (zeroeth) interrupt.
         */
        if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr))
                return 0;


