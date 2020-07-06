Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436A521543D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgGFIz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:55:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728321AbgGFIz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:55:57 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0668XxYm126782;
        Mon, 6 Jul 2020 04:55:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 322nx10ccc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 04:55:41 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0668Y0Ak126893;
        Mon, 6 Jul 2020 04:55:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 322nx10cbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 04:55:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0668ajOF002840;
        Mon, 6 Jul 2020 08:55:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 322h1h236g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:55:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0668tap552429026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 08:55:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D73742042;
        Mon,  6 Jul 2020 08:55:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2108A4203F;
        Mon,  6 Jul 2020 08:55:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 08:55:36 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     jolsa@redhat.com
Cc:     Sumanth.Korikkar@ibm.com, sumanthk@linux.ibm.com,
        agordeev@linux.ibm.com, ast@kernel.org, bas@baslab.org,
        bpf@vger.kernel.org, brendan.d.gregg@gmail.com,
        daniel@iogearbox.net, dxu@dxuuu.xyz, linux-s390@vger.kernel.org,
        mat@mmarchini.me, netdev@vger.kernel.org,
        yauheni.kaliuta@redhat.com
Subject: Re: bpf: bpf_probe_read helper restriction on s390x
Date:   Mon,  6 Jul 2020 10:54:56 +0200
Message-Id: <20200706085456.48306-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200705194225.GB3356590@krava>
References: <20200705194225.GB3356590@krava>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_04:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=769
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007060064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Sorry about the noise. My email seems to be rejected to the list. Resending
with plain text.

s390 has overlapping address space. As suggested by the commit,
ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should not be enabled for s390 kernel.
This should be changed in bpftrace application.

Even if we enable ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, bpf_probe_read will
only work in certain cases like kernel pointer deferences (kprobes).  User
pointer deferences in uprobes/kprobes/etc will fail or have some invalid data

I am looking forward to this fix: https://github.com/iovisor/bpftrace/pull/1141
OR probe split in bpftrace.

Thank you

Best Regards
Sumanth
