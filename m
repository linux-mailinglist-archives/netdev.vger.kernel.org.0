Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3660222A80
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgGPRyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:54:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727844AbgGPRyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:54:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GHWA58140286;
        Thu, 16 Jul 2020 13:53:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv0qk1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 13:53:51 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06GHXYJd144707;
        Thu, 16 Jul 2020 13:53:51 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv0qk02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 13:53:51 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GHpJdk003707;
        Thu, 16 Jul 2020 17:53:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgwntf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 17:53:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GHrk6V62915054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 17:53:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89AB6AE055;
        Thu, 16 Jul 2020 17:53:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3117AE051;
        Thu, 16 Jul 2020 17:53:45 +0000 (GMT)
Received: from sig-9-145-186-215.de.ibm.com (unknown [9.145.186.215])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 17:53:45 +0000 (GMT)
Message-ID: <4e0c4f3f6278617dc54fc755d899dbbab396f24d.camel@linux.ibm.com>
Subject: Re: [PATCH] Revert "test_bpf: flag tests that cannot be jited on
 s390"
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Seth Forshee <seth.forshee@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 16 Jul 2020 19:53:45 +0200
In-Reply-To: <20200716143931.330122-1-seth.forshee@canonical.com>
References: <20200716143931.330122-1-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=3
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-16 at 09:39 -0500, Seth Forshee wrote:
> This reverts commit 3203c9010060806ff88c9989aeab4dc8d9a474dc.
> 
> The s390 bpf JIT previously had a restriction on the maximum
> program size, which required some tests in test_bpf to be flagged
> as expected failures. The program size limitation has been removed,
> and the tests now pass, so these tests should no longer be flagged.
> 
> Fixes: d1242b10ff03 ("s390/bpf: Remove JITed image size limitations")
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  lib/test_bpf.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index a5fddf9ebcb7..ca7d635bccd9 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -5275,31 +5275,21 @@ static struct bpf_test tests[] = {
>  	{	/* Mainly checking JIT here. */
>  		"BPF_MAXINSNS: Ctx heavy transformations",
>  		{ },
> -#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
> -		CLASSIC | FLAG_EXPECTED_FAIL,
> -#else
>  		CLASSIC,
> -#endif
>  		{ },
>  		{
>  			{  1, SKB_VLAN_PRESENT },
>  			{ 10, SKB_VLAN_PRESENT }
>  		},
>  		.fill_helper = bpf_fill_maxinsns6,
> -		.expected_errcode = -ENOTSUPP,
>  	},
>  	{	/* Mainly checking JIT here. */
>  		"BPF_MAXINSNS: Call heavy transformations",
>  		{ },
> -#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
> -		CLASSIC | FLAG_NO_DATA | FLAG_EXPECTED_FAIL,
> -#else
>  		CLASSIC | FLAG_NO_DATA,
> -#endif
>  		{ },
>  		{ { 1, 0 }, { 10, 0 } },
>  		.fill_helper = bpf_fill_maxinsns7,
> -		.expected_errcode = -ENOTSUPP,
>  	},
>  	{	/* Mainly checking JIT here. */
>  		"BPF_MAXINSNS: Jump heavy test",
> @@ -5350,28 +5340,18 @@ static struct bpf_test tests[] = {
>  	{
>  		"BPF_MAXINSNS: exec all MSH",
>  		{ },
> -#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
> -		CLASSIC | FLAG_EXPECTED_FAIL,
> -#else
>  		CLASSIC,
> -#endif
>  		{ 0xfa, 0xfb, 0xfc, 0xfd, },
>  		{ { 4, 0xababab83 } },
>  		.fill_helper = bpf_fill_maxinsns13,
> -		.expected_errcode = -ENOTSUPP,
>  	},
>  	{
>  		"BPF_MAXINSNS: ld_abs+get_processor_id",
>  		{ },
> -#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
> -		CLASSIC | FLAG_EXPECTED_FAIL,
> -#else
>  		CLASSIC,
> -#endif
>  		{ },
>  		{ { 1, 0xbee } },
>  		.fill_helper = bpf_fill_ld_abs_get_processor_id,
> -		.expected_errcode = -ENOTSUPP,
>  	},
>  	/*
>  	 * LD_IND / LD_ABS on fragmented SKBs

Thank you for the fix!
I tested it and it indeed fixes these 4 failures.

I will have a look at the remaining 8 tomorrow.

Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>

