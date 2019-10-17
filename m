Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B302EDB5DC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441326AbfJQSWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44193 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbfJQSV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id q21so2151909pfn.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BgJSKTUhRiWlcuyC/jNgTZutpXbtzZjQXgy5Gh9pMwg=;
        b=VF/agImLV3jmsZlY14mpHJfmZKPD6483ScZM3Nwxb/eQK0L4bFSLr2nt55heXiq/A/
         9RzidS2gDVM4tZO1VgyTHVlqR2/4cCvAI/gUdo3AgzSpjQAZdFGciJJ0INbmvEZw0lPG
         YwM0lTz2uJkF6/4i7dXhW7KRNWhfm7P21A0xi/e6aCtRXXDIJ9KC2ygy1pFfNpf7YGyF
         oNEAIGt1RzWVSUMdnBv/B3K8FUbIoMiTnonPHSirL+2kL+7MCXo6PhBfaKCzmzwg2p7/
         tdcj5aueUZhcbUDOBHOj2O4wLomtB2UYkc47wsMdeGdjtTx8GWEHF7sE/QKAkSH2vkAW
         zQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BgJSKTUhRiWlcuyC/jNgTZutpXbtzZjQXgy5Gh9pMwg=;
        b=b+rGGeBlQerdrL9bJ+5VQf4+OBZBBautbMvgbSeDmSi3/E2mCXxhi6CzbFMj0ZTqC3
         LgwVuAvfL9cqp4NupsCy5e0YzEwezi24Wi1qMjh9hCoGOStOoiGyH8qJKf4+ST5B+Q5k
         mos3Bu55vDRkSA42eRVJszD2EsWMvvP6ts2pTioOKlEV8ljLgR3RupF6R/jnY7Gnob1d
         34zti6j6Ntp2paS4ieSA229o/E9EBh6Xwbqpdcl/5YMNJeIv+C/NjXRXw3qia0mYL3Cy
         yvHg5K5GWFJv1OuNl9SYGdK40qRnkWCNVpUAcwxfYErwx5hirIhrhifIOIDwc3OtypoO
         FlrA==
X-Gm-Message-State: APjAAAX4thrkka1VtigV3DakGDFlTJsuTfbgTbeWOAAFGP3e41Jj2mhX
        +nuhcNzCV70IoLPk7vpV2Mby4SE6
X-Google-Smtp-Source: APXvYqzKItmexh1FaqtxevnMOsqu5jq0Igyxt/HOHqTTPajMmwZ/LLG2As8KhMwwvgG77iqFMyhK9A==
X-Received: by 2002:a17:90a:bc49:: with SMTP id t9mr5826084pjv.111.1571336515505;
        Thu, 17 Oct 2019 11:21:55 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:54 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 14/33] fix unused parameter warning in dsa_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:02 -0700
Message-Id: <20191017182121.103569-14-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/dsa.c:677:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int dsa_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I7da1206aab480823b6aee2aa013db3e2912c8294
---
 dsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/dsa.c b/dsa.c
index 02a10dd..50a171b 100644
--- a/dsa.c
+++ b/dsa.c
@@ -674,7 +674,8 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 #undef FIELD
 #undef REG
 
-int dsa_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int dsa_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	/* DSA per-driver register dump */
 	if (!dsa_mv88e6xxx_dump_regs(regs))
-- 
2.23.0.866.gb869b98d4c-goog

