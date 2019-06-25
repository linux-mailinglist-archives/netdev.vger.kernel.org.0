Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF952062
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfFYBkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:40:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46120 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728954AbfFYBko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 21:40:44 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P1YDhY020294;
        Mon, 24 Jun 2019 18:40:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oALUoNya9BG/HfOdMqVbIIt5f2ua12jjNVVzvUOPB6U=;
 b=I9HshbLEg7t/4GZwU9T0sqSAG61JQpTQyafx0+aVhhgSD657e6HaK8ahu3fGDMyNiHvP
 u+vVUDpBEG7LQ9qc1IFmXUU9TfpN2i1pgvd2RZtabc5yqaeDOcag1O3C+sN1c1kWyGhe
 d3v8GXDJM48FSjb9pYhmeuDPOwpkazflWM0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tb3v01e8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jun 2019 18:40:15 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 18:40:13 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 18:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oALUoNya9BG/HfOdMqVbIIt5f2ua12jjNVVzvUOPB6U=;
 b=nSG3zaDrZNw+utBcB50DoEEd+9U2FQTrtcx2urF1Hmf7APsqoQXFZvCARgV0CF+UQ4DsCGMMl9ViGJjHWj23p/r/NRFYx1QHYO9CWYbJw/cDpmwsqB01YZqrNbl+5RVVy906VJELUy9TsjD6p3OGtGEaskCzfHy5U6mmtk1PlAM=
Received: from BYAPR15MB3128.namprd15.prod.outlook.com (20.178.239.159) by
 BYAPR15MB2965.namprd15.prod.outlook.com (20.178.237.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 01:39:54 +0000
Received: from BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::8d8:ed23:9407:c5d4]) by BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::8d8:ed23:9407:c5d4%3]) with mapi id 15.20.2008.017; Tue, 25 Jun 2019
 01:39:54 +0000
From:   Takshak Chahande <ctakshak@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFvTUkRqtOrmUSu/YAWzHIBGaaq33qAgAB9YoCAAAbxAIAAB5SAgAAPYICAAArCgIAAAXmAgAACRYCAAALQgIAAAgkAgAAC3ACAAAc2AIAABIiA
Date:   Tue, 25 Jun 2019 01:39:54 +0000
Message-ID: <20190625013941.GA33038@ctakshak-mbp>
References: <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
 <20190624154309.5ef3357b@cakuba.netronome.com>
 <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
 <20190624171641.73cd197d@cakuba.netronome.com>
 <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
 <20190624173005.06430163@cakuba.netronome.com>
 <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
 <20190624174726.2dda122b@cakuba.netronome.com>
 <20190624175740.5cccea9b@cakuba.netronome.com>
 <99a92dd0-4914-aeb5-709b-ed4615820aa0@fb.com>
