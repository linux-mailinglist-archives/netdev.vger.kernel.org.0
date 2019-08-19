Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEEC9493F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfHSP43 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 19 Aug 2019 11:56:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727580AbfHSP43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:56:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JFlbfU016159
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 11:56:27 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ufwbmc4yq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 11:56:27 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Mon, 19 Aug 2019 16:56:25 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 19 Aug 2019 16:56:23 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7JFu27p41484552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 15:56:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F67CAE058;
        Mon, 19 Aug 2019 15:56:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AB52AE055;
        Mon, 19 Aug 2019 15:56:22 +0000 (GMT)
Received: from dyn-9-152-98-226.boeblingen.de.ibm.com (unknown [9.152.98.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Aug 2019 15:56:22 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [RESEND][PATCH v3 bpf-next] btf: expose BTF info through sysfs
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190812183947.130889-1-andriin@fb.com>
Date:   Mon, 19 Aug 2019 17:56:21 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Transfer-Encoding: 8BIT
References: <20190812183947.130889-1-andriin@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19081915-4275-0000-0000-0000035ACB54
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081915-4276-0000-0000-0000386CE8BB
Message-Id: <3F6DFBAE-ECA5-4E06-B9A0-4D6868FD0B13@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=615 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 12.08.2019 um 20:39 schrieb Andrii Nakryiko <andriin@fb.com>:
> 
> @@ -92,23 +92,34 @@ vmlinux_link()
> }
> 
> # generate .BTF typeinfo from DWARF debuginfo
> +# ${1} - vmlinux image
> +# ${2} - file to dump raw BTF data into
> gen_btf()
> {
> -	local pahole_ver;
> +	local pahole_ver
> +	local bin_arch
> 
> 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
> 		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
> -		return 0
> +		return 1
> 	fi
> 
> 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> 	if [ "${pahole_ver}" -lt "113" ]; then
> 		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
> -		return 0
> +		return 1
> 	fi
> 
> -	info "BTF" ${1}
> +	info "BTF" ${2}
> +	vmlinux_link ${1}
> 	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> +
> +	# dump .BTF section into raw binary file to link with final vmlinux
> +	bin_arch=$(${OBJDUMP} -f ${1} | grep architecture | \
> +		cut -d, -f1 | cut -d' ' -f2)
> +	${OBJCOPY} --dump-section .BTF=.btf.kernel.bin ${1} 2>/dev/null
> +	${OBJCOPY} -I binary -O ${CONFIG_OUTPUT_FORMAT} -B ${bin_arch} \
> +		--rename-section .data=.BTF .btf.kernel.bin ${2}
> }

CONFIG_OUTPUT_FORMAT appears to be x86-only; enabling
CONFIG_DEBUG_INFO_BTF on s390 caused a build failure. I now have a quick
and dirty local patch, which adds CONFIG_OUTPUT_FORMAT to s390 and fixes
the issue for me, but I suspect that CONFIG_DEBUG_INFO_BTF might be
broken on other arches as well.
