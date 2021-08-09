Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3085F3E3EAA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 06:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhHIELR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 00:11:17 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:50719 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhHIELR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 00:11:17 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A0F8B806B5;
        Mon,  9 Aug 2021 16:10:51 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1628482251;
        bh=KECYiZel3OyM1BQQYeI4/T9hq9JbO7y+xolfPmiqoKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=0tZWmyjk4UJIzYfP2jRjimZu4HbRMG13Vbu9dAgN4W1a9UtetvpqcFkftLbadMKNp
         iScsNY31sbBkSYw4MRrOaOSnuBh92S7LtycUAdXSteV9efSk0GP7BCtKxn53hhLefJ
         fu79981jbNEjX9/RLE4vgds5wkqJrkz4EOWQXWOX8cjLri+Gj+x2rpM2iT+ybgumD6
         yu0Mtsqb7hv8da1L/CFj1w4/jxsMCpnSVDdsSLvDDWWh4eM1HJzmPwM3ErvIvNYnpx
         +SsVuCI8QroS6sLzjY8Ve8W4nmPgdceU1mlgJWpmMSNEXxPodO41nc5o+98VhwJJ8m
         rHqjQ3UF8Np1A==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6110aacb0000>; Mon, 09 Aug 2021 16:10:51 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 721A413EDC1;
        Mon,  9 Aug 2021 16:10:51 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 6B19C2428A0; Mon,  9 Aug 2021 16:10:51 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org,
        Cole.Dishington@alliedtelesis.co.nz, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 0/3] Add RFC-7597 Section 5.1 PSID support
Date:   Mon,  9 Aug 2021 16:10:34 +1200
Message-Id: <20210809041037.29969-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726143729.GN9904@breakpoint.cc>
References: <20210726143729.GN9904@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=MhDmnRu9jo8A:10 a=-X3T4Ftr5sKAnL7oE1kA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your time reviewing!

Changes in v7:
- Added net-next to subject.
- Added Reviewed-by: Florian Westphal <fw@strlen.de> to patch 2/3.

Cole Dishington (3):
  net: netfilter: Add RFC-7597 Section 5.1 PSID support xtables API
  net: netfilter: Add RFC-7597 Section 5.1 PSID support
  selftests: netfilter: Add RFC-7597 Section 5.1 PSID selftests

 include/uapi/linux/netfilter/nf_nat.h         |   3 +-
 net/netfilter/nf_nat_core.c                   |  39 +++-
 net/netfilter/nf_nat_masquerade.c             |  27 ++-
 net/netfilter/xt_MASQUERADE.c                 |  44 ++++-
 .../netfilter/nat_masquerade_psid.sh          | 182 ++++++++++++++++++
 5 files changed, 283 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/nat_masquerade_psid=
.sh

--=20
2.32.0

