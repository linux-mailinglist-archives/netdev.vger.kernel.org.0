Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EAC2857A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfEWR7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:59:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38248 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731073AbfEWR7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:59:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NHwWq4012062;
        Thu, 23 May 2019 10:58:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=de5HqLKENBOTVi8j+LLu18Z4hDZQ4TJG+nR63K2QNnU=;
 b=SYh8wN7cBRfARZ96o+K0g8DPHAEfFVd3a6Xoj6if2T1hIVlWPWw49/TXS+uNFN2zI2ni
 VWFenwmaTyEcPqQmepfB+F6TnK16T7k4tgcZkT5TmgTB/qP1a5VMQXxVt/JsP4efNidX
 KJLI5aQkdlPLsmQ+84gqYELfSky9YyyZ5rk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snyam88m9-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 10:58:45 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 23 May 2019 10:58:45 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 10:58:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de5HqLKENBOTVi8j+LLu18Z4hDZQ4TJG+nR63K2QNnU=;
 b=KKCMBLAFDGuJ2QdvTNQQSCezO6w07szUZUlCew8tG/VETktDdGAxaFR9A4VydPJRuUPwqLpvX6ogWWQ7Q53SmkCDoFkGF4hVgqHBjORgprszp2SWvGh7ZJsIJ7CbegAmbzj0wicyCzCr4Y27pyjFMY4QPo67GMVM/ELVbZaXh2s=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2694.namprd15.prod.outlook.com (20.179.156.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 17:58:40 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 17:58:40 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEPUtpidQdc9d6UW2SWsAUk86b6Z4NBMAgADMSwA=
Date:   Thu, 23 May 2019 17:58:40 +0000
Message-ID: <20190523175833.GA7107@tower.DHCP.thefacebook.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
 <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
In-Reply-To: <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0058.namprd12.prod.outlook.com
 (2603:10b6:300:103::20) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::8323]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a42e212-2073-4f47-ae37-08d6dfa849a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2694;
x-ms-traffictypediagnostic: BYAPR15MB2694:
x-microsoft-antispam-prvs: <BYAPR15MB2694BA21B49719F89F668620BE010@BYAPR15MB2694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(396003)(136003)(366004)(189003)(199004)(6486002)(68736007)(229853002)(6436002)(71190400001)(2906002)(33656002)(386003)(6506007)(53546011)(71200400001)(52116002)(1076003)(7736002)(66476007)(73956011)(66946007)(305945005)(6116002)(102836004)(486006)(478600001)(476003)(54906003)(446003)(11346002)(76176011)(14454004)(46003)(99286004)(53936002)(4326008)(5024004)(6246003)(5660300002)(14444005)(256004)(6636002)(186003)(316002)(81156014)(8936002)(66556008)(64756008)(66446008)(81166006)(6512007)(25786009)(8676002)(6862004)(9686003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2694;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6FdNlttIXtSffCTk8fMGBc63qMB25sJvgJOX8a53fTmoJt05e1RJS9z00r2jAKGIWznAdy7pOgLCRcIhmXBxmp+B1PIz7vK25NFFJS7E43uVjRcMkGcGQ07hizlDijav+48BrRRNQZYOXpMpIKrAOwQmJuFBHPs1qL2KSUs/pk9XetK22ozeaeWp917SbR2/L7uLYGgeAuKH9d+t04jN7v6FDBBtJJCn3IEgePdF0Jps5xqIcvH3+SxP0otN1NPbd9HwyzEXuJtz6Yr2+45Q6dnrX3Gu0D9jDWyhayY5zNg8V/OgoJHS0f+y/sxRzr3F3YuPOcXqfHX+pSbmcZgHR/xXKNL7TF3fzJd0ajy12mZgZLcHrtp+eqmSSEq4AHomVyX+ETNugXJ8GlervI5oZp/zDYL7DfQN77iz7gBvakw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C59FFFCC474F14F9CA30C7EDE14439D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a42e212-2073-4f47-ae37-08d6dfa849a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 17:58:40.6180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 10:47:24PM -0700, Yonghong Song wrote:
>=20
>=20
> On 5/22/19 4:20 PM, Roman Gushchin wrote:
> > Add a kselftest to cover bpf auto-detachment functionality.
> > The test creates a cgroup, associates some resources with it,
> > attaches a couple of bpf programs and deletes the cgroup.
> >=20
> > Then it checks that bpf programs are going away in 5 seconds.
> >=20
> > Expected output:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:PASS
> >    test_cgroup_attach:PASS
> >=20
> > On a kernel without auto-detaching:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:FAIL
> >    test_cgroup_attach:FAIL
>=20
> I ran this problem without both old and new kernels and
> both get all PASSes. My testing environment is a VM.
> Could you specify how to trigger the above failure?

Most likely you're running cgroup v1, so the memory controller
is not enabled on unified hierarchy. You need to pass
"cgroup_no_v1=3Dall systemd.unified_cgroup_hierarchy=3D1"
as boot time options to run fully on cgroup v2.

But generally speaking, the lifecycle of a dying cgroup is
completely implementation-defined. No guarantees are provided.
So false positives are fine here, and shouldn't be considered as
something bad.

At the end all we want it to detach programs in a reasonable time
after rmdir.

Btw, thank you for the careful review of the patchset. I'll
address your comments, add acks and will send out v3.

Thanks!
