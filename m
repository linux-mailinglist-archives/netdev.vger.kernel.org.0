Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16938426B86
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbhJHNPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45531 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242410AbhJHNPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8B8EE5C00E0;
        Fri,  8 Oct 2021 09:13:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 08 Oct 2021 09:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m9FPDM0cN0LHONgfKxgxuLE7bL8WbxrovpHeisAwbeg=; b=AxcFTj63
        djehH5Q/KhVITprO0qfdgG3xtueolW3zF8SqjIsoJM0drbTql+YtEYV6EvDHlUsQ
        vVgriroT8TEvGqJGvS+RhaUmi3xgni4MVUr4B2kTmVvJQknE+4QOoUCpGCRwsF4q
        Mcxz1ljZm7uVgc0MV/mFe9Qu7SNd61ldzydTYmWM1913P9ReX7irRGI+jfJUlgcG
        oLFsr21nXaFtDrbbzFaOoaZ5N5t1FptehDoi6+22H535aRig+tU4fuPy//bBgUL5
        fRlmX4YyH8sQfmip2QYEoPJdV2My0sng8svbDxnhVS/3coVCY8dHODyqwkSo5Uqo
        2my+x0nVCL06fg==
X-ME-Sender: <xms:5ENgYQ5anwbRyGwR6EjTD0jjApr94aNIu7D0zI_WMcR5BLMdNecLRA>
    <xme:5ENgYR4IoG2gMcK-0o9hpuicCwjixWYFVFJnryfqqn4UjtBkDfjSlEUrNes4drs1k
    Y4NTs_yf5DwkzY>
X-ME-Received: <xmr:5ENgYffAduvoUu1XOzjgOtShbuaLw3EfteiE18GrxTSotU1su5DFaRRgNgEMI-9MAh9Knb8dK7myjF5h_PGEo6Bqm8fgHXFA_YRb1wjJCA-yvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5ENgYVJ_hU17zKNMug9SL6miw8GpwTOV3DpnCtav_Vu_iOV36IJRvw>
    <xmx:5ENgYUKmFqpZkF8DvsvPGFnWFsJT1EOuA9Dp_r7YJvQ-FqdK4bzD3w>
    <xmx:5ENgYWyywsaXr5NVvml1AAXognuXnY2DDa58cEpA4Tio9V19ppJ3UQ>
    <xmx:5ENgYZEOjqRw7CjI4lc-UcKTqa775iniEqnQTGd8mGV6dYfNOd6gbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] testing: selftests: forwarding.config.sample: Add tc flag
Date:   Fri,  8 Oct 2021 16:12:34 +0300
Message-Id: <20211008131241.85038-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add TC_FLAG value to tests topology.
This flag supposed to be skip_sw/skip_hw which means do not filter by
software/hardware.

This can be useful for adding tests to forwarding directory, and be able
to verify that packets go through the hardware.

When the flag is not set or set to 'skip_hw', tests can still be executed
with veth pairs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/forwarding.config.sample  | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index b802c14d2950..10ce3720aa6f 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -39,3 +39,6 @@ NETIF_CREATE=yes
 # Timeout (in seconds) before ping exits regardless of how many packets have
 # been sent or received
 PING_TIMEOUT=5
+# Flag for tc match, supposed to be skip_sw/skip_hw which means do not process
+# filter by software/hardware
+TC_FLAG=skip_hw
-- 
2.31.1

