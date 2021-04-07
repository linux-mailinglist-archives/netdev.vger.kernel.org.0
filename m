Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A30535604B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbhDGA2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhDGA2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:28:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C806121E;
        Wed,  7 Apr 2021 00:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755319;
        bh=sFQemyfJlZSNF9npjcOCt+f1d+hFG7NudwKKR/Mj0EE=;
        h=From:To:Cc:Subject:Date:From;
        b=MCfNmTxzHfFXTo9tWju3shr5WNFVF0wFqP3NkKIlVov+fMFv8coRHIXo0iVXoqC6h
         wAADI06ShsWl4UqAttHN+ieuKd+KNGNuv3lhSSzXy98M5bFtZUC7Gw+kqJmN7aEzGj
         J/ismO4vF4d72vqUMz2TCpa9uJYEskKq7TRLguFjhdDqOMulEDbZgjpiDSh5E/SLXf
         Ic00JyuBogU3wesPapFowKCAyHz/s3H6pqBo4iXdgWem2BqgPbpl52Ld2zHT2BcfR6
         XM2B44PCEZdtxhDNnE+5yhrpwGhN+mKtBcH4hkwNiD1eAWdxzfWqUFzgyRZ2EyRhN1
         PzorER9OtEhRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] ethtool: kdoc fixes
Date:   Tue,  6 Apr 2021 17:28:24 -0700
Message-Id: <20210407002827.1861191-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of kdoc fixes to ethtool headers. All comment changes.

With all the patches posted kdoc script seems happy:
$ ./scripts/kernel-doc -none include/uapi/linux/ethtool.h include/linux/ethtool.h
$

Note that some of the changes are in -next, e.g. the FEC
documentation update so full effect will be seen after
trees converge.

Jakub Kicinski (3):
  ethtool: un-kdocify extended link state
  ethtool: document reserved fields in the uAPI
  ethtool: fix kdoc in headers

 include/linux/ethtool.h      | 13 +++++----
 include/uapi/linux/ethtool.h | 54 ++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 26 deletions(-)

-- 
2.30.2

