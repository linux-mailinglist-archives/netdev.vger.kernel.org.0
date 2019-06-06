Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA8637AC5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfFFRRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:17:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46572 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbfFFRRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:17:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56HFE6n024477;
        Thu, 6 Jun 2019 10:17:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZkcLgUfKJbOKY/GusugYeBM9w/G/NUprwfVbzclGXUU=;
 b=aE/f54XK/cO+FerpZ3aLzexbYOFezdmk5AMVPM4wCo60V1vx17irTofq7MlxpDHWCfyo
 9B8U9FLN+KmFmwK1xBQCtUETdS57ZzBQMIaLk0KC69cWCN/+08KTnIKXq6lvT394v45O
 58FFm1GWD1cNj44RRG0saeou6pb0ZMJyreA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxsmr2rs0-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 10:17:47 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 10:17:31 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 10:17:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkcLgUfKJbOKY/GusugYeBM9w/G/NUprwfVbzclGXUU=;
 b=XPnjhnunUwOC5R/A/fS2mbv90nhc2f/Q98HvuEoLvs311NB9Qsn+/2gEtweDxYpovSMpmAuPey2HY7WkL4K9C1PxcGwnNja1kpaZUE/oYIMOokhpK9+Lo+q7mASUM/srTJwFLm7b/nb+e4LE/tHgl/V/b0vIf/2NRoeYa0nL4iw=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1200.namprd15.prod.outlook.com (10.175.3.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Thu, 6 Jun 2019 17:17:30 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 17:17:30 +0000
From:   Martin Lau <kafai@fb.com>
To:     Hechao Li <hechaol@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/2] bpf: use libbpf_num_possible_cpus in
 bpftool and selftests
Thread-Topic: [PATCH v2 bpf-next 2/2] bpf: use libbpf_num_possible_cpus in
 bpftool and selftests
Thread-Index: AQHVHIlfkj/IQbdAQUaTe21fBy4DdqaO3lqA
Date:   Thu, 6 Jun 2019 17:17:29 +0000
Message-ID: <20190606171727.ozcf2guzd3brxho5@kafai-mbp.dhcp.thefacebook.com>
References: <20190606165837.2042247-1-hechaol@fb.com>
 <20190606165837.2042247-3-hechaol@fb.com>
