Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB55412F61
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfECNl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 09:41:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbfECNl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 09:41:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43DX10P127946
        for <netdev@vger.kernel.org>; Fri, 3 May 2019 09:41:27 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s8p4k9uqf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 09:41:27 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Fri, 3 May 2019 14:41:24 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 May 2019 14:41:21 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x43DfKgo60555504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 May 2019 13:41:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F5ECA4060;
        Fri,  3 May 2019 13:41:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C466A4054;
        Fri,  3 May 2019 13:41:20 +0000 (GMT)
Received: from osiris (unknown [9.152.212.21])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 May 2019 13:41:20 +0000 (GMT)
Date:   Fri, 3 May 2019 15:41:19 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v6 bpf-next 13/17] s390: bpf: eliminate zero extension
 code-gen
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-14-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556880164-10689-14-git-send-email-jiong.wang@netronome.com>
X-TM-AS-GCONF: 00
x-cbid: 19050313-0016-0000-0000-00000277F6D4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050313-0017-0000-0000-000032D49407
Message-Id: <20190503134118.GA5602@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030086
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 11:42:40AM +0100, Jiong Wang wrote:
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  arch/s390/net/bpf_jit_comp.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

When sending patches which affect s390, could you please add Martin
and me on cc to _all_ patches? We now received only the cover-letter
plus one patch. It's always hard in such cirumstances to figure out if
the code is doing the right thing.

Usually I end up looking up the missing patches within other mailing
lists, however I haven't subscribed the bpf and netdev mailing lists.

The extra e-mail volume because of being added to CC really doesn't
matter at all.

