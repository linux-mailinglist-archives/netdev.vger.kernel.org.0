Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF18A34E0C2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhC3FmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:42:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23240 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhC3Flx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:41:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U5Xb2H024008
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:41:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=aFiNfz9a7AIq3Tlxf0ofILti0xs1oAdsGadVup82H1A=;
 b=LcYas0K5ACKgN8M0UjBW2jaTy/HJslkHkZD4dW7VRbp87raqDXd/u8MCCoj8HitGp5mz
 xhfXv2vcQiHFQcTmFcuOy42OfxRpU2fopnD2azbshiVLTVGEXwLzvKme8/i978eUa0xm
 nY74ykXYb2sZbyAeMxvB5zohNeHoW7K7XW8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37karjx6kg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:41:52 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 22:41:50 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C91B12942D2F; Mon, 29 Mar 2021 22:41:43 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/2] bpf: Update doc about calling kernel function
Date:   Mon, 29 Mar 2021 22:41:43 -0700
Message-ID: <20210330054143.2932947-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yPBCUz8CWIJkP2zIBKn-72hWLgWNFCbB
X-Proofpoint-ORIG-GUID: yPBCUz8CWIJkP2zIBKn-72hWLgWNFCbB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_01:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=729 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103300039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set updates the document about the bpf program calling kernel
function.  In particular, updates are regarding to the clang
requirement in selftests and kfunc-call not an ABI.

Martin KaFai Lau (2):
  bpf: Update bpf_design_QA.rst to clarify the kfunc call is not ABI
  bpf: selftests: Update clang requirement in README.rst for testing
    kfunc call

 Documentation/bpf/bpf_design_QA.rst    | 15 +++++++++++++++
 tools/testing/selftests/bpf/README.rst | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

--=20
2.30.2