In-Reply-To: <99a92dd0-4914-aeb5-709b-ed4615820aa0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0026.namprd13.prod.outlook.com
 (2603:10b6:301:29::39) To BYAPR15MB3128.namprd15.prod.outlook.com
 (2603:10b6:a03:b0::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::a395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4530f906-6314-425d-df6b-08d6f90e0599
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2965;
x-ms-traffictypediagnostic: BYAPR15MB2965:
x-microsoft-antispam-prvs: <BYAPR15MB29654B38ED88EADA15E2BABBBDE30@BYAPR15MB2965.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(6436002)(229853002)(6486002)(33656002)(86362001)(25786009)(6246003)(9686003)(6512007)(186003)(46003)(53936002)(1076003)(6636002)(4326008)(316002)(54906003)(5660300002)(6116002)(2906002)(305945005)(8936002)(7736002)(14454004)(33716001)(478600001)(68736007)(386003)(66446008)(64756008)(66556008)(66946007)(73956011)(66476007)(446003)(11346002)(476003)(486006)(52116002)(102836004)(53546011)(6506007)(76176011)(99286004)(71190400001)(71200400001)(81156014)(81166006)(6862004)(256004)(5024004)(14444005)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2965;H:BYAPR15MB3128.namprd15.prod.outlook.com;FPR:;SPF:None;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eON9Pqkcl7TRph3PbrrlrQmgR8NW1Hy4xWVA9TQ4sLZWXpzK5XFr1/p30KDaC2e3pjtyLlVB0My9pxGogbJmyr4oG8OSkO3qk9/qvglBeLV05o7ZXw8ZKAXgNBkpg5wI1DZoAtexKwAZ40Sacht+YVbrdOobUNS0UIWPA8LLlWI01WKqCf0cjT/DXeDgN4r8NG4k9kcV1NPDqk9HdCi6Hp8OxEuSfi6fobyVmIvkxMilRseLSCWKx2VVLbNysQwQVWsxCmxpHCiLI+pkb1XZPj6r0Ry5DZlZbMcjzFSefF2FyUD0mEvhAm8uHB78uYXEDotClFBV+ra6LUX7TtdyX798y93cibOQeW60anwj6jcjopqUqWIeOKwt7vWqv7pnZJNcq9rP4psDQYEeGPfhuygmDWI87y4lDb+WJDEIHaY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC234D5ECD5EEF43A50A5E59506F2C40@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4530f906-6314-425d-df6b-08d6f90e0599
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 01:39:54.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctakshak@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2965
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <ast@fb.com> wrote on Mon [2019-Jun-24 18:23:28 -0700]:
> On 6/24/19 5:57 PM, Jakub Kicinski wrote:
> > On Mon, 24 Jun 2019 17:47:26 -0700, Jakub Kicinski wrote:
> >> I see.  The local flag would not an option in getopt_long() sense, wha=
t
> >> I was thinking was about adding an "effective" keyword:
> >=20
> > Something like this, untested:
> >=20
> > --->8------------
> >=20
> > The BPF_F_QUERY_EFFECTIVE is a syscall flag, and fits nicely
> > as a subcommand option.  We want to move away from global
> > options, anyway.
> >=20
> > We need a global variable because of nftw limitations.
> > Clean this flag on every invocations in case we run in
> > batch mode.
> >=20
> > NOTE the argv[1] use on the error path in do_show() looks
> > like a bug on it's own.
> > ---
> >   .../bpftool/Documentation/bpftool-cgroup.rst  | 24 +++----
> >   tools/bpf/bpftool/Documentation/bpftool.rst   |  6 +-
> >   tools/bpf/bpftool/bash-completion/bpftool     | 17 ++---
> >   tools/bpf/bpftool/cgroup.c                    | 62 ++++++++++++------=
-
> >   tools/bpf/bpftool/main.c                      |  7 +--
> >   tools/bpf/bpftool/main.h                      |  3 +-
> >   6 files changed, 66 insertions(+), 53 deletions(-)
> >=20
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools=
/bpf/bpftool/Documentation/bpftool-cgroup.rst
> > index 324df15bf4cc..4fde3dfad395 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> > @@ -12,8 +12,7 @@ SYNOPSIS
> >  =20
> >   	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
> >  =20
> > -	*OPTIONS* :=3D { { **-j** | **--json** } [{ **-p** | **--pretty** }] =
| { **-f** | **--bpffs** }
> > -	| { **-e** | **--effective** } }
> > +	*OPTIONS* :=3D { { **-j** | **--json** } [{ **-p** | **--pretty** }] =
| { **-f** | **--bpffs** } }
> >  =20
> >   	*COMMANDS* :=3D
> >   	{ **show** | **list** | **tree** | **attach** | **detach** | **help*=
* }
> > @@ -21,8 +20,8 @@ SYNOPSIS
> >   CGROUP COMMANDS
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  =20
> > -|	**bpftool** **cgroup { show | list }** *CGROUP*
> > -|	**bpftool** **cgroup tree** [*CGROUP_ROOT*]
> > +|	**bpftool** **cgroup { show | list }** *CGROUP* [**effective**]
> > +|	**bpftool** **cgroup tree** [*CGROUP_ROOT*] [**effective**]
> >   |	**bpftool** **cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTAC=
H_FLAGS*]
> >   |	**bpftool** **cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
> >   |	**bpftool** **cgroup help**
> > @@ -35,13 +34,17 @@ CGROUP COMMANDS
> >  =20
> >   DESCRIPTION
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > -	**bpftool cgroup { show | list }** *CGROUP*
> > +	**bpftool cgroup { show | list }** *CGROUP* [**effective**]
> >   		  List all programs attached to the cgroup *CGROUP*.
> >  =20
> >   		  Output will start with program ID followed by attach type,
> >   		  attach flags and program name.
> >  =20
> > -	**bpftool cgroup tree** [*CGROUP_ROOT*]
> > +		  If **effective** is specified retrieve effective programs that
> > +		  will execute for events within a cgroup. This includes
> > +		  inherited along with attached ones.
> > +
> > +	**bpftool cgroup tree** [*CGROUP_ROOT*] [**effective**]
> >   		  Iterate over all cgroups in *CGROUP_ROOT* and list all
> >   		  attached programs. If *CGROUP_ROOT* is not specified,
> >   		  bpftool uses cgroup v2 mountpoint.
> > @@ -50,6 +53,10 @@ DESCRIPTION
> >   		  commands: it starts with absolute cgroup path, followed by
> >   		  program ID, attach type, attach flags and program name.
> >  =20
> > +		  If **effective** is specified retrieve effective programs that
> > +		  will execute for events within a cgroup. This includes
> > +		  inherited along with attached ones.
> > +
> >   	**bpftool cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLA=
GS*]
> >   		  Attach program *PROG* to the cgroup *CGROUP* with attach type
> >   		  *ATTACH_TYPE* and optional *ATTACH_FLAGS*.
> > @@ -122,11 +129,6 @@ OPTIONS
> >   		  Print all logs available from libbpf, including debug-level
> >   		  information.
> >  =20
> > -	-e, --effective
> > -		  Retrieve effective programs that will execute for events
> > -		  within a cgroup. This includes inherited along with attached
> > -		  ones.
> > -
> >   EXAMPLES
> >   =3D=3D=3D=3D=3D=3D=3D=3D
> >   |
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bp=
ftool/Documentation/bpftool.rst
> > index d2f76b55988d..6a9c52ef84a9 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
> > @@ -19,7 +19,7 @@ SYNOPSIS
> >   	*OBJECT* :=3D { **map** | **program** | **cgroup** | **perf** | **ne=
t** | **feature** }
> >  =20
> >   	*OPTIONS* :=3D { { **-V** | **--version** } | { **-h** | **--help** =
}
> > -	| { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-e** | **=
--effective** } }
> > +	| { **-j** | **--json** } [{ **-p** | **--pretty** }] }
> >  =20
> >   	*MAP-COMMANDS* :=3D
> >   	{ **show** | **list** | **create** | **dump** | **update** | **looku=
p** | **getnext**
> > @@ -71,10 +71,6 @@ OPTIONS
> >   		  includes logs from libbpf as well as from the verifier, when
> >   		  attempting to load programs.
> >  =20
> > -	-e, --effective
> > -		  Retrieve effective programs that will execute for events
> > -		  within a cgroup. This includes inherited along with attached ones.
> > -
> >   SEE ALSO
> >   =3D=3D=3D=3D=3D=3D=3D=3D
> >   	**bpf**\ (2),
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpft=
ool/bash-completion/bpftool
> > index c98cb99867f6..de84ae06ae4e 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -187,7 +187,7 @@ _bpftool()
> >  =20
> >       # Deal with options
> >       if [[ ${words[cword]} =3D=3D -* ]]; then
> > -        local c=3D'--version --json --pretty --bpffs --mapcompat --deb=
ug --effective'
> > +        local c=3D'--version --json --pretty --bpffs --mapcompat --deb=
ug'
> >           COMPREPLY=3D( $( compgen -W "$c" -- "$cur" ) )
> >           return 0
> >       fi
> > @@ -678,12 +678,15 @@ _bpftool()
> >               ;;
> >           cgroup)
> >               case $command in
> > -                show|list)
> > -                    _filedir
> > -                    return 0
> > -                    ;;
> > -                tree)
> > -                    _filedir
> > +                show|list|tree)
> > +                    case $cword in
> > +                        3)
> > +                            _filedir
> > +                            ;;
> > +                        4)
> > +                            COMPREPLY=3D( $( compgen -W 'effective' --=
 "$cur" ) )
