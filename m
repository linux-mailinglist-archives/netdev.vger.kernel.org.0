Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18C1DE5A6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgEVLhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:37:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgEVLhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:37:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBVvPk102651;
        Fri, 22 May 2020 11:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=DmsvtQ/8SYimqUVvb41eUrdJHrvcJxY6DxjzzS+9LdY=;
 b=e+QcgFjwnov2e/6vj1x0TQ942WM3QLPxSKNt8Qh2VdbnLwHTjSBOmDKjjfT8teItv7ZN
 +oVxUJ6+JfGo9p/SwjHxMITIkfZagzwJo4tLiuGIO/3cbhGul93HrhC6awTec762PidS
 j6Fjc1V7oE9PPU0qH6C5HVD4Ut1aVgjx2DasHe0vV+tWcRhSRebo5TxVNEJjNpkwBDpU
 d8Akk0aj2KrnGZN3EcR1p/V3ZO0+tRZNCo+C3MU97B4tdyrd5lqXlRnVyjn+3R1XQ7mg
 YEz922wdALFpzD0KN0B2cowyAnjIfDpqbksUZHJ0Y0ZlS2jPqkbkez42cT82ceO9IKX9 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31501rkt6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 11:36:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBWkU9186456;
        Fri, 22 May 2020 11:36:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 313gj7b9vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 11:36:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MBab27012862;
        Fri, 22 May 2020 11:36:37 GMT
Received: from localhost.uk.oracle.com (/10.175.194.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 04:36:37 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, sean@mess.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf 0/2] selftests/bpf: add missing CONFIG values to test config
Date:   Fri, 22 May 2020 12:36:27 +0100
Message-Id: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=970
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selftests "config" file is intended to represent the config required
to run the tests; a few values are missing for the BPF selftests
and these can result in test failures due to missing helpers etc.
Add the missing values as they will help document the config needed
for a clean BPF selftests run.

Alan Maguire (2):
  selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
  selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh

 tools/testing/selftests/bpf/config | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.8.3.1

