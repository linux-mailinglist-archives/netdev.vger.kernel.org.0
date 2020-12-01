Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF0D2CAD39
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgLAUXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:23:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbgLAUXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:23:10 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1KDL8K003233
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 12:22:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=j7oEhFlRxqkH1nnc23gOS9iWAlDpRewgxJCSCL+J2Nw=;
 b=R2Tesjig/Cw2Nh6xKBm5Xf4GlSBApgSdnO2qek6MDCgdVfywTSuPQM2x+y02zHxMzFcP
 n7fFPIjBUH35Mfg9x30lCvlSWXibGx4EO3DG8JGdT/GJRqupQBYkwlZ2zV1PFOlnicXY
 wRM4pgbbIrK/6nwNfcZrPjrAzKph5ZsSsUo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 353uh507vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 12:22:29 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 12:22:28 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 8E8F147595570; Tue,  1 Dec 2020 12:22:15 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <prankgup@fb.com>
Subject: Re: [PATCH bpf-next 0/2] Add support to set window_clamp from bpf setsockops
Date:   Tue, 1 Dec 2020 12:22:15 -0800
Message-ID: <20201201202215.3376498-1-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <CAADnVQJK=s5aovsKoQT=qF1novjM4VMyZCGG_6BEenQQWPbTQw@mail.gmail.com>
References: <CAADnVQJK=s5aovsKoQT=qF1novjM4VMyZCGG_6BEenQQWPbTQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_09:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxlogscore=744 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prankur Gupta <prankgup@fb.com>

No reason in particular.
Updated the code (patch v2) to have logic as tcp setsockopt for tCP_WINDO=
W_CLAMP.

PS: First time trying git send-em,ail, pleas elet me know if this is not =
the right way to reply.
