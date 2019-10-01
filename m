Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AA6C3150
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfJAKZg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 06:25:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726721AbfJAKZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:25:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x91AN4Lp076745
        for <netdev@vger.kernel.org>; Tue, 1 Oct 2019 06:25:34 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vc3g5u6q5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 06:25:34 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 1 Oct 2019 11:25:32 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 1 Oct 2019 11:25:29 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x91APSvZ59244646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Oct 2019 10:25:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76FED42041;
        Tue,  1 Oct 2019 10:25:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A64C42047;
        Tue,  1 Oct 2019 10:25:28 +0000 (GMT)
Received: from dyn-9-152-96-81.boeblingen.de.ibm.com (unknown [9.152.96.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Oct 2019 10:25:28 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next 1/6] selftests/bpf: undo GCC-specific
 bpf_helpers.h changes
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190930185855.4115372-2-andriin@fb.com>
Date:   Tue, 1 Oct 2019 12:25:27 +0200
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Content-Transfer-Encoding: 8BIT
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-2-andriin@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19100110-0008-0000-0000-0000031CB76A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100110-0009-0000-0000-00004A3B6108
Message-Id: <8E58BA2E-FFD2-4CF2-A617-D03D7D712AFB@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-01_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910010098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Am 30.09.2019 um 20:58 schrieb Andrii Nakryiko <andriin@fb.com>:
> 
> Having GCC provide its own bpf-helper.h is not the right approach and is
> going to be changed. Undo bpf_helpers.h change before moving
> bpf_helpers.h into libbpf.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/testing/selftests/bpf/bpf_helpers.h | 8 --------
> 1 file changed, 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 54a50699bbfd..a1d9b97b8e15 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -13,8 +13,6 @@
> 			 ##__VA_ARGS__);		\
> })
> 
> -#ifdef __clang__
> -
> /* helper macro to place programs, maps, license in
>  * different sections in elf_bpf file. Section names
>  * are interpreted by elf_bpf loader
> @@ -258,12 +256,6 @@ struct bpf_map_def {
> 	unsigned int numa_node;
> };
> 
> -#else
> -
> -#include <bpf-helpers.h>
> -
> -#endif
> -
> #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
> 	struct ____btf_map_##name {				\
> 		type_key key;					\
> -- 
> 2.17.1
> 

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
