Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B637AB6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfFFROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:14:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727522AbfFFROz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:14:55 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56HDS32032559;
        Thu, 6 Jun 2019 10:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RZPhWsQv3/KiDJyFFVMRFNElNRoRNsRL6pp6Hw2BTBY=;
 b=Cr+5kbwBhdeo3o1bmuY9knsjtCAMvbkwJeoMOCfcD5C+dAN0oA7gmtSjd3/+ofuVQMFX
 N69v6jJEk6l2qLZbET1xBtA7ls9ECabz8vDXKCD7vcrBVTEZARscZfBIF+y8tON6sLAY
 8/r70quosrqSC0/uBgYmy2WINBuV0UROfE8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy5hk0e5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 10:14:54 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 10:14:52 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 10:14:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZPhWsQv3/KiDJyFFVMRFNElNRoRNsRL6pp6Hw2BTBY=;
 b=fsX1zf+FDPHdRWV5Kf1vzYpggBgHv941xaUYlcLIxHqYZm52iReK6q6MAY5NyWrjvxoWx+JZFL2piwiVu0CKRRCKgUtgdMHcE0b07hsD2As8JsnFAOQcDcvbkuEMCaFojpj+W5KjGUf+RkgIwTSdxz/PHujGJO3BGRN1DBNMw4A=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1200.namprd15.prod.outlook.com (10.175.3.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Thu, 6 Jun 2019 17:14:51 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 17:14:51 +0000
From:   Martin Lau <kafai@fb.com>
To:     Hechao Li <hechaol@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: add a new API
 libbpf_num_possible_cpus()
Thread-Topic: [PATCH v2 bpf-next 1/2] bpf: add a new API
 libbpf_num_possible_cpus()
Thread-Index: AQHVHIkziovDk1bS1k+IIebRE3+eeqaO3Z0A
Date:   Thu, 6 Jun 2019 17:14:50 +0000
Message-ID: <20190606171448.5dsabwn7uz67zisu@kafai-mbp.dhcp.thefacebook.com>
References: <20190606165837.2042247-1-hechaol@fb.com>
 <20190606165837.2042247-2-hechaol@fb.com>
In-Reply-To: <20190606165837.2042247-2-hechaol@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:300:13d::33) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:5827]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4d372dc-9753-44ef-625d-08d6eaa27bde
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1200;
x-ms-traffictypediagnostic: MWHPR15MB1200:
x-microsoft-antispam-prvs: <MWHPR15MB12007D73ED820E7D82291654D5170@MWHPR15MB1200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:372;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(46003)(66556008)(66446008)(64756008)(66476007)(66946007)(14444005)(73956011)(11346002)(53936002)(76176011)(8936002)(99286004)(446003)(186003)(256004)(305945005)(486006)(4326008)(102836004)(6862004)(6116002)(25786009)(6246003)(450100002)(81166006)(2906002)(476003)(6636002)(386003)(6506007)(5660300002)(14454004)(478600001)(6512007)(9686003)(52116002)(316002)(229853002)(86362001)(54906003)(6486002)(71200400001)(81156014)(1076003)(6436002)(68736007)(7736002)(71190400001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1200;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eTqNLVWFEnD11q2z+JxMBjvYCMkNoro6ITZaJfTtkp2imzktjH/LKsunKyid6zTAUIonXspkSxCx35C+3+UJo+1ThX+TEnzhIjoPhH479cyrEBKE4Brf+1njQdrChPvvwGetfiV99HYHheaqn3uwXzUB9bAnwcJAZ+GIGfynHJmVo4ehdlOG9iN5ZidqyPARNGxZnMf0w0/VKLidv/MG2ewC5YVs+T+dyzZb0TT7HZA27zk5kd+0wEgP67rH9Ytug3ryi1aABWG1ATieXFroKV89ro2HhAUy6Fr3meziyUIjvqM1hr4r3rrZqiHbPfk9ndNd+yvP07BT0a48AVGgp5Odr1AFDo4kGxOqaUJJ/IwK0ohw6CGV9QspbaQjA0dPT13tlbem+wZjRGHurR0fA6EFjZK7zKpXlqf0aBeEq2Q=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4F6C49BB45C8B49B47B34EB49B904AB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d372dc-9753-44ef-625d-08d6eaa27bde
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 17:14:50.9602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=981 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 09:58:36AM -0700, Hechao Li wrote:
> Adding a new API libbpf_num_possible_cpus() that helps user with
> per-CPU map operations.
>=20
> Signed-off-by: Hechao Li <hechaol@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 53 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   | 16 ++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 70 insertions(+)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ba89d9727137..ea80ba6f7dfd 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3827,3 +3827,56 @@ void bpf_program__bpil_offs_to_addr(struct bpf_pro=
g_info_linear *info_linear)
>  					     desc->array_offset, addr);
>  	}
>  }
> +
> +int libbpf_num_possible_cpus(void)
> +{
> +	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
> +	int len =3D 0, n =3D 0, il =3D 0, ir =3D 0;
> +	unsigned int start =3D 0, end =3D 0;
> +	static int cpus;
> +	char buf[128];
> +	int error =3D 0;
> +	int fd =3D -1;
> +
> +	if (cpus > 0)
> +		return cpus;
> +
> +	fd =3D open(fcpu, O_RDONLY);
> +	if (fd < 0) {
> +		error =3D errno;
> +		pr_warning("Failed to open file %s: %s\n",
> +			   fcpu, strerror(error));
> +		return -error;
> +	}
> +	len =3D read(fd, buf, sizeof(buf));
> +	close(fd);
> +	if (len <=3D 0) {
> +		error =3D errno;
What is the errno when len =3D=3D 0?

> +		pr_warning("Failed to read # of possible cpus from %s: %s\n",
> +			   fcpu, strerror(error));
> +		return -error;
> +	}
> +	if (len =3D=3D sizeof(buf)) {
> +		pr_warning("File %s size overflow\n", fcpu);
> +		return -EOVERFLOW;
> +	}
> +	buf[len] =3D '\0';
> +
> +	for (ir =3D 0, cpus =3D 0; ir <=3D len; ir++) {
> +		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
> +		if (buf[ir] =3D=3D ',' || buf[ir] =3D=3D '\0') {
> +			buf[ir] =3D '\0';
> +			n =3D sscanf(&buf[il], "%u-%u", &start, &end);
> +			if (n <=3D 0) {
> +				pr_warning("Failed to get # CPUs from %s\n",
> +					   &buf[il]);
> +				return -EINVAL;
> +			} else if (n =3D=3D 1) {
> +				end =3D start;
> +			}
> +			cpus +=3D end - start + 1;
> +			il =3D ir + 1;
> +		}
> +	}
> +	return cpus;
> +}
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 1af0d48178c8..f5e82eb2e5d4 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -454,6 +454,22 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_=
linear *info_linear);
>  LIBBPF_API void
>  bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)=
;
> =20
> +/*
> + * A helper function to get the number of possible CPUs before looking u=
p
> + * per-CPU maps. Negative errno is returned on failure.
> + *
> + * Example usage:
> + *
> + *     int ncpus =3D libbpf_num_possible_cpus();
> + *     if (ncpus <=3D 0) {
> + *          // error handling
> + *     }
> + *     long values[ncpus];
> + *     bpf_map_lookup_elem(per_cpu_map_fd, key, values);
> + *
> + */
> +LIBBPF_API int libbpf_num_possible_cpus(void);
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 46dcda89df21..2c6d835620d2 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -172,4 +172,5 @@ LIBBPF_0.0.4 {
>  		btf_dump__new;
>  		btf__parse_elf;
>  		bpf_object__load_xattr;
> +		libbpf_num_possible_cpus;
>  } LIBBPF_0.0.3;
> --=20
> 2.17.1
>=20
