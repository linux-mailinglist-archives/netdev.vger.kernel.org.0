Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5545F272D3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfEVXQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:16:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727634AbfEVXQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:16:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MND6ND015061;
        Wed, 22 May 2019 16:16:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i1feLUhwGMQVGZL9+X7Ze3YL3PYK8dLOen4Caa/0J0U=;
 b=OWp98crVwHBBgbwapMKdWSEEZNbF4N/kDbJp47sjVwcz1+d+t3fsaMVUSS/tvLnq6aB5
 o39mg6/Kn4w4ftiVmKK8z/qCfCMKm9lj1jYyD6Dj4IrM8OuES/i3ZyIPP1e1Nyu0rY9h
 QH5L1tSL7PAI2w6yvBJhhsQoIQEHjQJXwDs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8rt9s6s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 16:16:28 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 16:16:23 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 16:16:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1feLUhwGMQVGZL9+X7Ze3YL3PYK8dLOen4Caa/0J0U=;
 b=e9u1LePRwc9N4pN6zpw/O7w/dBn3S0ptxA28LNXHvR5QToS1yjttCbNn9OulPHvSa8lSMNRI4JJkbCsocX2jXptH5yDQRrPAappydXiCVI/l2eB1pXt1KSi1My3B2HW1yd1SL5KEAT2YiKPpLfYbcSTEv1eI/bP3rRhPG2+7P9o=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2615.namprd15.prod.outlook.com (20.179.155.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 22 May 2019 23:16:20 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 23:16:20 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: enable all available cgroup
 v2 controllers
Thread-Topic: [PATCH bpf-next 3/4] selftests/bpf: enable all available cgroup
 v2 controllers
Thread-Index: AQHVEOV3yJF4QzvIUEOnOJLgcH8376Z3ttaAgAAQE4A=
Date:   Wed, 22 May 2019 23:16:20 +0000
Message-ID: <20190522231613.GA20167@tower.DHCP.thefacebook.com>
References: <20190522212932.2646247-1-guro@fb.com>
 <20190522212932.2646247-4-guro@fb.com> <20190522221843.GA3032@mini-arch>
In-Reply-To: <20190522221843.GA3032@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0065.namprd22.prod.outlook.com
 (2603:10b6:300:12a::27) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::7d4f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5f68467-f1cf-4721-0e5d-08d6df0b7fac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2615;
x-ms-traffictypediagnostic: BYAPR15MB2615:
x-microsoft-antispam-prvs: <BYAPR15MB26159C3A51704EBEEF42E4FABE000@BYAPR15MB2615.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(39860400002)(396003)(346002)(199004)(189003)(229853002)(46003)(54906003)(53936002)(2906002)(6246003)(478600001)(8936002)(81166006)(81156014)(6436002)(9686003)(186003)(6486002)(8676002)(6916009)(11346002)(33656002)(446003)(6116002)(486006)(316002)(476003)(6512007)(305945005)(99286004)(5660300002)(6506007)(71190400001)(14444005)(68736007)(71200400001)(7736002)(76176011)(102836004)(386003)(73956011)(52116002)(4326008)(86362001)(1076003)(14454004)(25786009)(66556008)(66446008)(64756008)(66476007)(66946007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2615;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0YpKLZlQO1drDY6ASohoV9NLDqeMA5PcPF2nYZZYKDnhsCEh499buZIJSlscNdewxKes2qdJZga2QlgmM/d4TcCMYapHco/VjGKbg5ck86Pt9xs2aNbAahHf1qKZ+Xf/yah9pObk2y0p865WC92u5vIeL2ZzMRl1J/xkkgcqCrLnYuRIvYpBq0P3UqV7+XKSJhqcW0nSESfalZyacutRlJkSQUZiIH84WQfMTxKuX9jz/0FQKAHDbpSUb11+i4/JKTd9a/07jfq68GULXm3Tb91nA4lPlHBns8jaNKmxTFIBZeql9TRCwvoySjXEkBjfrqaB6N/tpD35qCwsuBkFll9oAdO52xkaO4kRrruo/NeJcNzMWR3yWYfYjEwG7gbcN8xflrMV5oFUOrXXs4J52JBc1LZ/N2vVHKihXUBSXp0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA7BB09FF47CAE4A81E46F24346899CE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f68467-f1cf-4721-0e5d-08d6df0b7fac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 23:16:20.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2615
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 03:18:43PM -0700, Stanislav Fomichev wrote:
> On 05/22, Roman Gushchin wrote:
> > Enable all available cgroup v2 controllers when setting up
> > the environment for the bpf kselftests. It's required to properly test
> > the bpf prog auto-detach feature. Also it will generally increase
> > the code coverage.
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  tools/testing/selftests/bpf/cgroup_helpers.c | 58 ++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> >=20
> > diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testi=
ng/selftests/bpf/cgroup_helpers.c
> > index 6692a40a6979..4533839c0ce0 100644
> > --- a/tools/testing/selftests/bpf/cgroup_helpers.c
> > +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
> > @@ -33,6 +33,61 @@
> >  	snprintf(buf, sizeof(buf), "%s%s%s", CGROUP_MOUNT_PATH, \
> >  		 CGROUP_WORK_DIR, path)
> > =20
> > +/**
> > + * enable_all_controllers() - Enable all available cgroup v2 controlle=
rs
> > + *
> > + * Enable all available cgroup v2 controllers in order to increase
> > + * the code coverage.
> > + *
> > + * If successful, 0 is returned.
> > + */
> > +int enable_all_controllers(char *cgroup_path)
> > +{
> > +	char path[PATH_MAX + 1];
> > +	char buf[PATH_MAX];
> > +	char *c, *c2;
> > +	int fd, cfd;
> > +	size_t len;
> > +
> > +	snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
> > +	fd =3D open(path, O_RDONLY);
> > +	if (fd < 0) {
> > +		log_err("Opening cgroup.controllers: %s", path);
> > +		return -1;
> > +	}
> > +
> > +	len =3D read(fd, buf, sizeof(buf) - 1);
> > +	if (len < 0) {
> > +		close(fd);
> > +		log_err("Reading cgroup.controllers: %s", path);
> > +		return -1;
> > +	}
> > +
> > +	close(fd);
> > +
> > +	/* No controllers available? We're probably on cgroup v1. */
> > +	if (len =3D=3D 0)
> > +		return 0;
> > +
> > +	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", cgroup_path=
);
> > +	cfd =3D open(path, O_RDWR);
> > +	if (cfd < 0) {
> > +		log_err("Opening cgroup.subtree_control: %s", path);
> > +		return -1;
> > +	}
> > +
>=20
> [..]
> > +	buf[len] =3D 0;
> nit: move this up a bit? Right after:

Ok, np. Thanks!