> > +                            ;;
> > +                    esac
> >                       return 0
> >                       ;;
> >                   attach|detach)
> > diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> > index 1bb2a751107a..88b80616d47b 100644
> > --- a/tools/bpf/bpftool/cgroup.c
> > +++ b/tools/bpf/bpftool/cgroup.c
> > @@ -28,6 +28,8 @@
> >   	"                        connect6 | sendmsg4 | sendmsg6 |\n"        =
   \
> >   	"                        recvmsg4 | recvmsg6 | sysctl }"
> >  =20
> > +static unsigned int query_flags;
> > +
> >   static const char * const attach_type_strings[] =3D {
> >   	[BPF_CGROUP_INET_INGRESS] =3D "ingress",
> >   	[BPF_CGROUP_INET_EGRESS] =3D "egress",
> > @@ -104,8 +106,8 @@ static int count_attached_bpf_progs(int cgroup_fd, =
enum bpf_attach_type type)
> >   	__u32 prog_cnt =3D 0;
> >   	int ret;
> >  =20
> > -	ret =3D bpf_prog_query(cgroup_fd, type, query_flags, NULL, NULL,
> > -			     &prog_cnt);
> > +	ret =3D bpf_prog_query(cgroup_fd, type, query_flags, NULL,
> > +			     NULL, &prog_cnt);
> >   	if (ret)
> >   		return -1;
> >  =20
> > @@ -156,20 +158,30 @@ static int show_attached_bpf_progs(int cgroup_fd,=
 enum bpf_attach_type type,
> >   static int do_show(int argc, char **argv)
> >   {
> >   	enum bpf_attach_type type;
> > +	const char *path;
> >   	int cgroup_fd;
> >   	int ret =3D -1;
> >  =20
> > -	if (argc < 1) {
> > -		p_err("too few parameters for cgroup show");
> > -		goto exit;
> > -	} else if (argc > 1) {
> > -		p_err("too many parameters for cgroup show");
> > -		goto exit;
> > +	query_flags =3D 0;
> > +
> > +	if (!REQ_ARGS(1))
> > +		return -1;
> > +	path =3D GET_ARG();
> > +
> > +	while (argc) {
> > +		if (is_prefix(*argv, "effective")) {
> > +			query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> > +			NEXT_ARG();
> > +		} else {
> > +			p_err("expected no more arguments, 'effective', got: '%s'?",
> > +			      *argv);
> > +			return -1;
> > +		}
> >   	}
> >  =20
> > -	cgroup_fd =3D open(argv[0], O_RDONLY);
> > +	cgroup_fd =3D open(path, O_RDONLY);
> >   	if (cgroup_fd < 0) {
> > -		p_err("can't open cgroup %s", argv[1]);
> > +		p_err("can't open cgroup %s", path);
> >   		goto exit;
> >   	}
> >  =20
> > @@ -295,23 +307,29 @@ static int do_show_tree(int argc, char **argv)
> >   	char *cgroup_root;
> >   	int ret;
> >  =20
> > -	switch (argc) {
> > -	case 0:
> > +	query_flags =3D 0;
> > +
> > +	if (!argc) {
> >   		cgroup_root =3D find_cgroup_root();
> >   		if (!cgroup_root) {
> >   			p_err("cgroup v2 isn't mounted");
> >   			return -1;
> >   		}
> > -		break;
> > -	case 1:
> > -		cgroup_root =3D argv[0];
> > -		break;
> > -	default:
> > -		p_err("too many parameters for cgroup tree");
> > -		return -1;
> > +	} else {
> > +		cgroup_root =3D GET_ARG();
> > +
> > +		while (argc) {
> > +			if (is_prefix(*argv, "effective")) {
> > +				query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> > +				NEXT_ARG();
> > +			} else {
> > +				p_err("expected no more arguments, 'effective', got: '%s'?",
> > +				      *argv);
> > +				return -1;
> > +			}
> > +		}
> >   	}
> >  =20
> > -
> >   	if (json_output)
> >   		jsonw_start_array(json_wtr);
> >   	else
> > @@ -457,8 +475,8 @@ static int do_help(int argc, char **argv)
> >   	}
> >  =20
> >   	fprintf(stderr,
> > -		"Usage: %s %s { show | list } CGROUP\n"
> > -		"       %s %s tree [CGROUP_ROOT]\n"
> > +		"Usage: %s %s { show | list } CGROUP [**effective**]\n"
> > +		"       %s %s tree [CGROUP_ROOT] [**effective**]\n"
>=20
> lgtm.
> Takshak, Andrey, wdyt?
ya, looks fine to me.

--Takshak
