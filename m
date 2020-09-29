Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FACB27CC64
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgI2Mf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:35:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgI2Mfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:35:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TCTelQ162405;
        Tue, 29 Sep 2020 12:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XjD5+E/lRfYfuWijGUsC1sO+VMZYXDA0kVQ9CGtozzQ=;
 b=h4ktMLC7TvlTZNgfyQ6iUjidM3jALcN4/T7xAu2TnyTeDBrP7rvbFwskuW3nati7ziZ3
 WrnlX5935ZlG6ZiXTzhVFbvcc0vYtRtlzbz30DFX8myYmxEkk7iKAWRtASt1VgVSPqkX
 HHwDZsaPaNOfWNeRDbld9wJX9SkHVcMeUAcMuPhp9aup+4Veh8j7h5KiUZMyHsnEaq0P
 gPjqFD9LA0OFQAuN1tjQbryIObKZROTnROpDVLl1MbIZbA5mMLfrB9Car4nUh4MhnXFE
 hvXIEQMGNuHRMrxQuPjk8a/SDfuVR8txdGeI2rbqaUyIM5XBeA9HRO3XL9mhIijvomaj lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkktd5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 12:35:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TCUPLp004041;
        Tue, 29 Sep 2020 12:35:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33tfhxjr7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 12:35:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08TCZZjP024840;
        Tue, 29 Sep 2020 12:35:35 GMT
Received: from dhcp-10-175-194-32.vpn.oracle.com (/10.175.194.32)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 05:35:35 -0700
Date:   Tue, 29 Sep 2020 13:35:26 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next] selftests/bpf_iter: don't fail test due to
 missing __builtin_btf_type_id
In-Reply-To: <20200929123004.46694-1-toke@redhat.com>
Message-ID: <alpine.LRH.2.21.2009291333310.26076@localhost>
References: <20200929123004.46694-1-toke@redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1737402268-1601382935=:26076"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=11 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=11 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1737402268-1601382935=:26076
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 29 Sep 2020, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

> The new test for task iteration in bpf_iter checks (in do_btf_read()) if =
it
> should be skipped due to missing __builtin_btf_type_id. However, this
> 'skip' verdict is not propagated to the caller, so the parent test will
> still fail. Fix this by also skipping the rest of the parent test if the
> skip condition was reached.
>=20
> Fixes: b72091bd4ee4 ("selftests/bpf: Add test for bpf_seq_printf_btf help=
er")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>

Thanks for fixing this Toke!

> ---
>  tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
> index af15630a24dd..448885b95eed 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -172,17 +172,18 @@ static void test_task_file(void)
> =20
>  static char taskbuf[TASKBUFSZ];
> =20
> -static void do_btf_read(struct bpf_iter_task_btf *skel)
> +static int do_btf_read(struct bpf_iter_task_btf *skel)
>  {
>  =09struct bpf_program *prog =3D skel->progs.dump_task_struct;
>  =09struct bpf_iter_task_btf__bss *bss =3D skel->bss;
>  =09int iter_fd =3D -1, len =3D 0, bufleft =3D TASKBUFSZ;
>  =09struct bpf_link *link;
>  =09char *buf =3D taskbuf;
> +=09int ret =3D 0;
> =20
>  =09link =3D bpf_program__attach_iter(prog, NULL);
>  =09if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
> -=09=09return;
> +=09=09return ret;
> =20
>  =09iter_fd =3D bpf_iter_create(bpf_link__fd(link));
>  =09if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
> @@ -198,6 +199,7 @@ static void do_btf_read(struct bpf_iter_task_btf *ske=
l)
> =20
>  =09if (bss->skip) {
>  =09=09printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
> +=09=09ret =3D 1;
>  =09=09test__skip();
>  =09=09goto free_link;
>  =09}
> @@ -212,12 +214,14 @@ static void do_btf_read(struct bpf_iter_task_btf *s=
kel)
>  =09if (iter_fd > 0)
>  =09=09close(iter_fd);
>  =09bpf_link__destroy(link);
> +=09return ret;
>  }
> =20
>  static void test_task_btf(void)
>  {
>  =09struct bpf_iter_task_btf__bss *bss;
>  =09struct bpf_iter_task_btf *skel;
> +=09int ret;
> =20
>  =09skel =3D bpf_iter_task_btf__open_and_load();
>  =09if (CHECK(!skel, "bpf_iter_task_btf__open_and_load",
> @@ -226,7 +230,9 @@ static void test_task_btf(void)
> =20
>  =09bss =3D skel->bss;
> =20
> -=09do_btf_read(skel);
> +=09ret =3D do_btf_read(skel);
> +=09if (ret)
> +=09=09goto cleanup;
> =20
>  =09if (CHECK(bss->tasks =3D=3D 0, "check if iterated over tasks",
>  =09=09  "no task iteration, did BPF program run?\n"))
> --=20
> 2.28.0
>=20
>=20
--8323328-1737402268-1601382935=:26076--
