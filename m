Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE73426B8B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbhJHNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242524AbhJHNPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E1215C00E0;
        Fri,  8 Oct 2021 09:13:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 09:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=OAGYGxpgPlF3U7BSAsvk63OmhHljcCJV78oESUyI5bM=; b=TLJcd44L
        vbUztnklMIE0vyggfXKEXT/br/jgWfAEVavN4A+01XaeaBQNcVY0pLn26F/Fa+Ay
        yDUkc9pZwT72aoqR9xHXoPjyiLnTctiCKm0akbwuHrZGCrxM3MHVsEjoPcDizN2Q
        FdF0nmRaMtdjRCceZyQWKPmqxmKLLPyD/MljHYdIxeEObmymVf9anLksswtiiZ60
        hoZzYrh+RBl9jHHUddOWqyqYK1l7m2PsapeLXnSedOrSSf3klo6TCZuc1jPYkiq9
        /978aWD3pw/1TBnQ91SVzsTWU1JBBGXbTfqslHHaeaTg+NNAgIdPdO/COtFlgIBj
        0tiSY32fG3kFtw==
X-ME-Sender: <xms:70NgYdNoDdPUSPjktCxEpV4IOt8bJ0VIRWlZz-QaCZOl864tahmtRw>
    <xme:70NgYf9PXc0C9KCIIHr0_BYFjSrpiGSJ1T5pmh-he-mSIo9OX-YTkxqVzepe-Um7K
    6LOmVi3Mhab3eU>
X-ME-Received: <xmr:70NgYcSBDh-tfTMJXDrYF2uCtF10v--Cevgu9FX52bM-NzzYEpCIyScRUIstVd8aDqieGg3EIaQZfgoetZ-urwoQgh7VrEhfIfy1k_RzAFFXDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:70NgYZvEVh-wknkK7R6g0wXv1y1xtOPzpMz5Js-Ljzq3e6f7EjSlLg>
    <xmx:70NgYVe8vDFNaBxLyHa9p3BQFe_vWnZ3gLD2w9Q9V_kG8fPT_aYWSw>
    <xmx:70NgYV33rFFvG7CTim7tIfV2ygexA44G3Afg800cDL0kyWvV767tKQ>
    <xmx:70NgYc6FGNYwMulnVCh7Oh61VQOdCRWvRxGpEku3yYhAgEu4NTrkNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Align topology drawing correctly
Date:   Fri,  8 Oct 2021 16:12:39 +0300
Message-Id: <20211008131241.85038-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of adding same test for GRE tunnel with IPv6 underlay, wrong
alignments were found, fix them.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
index 8817851da7a9..e2ab26b790a0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
@@ -13,7 +13,7 @@
 #                     |
 # +-------------------|-----+
 # | SW1               |     |
-# |              $swp1 +    |
+# |             $swp1 +     |
 # |      192.0.2.2/28       |
 # |                         |
 # |  + g1a (gre)            |
@@ -27,8 +27,8 @@
 #    |
 # +--|----------------------+
 # |  |                 VRF2 |
-# | + $rp2                  |
-# |   198.51.100.2/28       |
+# |  + $rp2                 |
+# |    198.51.100.2/28      |
 # +-------------------------+
 
 lib_dir=$(dirname $0)/../../../net/forwarding
-- 
2.31.1