In-Reply-To: <20190606165837.2042247-3-hechaol@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:301:39::17) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:5827]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a776e02-edbe-4bd1-1b18-08d6eaa2da7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1200;
x-ms-traffictypediagnostic: MWHPR15MB1200:
x-microsoft-antispam-prvs: <MWHPR15MB1200B5D0000849DCC49C449FD5170@MWHPR15MB1200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:182;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(46003)(66556008)(66446008)(64756008)(66476007)(66946007)(14444005)(73956011)(11346002)(53936002)(76176011)(8936002)(99286004)(446003)(186003)(256004)(305945005)(486006)(4326008)(102836004)(6862004)(6116002)(25786009)(6246003)(450100002)(81166006)(2906002)(476003)(6636002)(386003)(6506007)(5660300002)(14454004)(478600001)(6512007)(9686003)(52116002)(316002)(229853002)(86362001)(54906003)(6486002)(71200400001)(81156014)(1076003)(6436002)(68736007)(7736002)(71190400001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1200;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +SWzL28PMgpPPQ3YBLrHDHBrlPlL1H/bzQFOOW8HIjWA/9Yk8poRneVr7BmihUatw8PQIkgrhCzaJ3666D+fz4SJepbmuhC3vMUGjXDsnLIQa/CIp1veW5GMzmRE7r/oOWBkwkMR5GiEMkFiwZlCGrL79q/WHs3RQtGR865sFOG84mLcpmNfKgMHuXfVJxpdbUXmKAwNRhmIxrLg5YmoQgpFSoVIh/o6n2sz9as2X1YziLKv9ipBvPWtpZ9gNAb0zKeE6WCBl8HvLgZxgorUM5l1wM91/xCokNvjEe2COWJN2bSGgLSD+rbvDaGdIsX/xjS7uwbseFmV3Xc37EtjPoKhffIC/V4NCPx4s5u+j44EtiHP4XSdRjqtRQt4A9qe/PcWKnd7k22KjNb3zSwutOxGLVNSDSb4kpgZhIX8zGg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <494E647764FE684FA400E5E14039D87D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a776e02-edbe-4bd1-1b18-08d6eaa2da7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 17:17:29.8354
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
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 09:58:37AM -0700, Hechao Li wrote:
> Use the newly added bpf_num_possible_cpus() in bpftool and selftests
> and remove duplicate implementations.
>=20
> Signed-off-by: Hechao Li <hechaol@fb.com>
> ---
>  tools/bpf/bpftool/common.c             | 53 +++-----------------------
>  tools/testing/selftests/bpf/bpf_util.h | 37 +++---------------
>  2 files changed, 10 insertions(+), 80 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index f7261fad45c1..0b1c56758cd9 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -21,6 +21,7 @@
>  #include <sys/vfs.h>
> =20
>  #include <bpf.h>
> +#include <libbpf.h> /* libbpf_num_possible_cpus */
> =20
>  #include "main.h"
> =20
> @@ -439,57 +440,13 @@ unsigned int get_page_size(void)
> =20
>  unsigned int get_possible_cpus(void)
>  {
> -	static unsigned int result;
> -	char buf[128];
> -	long int n;
> -	char *ptr;
> -	int fd;
> -
> -	if (result)
> -		return result;
> -
> -	fd =3D open("/sys/devices/system/cpu/possible", O_RDONLY);
> -	if (fd < 0) {
> -		p_err("can't open sysfs possible cpus");
> -		exit(-1);
> -	}
> -
> -	n =3D read(fd, buf, sizeof(buf));
> -	if (n < 2) {
> -		p_err("can't read sysfs possible cpus");
> -		exit(-1);
> -	}
> -	close(fd);
> +	int cpus =3D libbpf_num_possible_cpus();
> =20
> -	if (n =3D=3D sizeof(buf)) {
> -		p_err("read sysfs possible cpus overflow");
> +	if (cpus <=3D 0) {
> +		p_err("can't get # of possible cpus");
>  		exit(-1);
>  	}
> -
> -	ptr =3D buf;
> -	n =3D 0;
> -	while (*ptr && *ptr !=3D '\n') {
> -		unsigned int a, b;
> -
> -		if (sscanf(ptr, "%u-%u", &a, &b) =3D=3D 2) {
> -			n +=3D b - a + 1;
> -
> -			ptr =3D strchr(ptr, '-') + 1;
> -		} else if (sscanf(ptr, "%u", &a) =3D=3D 1) {
> -			n++;
> -		} else {
> -			assert(0);
> -		}
> -
> -		while (isdigit(*ptr))
> -			ptr++;
> -		if (*ptr =3D=3D ',')
> -			ptr++;
> -	}
> -
> -	result =3D n;
> -
> -	return result;
> +	return cpus;
>  }
> =20
>  static char *
> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selft=
ests/bpf/bpf_util.h
> index a29206ebbd13..9ad9c7595f93 100644
> --- a/tools/testing/selftests/bpf/bpf_util.h
> +++ b/tools/testing/selftests/bpf/bpf_util.h
> @@ -6,44 +6,17 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <errno.h>
> +#include <libbpf.h>
> =20
>  static inline unsigned int bpf_num_possible_cpus(void)
>  {
> -	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
> -	unsigned int start, end, possible_cpus =3D 0;
> -	char buff[128];
> -	FILE *fp;
> -	int len, n, i, j =3D 0;
> +	int possible_cpus =3D libbpf_num_possible_cpus();
> =20
> -	fp =3D fopen(fcpu, "r");
> -	if (!fp) {
> -		printf("Failed to open %s: '%s'!\n", fcpu, strerror(errno));
> +	if (possible_cpus <=3D 0) {
hmmm... so it seems that possible_cpus could be 0?
or libbpf_num_possible_cpus() should never return 0?

> +		printf("Failed to get # of possible cpus: '%s'!\n",
> +		       strerror(-possible_cpus));
strerror(0) does not seem right.

>  		exit(1);
>  	}
> -
> -	if (!fgets(buff, sizeof(buff), fp)) {
> -		printf("Failed to read %s!\n", fcpu);
> -		exit(1);
> -	}
> -
> -	len =3D strlen(buff);
> -	for (i =3D 0; i <=3D len; i++) {
> -		if (buff[i] =3D=3D ',' || buff[i] =3D=3D '\0') {
> -			buff[i] =3D '\0';
> -			n =3D sscanf(&buff[j], "%u-%u", &start, &end);
> -			if (n <=3D 0) {
> -				printf("Failed to retrieve # possible CPUs!\n");
> -				exit(1);
> -			} else if (n =3D=3D 1) {
> -				end =3D start;
> -			}
> -			possible_cpus +=3D end - start + 1;
> -			j =3D i + 1;
> -		}
> -	}
> -
> -	fclose(fp);
> -
>  	return possible_cpus;
>  }
> =20
> --=20
> 2.17.1
>=20
