Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0B58E1A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF0WoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:44:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbfF0WoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:44:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5RMhmm4002103;
        Thu, 27 Jun 2019 15:43:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+Cvc2JFBZpKARumySuB0LPSi5r91CacaQZ8f1LXTn58=;
 b=ohUlkZ3KecMyWi5Ab8wD1opwJEftmnurJXZUVz7O+aKjtmwtOiDUluQB3Y21GRJfybQY
 oBgtQ1X/Es6LHrKehsXPKDN1iaazOsRxIgs7q5HmQ6jUbq6cGkf4rEMZciLI9f0XYFKl
 NdDwBlB6JbhGR7lu1K8R8/BWgoPzWwgnjMU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tcxeyj3jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jun 2019 15:43:48 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:43:47 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 15:43:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Cvc2JFBZpKARumySuB0LPSi5r91CacaQZ8f1LXTn58=;
 b=gAlVXstoQDATM+pvYUtKSPDrvktb/jwBiD9S+6oHGy5z8VIcKsrAJ0b47V34Z4J6zy1t7e8Zd2JLxPTmlzMDuQ8BzPs7FsoN4+IuxczgfEJpWWeHhHP7JBG+yreCx1A39XEzfy/DfObR1KcGuBypWDzUHJz33AiPePQTlY7h0YU=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3300.namprd15.prod.outlook.com (20.179.74.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 22:43:45 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 22:43:45 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
Thread-Topic: linux-next: Fixes tag needs some work in the bpf tree
Thread-Index: AQHVLGtWobJf9y3bFk6A9OxwhHLb36augAKAgAAXNQCAACP6AIABWokAgAAE+IA=
Date:   Thu, 27 Jun 2019 22:43:45 +0000
Message-ID: <20190627224341.GA29996@tower.DHCP.thefacebook.com>
References: <20190627080521.5df8ccfc@canb.auug.org.au>
 <20190626221347.GA17762@tower.DHCP.thefacebook.com>
 <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
 <20190627114536.09c08f5d@canb.auug.org.au>
 <134f90ff-13f8-b7c1-9693-2f2649245c38@iogearbox.net>
In-Reply-To: <134f90ff-13f8-b7c1-9693-2f2649245c38@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0102.namprd15.prod.outlook.com (10.175.177.22) To
 BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c90f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cec8b81-27c1-43c6-ebe4-08d6fb50e99f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB3300;
x-ms-traffictypediagnostic: BN8PR15MB3300:
x-microsoft-antispam-prvs: <BN8PR15MB33006513B4ECD76161CDBF60BEFD0@BN8PR15MB3300.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:499;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(53754006)(6116002)(2906002)(6512007)(11346002)(446003)(476003)(486006)(6506007)(186003)(53546011)(386003)(9686003)(4326008)(46003)(102836004)(14454004)(6916009)(6486002)(86362001)(33656002)(229853002)(76176011)(99286004)(6436002)(71200400001)(71190400001)(5660300002)(81166006)(256004)(8936002)(81156014)(8676002)(6246003)(316002)(68736007)(66556008)(64756008)(66476007)(66446008)(73956011)(478600001)(66946007)(25786009)(1076003)(7736002)(53936002)(54906003)(305945005)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3300;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KGSuPZZJEcMQOSObyzZfbOyj8OdoYPddDDsQC+1HGf2Ie6/QdTr+fXJ4MzuObQUpjcGFP5ke5FLmTTxVgesRylbgYjTOUB3QFRxnsuiyhO0X73PuWvAPaUtt6+quBu4AD/oAQzQeeLe72/cOi/ennEXsLA5e6RWu1Cu2pzxMFYZ6ZSURrnpUqCrFE+lIOHimAs3zduRQhOMlcfx+TG5ATxW+PE0miXWQmUIHS9ZfZY4n++t2ZjAQtgGRqhq8BSvOTSTYQaFfxzp5TaqMRKjc9mdjDBTyp6XCIBhO+zSWUzQp31tc0lp+178fJVlIbg7UqZCKbROK1t+IhT/HF/CUUAHfap1spAt0T4CtwNF74I6fePPmvCBzuvUGskjquhrOuZHyU7Fkw0wnls9v1hbzucQQ1eKKizlsfYJiY3kaceI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D1C009488A1D24B9655713BF91AECB6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cec8b81-27c1-43c6-ebe4-08d6fb50e99f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 22:43:45.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3300
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=892 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270263
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 12:25:54AM +0200, Daniel Borkmann wrote:
> On 06/27/2019 03:45 AM, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > On Wed, 26 Jun 2019 16:36:50 -0700 Alexei Starovoitov <alexei.starovoit=
ov@gmail.com> wrote:
> >>
> >> On Wed, Jun 26, 2019 at 3:14 PM Roman Gushchin <guro@fb.com> wrote:
> >>>
> >>> On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote: =20
> >>>>
> >>>> In commit
> >>>>
> >>>>   12771345a467 ("bpf: fix cgroup bpf release synchronization")
> >>>>
> >>>> Fixes tag
> >>>>
> >>>>   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf fro=
m
> >>>>
> >>>> has these problem(s):
> >>>>
> >>>>   - Subject has leading but no trailing parentheses
> >>>>   - Subject has leading but no trailing quotes
> >>>>
> >>>> Please don't split Fixes tags across more than one line. =20
> >>>
> >>> Oops, sorry.
> >>>
> >>> Alexei, can you fix this in place?
> >>> Or should I send an updated version? =20
> >>
> >> I cannot easily do it since -p and --signoff are incompatible flags.
> >> I need to use -p to preserve merge commits,
> >> but I also need to use --signoff to add my sob to all
> >> other commits that were committed by Daniel
> >> after your commit.
> >>
> >> Daniel, can you fix Roman's patch instead?
> >> you can do:
> >> git rebase -i -p  12771345a467^
> >> fix Roman's, add you sob only to that one
> >> and re-push the whole thing.
>=20
> (Fixed in bpf-next.)

Thank you, Daniel!
