Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E973F336FF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfFCRnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:43:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54282 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbfFCRnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:43:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53HgSRi003256;
        Mon, 3 Jun 2019 10:42:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tfdZt5s+dH/kIG35dmGBASfxVVuxCAlqMyFijUEG4oE=;
 b=kQRujVmX82lmJcennWL/iOW/QgLVx0+820QEHbbNhUFmiPuidkyru7DuEPYfJPLQXr+A
 3ekojWrktcch3CtNwceBdfla0FmY6U5F+BT+kSHdryKhPYTEM9CyyStJ/u/pT1seoC4Q
 vriiPJNDVirnyPyAiJL9aokQ9A8rdondtSE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sw5y08hac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Jun 2019 10:42:54 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 3 Jun 2019 10:42:53 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 10:42:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfdZt5s+dH/kIG35dmGBASfxVVuxCAlqMyFijUEG4oE=;
 b=QOA+xjaVNnMlexp62bFCueZyLVbvwKlxdSH/zoX/shcByLKKMVbYfKAjaOC+7YTplH5wxNntYf068gGrIWl9uBxmfF+5Lyk8S2uUOX34R+pzu16t+Kx03yn0jA4GWNh/Xqy7VWPQSux7aGMbPGI+rDHwpv4c+4AotvXGNKbbvXc=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1374.namprd15.prod.outlook.com (10.173.234.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.23; Mon, 3 Jun 2019 17:42:51 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 17:42:51 +0000
From:   Martin Lau <kafai@fb.com>
To:     Colin King <colin.king@canonical.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] bpf: hbm: fix spelling mistake "notifcations" ->
 "notificiations"
Thread-Topic: [PATCH][next] bpf: hbm: fix spelling mistake "notifcations" ->
 "notificiations"
Thread-Index: AQHVGhFztAWsOPOvrUui0oDJRnZBSKaKM12A
Date:   Mon, 3 Jun 2019 17:42:51 +0000
Message-ID: <20190603174234.5cixc57p64aqm7om@kafai-mbp.dhcp.thefacebook.com>
References: <20190603133653.18185-1-colin.king@canonical.com>
In-Reply-To: <20190603133653.18185-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:301:39::15) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::b2c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eda3913c-9d7e-4eae-8205-08d6e84ae631
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1374;
x-ms-traffictypediagnostic: MWHPR15MB1374:
x-microsoft-antispam-prvs: <MWHPR15MB1374AC01B5F82467B876646BD5140@MWHPR15MB1374.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(39860400002)(376002)(396003)(189003)(199004)(386003)(5660300002)(256004)(102836004)(4744005)(7736002)(6506007)(5024004)(46003)(14444005)(8676002)(6436002)(486006)(476003)(1076003)(71190400001)(53936002)(6116002)(81156014)(446003)(71200400001)(11346002)(305945005)(6486002)(54906003)(99286004)(6246003)(81166006)(229853002)(8936002)(6916009)(4326008)(66946007)(66446008)(25786009)(73956011)(66556008)(66476007)(186003)(64756008)(86362001)(316002)(76176011)(14454004)(52116002)(2906002)(68736007)(6512007)(478600001)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1374;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +QJ42BQ2ETSAV2bm7HWvkb3+kdexBCR7dw/o03uHW35zCfDFgSFMGTS21k3XAxRo8P/rgaUuMBwe8cC20HbKzVTkjxCYVgsPIIAnR2k6mF4/alkD9z5mGmZBY9DDrZvQ34qxZ/XfPnJqf8bkK+0REBk5Ys5ia7DQ9WJniXpOpHVbbSfVn/RRkKMa+uLF8k0OVjRWbEfRBKLNoj/u2wgRLXeJD9cjB4lwTbqmiFjHQuG+4deJlcgJvv3yDs7XPgDF9ZMzD50x79Lf8mSiD0hZgBx9KFtE2tc2WQhqd7AISQCULlnmSAYy3H75lbJleA/7gUwspBL72Nm7YcfWBr6Hrr54TXfR+icjmBw31tRIv70QCc4OwBhxH4CbMQeNkiWFd1OsVoEpfYRF8twhqn8f2T2mRbJRhzSsxrzhjaRB/EQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D74F20389836C48A06DAD9DCB829147@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eda3913c-9d7e-4eae-8205-08d6e84ae631
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 17:42:51.1506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=808 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:36:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> There is a spelling mistake in the help information, fix this.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  samples/bpf/hbm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index 480b7ad6a1f2..bdfce592207a 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -411,7 +411,7 @@ static void Usage(void)
>  	       "    -l         also limit flows using loopback\n"
>  	       "    -n <#>     to create cgroup \"/hbm#\" and attach prog\n"
>  	       "               Default is /hbm1\n"
> -	       "    --no_cn    disable CN notifcations\n"
> +	       "    --no_cn    disable CN notifications\n"
Acked-by: Martin KaFai Lau <kafai@fb.com>

This should go to the bpf-next.
