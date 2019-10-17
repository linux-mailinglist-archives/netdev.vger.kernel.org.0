Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75639DB601
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503210AbfJQSVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41153 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503200AbfJQSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so1814096pga.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIVPfnO/wQggB2lntiM1SDCajWBW2Jx3FynrNCFP6BU=;
        b=gFNkLi00Brq/IE7d6d+Ra7XwbOqDLIv8rdFfb1ZMRTsCpZA0jJZ+xCQdP0/zFjTtqz
         aFnbE6Na5/Y9bKJhMsZCeYevw9FA4oSGttnz75xZSfdc0ZCjzJ2AlfSAdnV0zpOm7A1V
         dMc9Kcv+gq0mZ/8N5zrcxCVeQJLUIn+RRmRlF9dZQjKP6i/FDDJ21Uu/KsNEJ+qv3lsY
         /BDDNHaF9D1G5XuqVbtZrLHV3x/jPW791cDg1+M4IFiE/l0g8gsPChumxLFX63/HjTDo
         Vd0UWPyPfYHdpLBHXqeqslveHJ2cVF/WZg1Te7Db9MF7+yDNigshTauaYvoXDvB7pM32
         AHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nIVPfnO/wQggB2lntiM1SDCajWBW2Jx3FynrNCFP6BU=;
        b=dFcWXs2PYVpip51NxbLtJdmnbC1D9SuNpeA5B4DkKZsHIaMrlh3X0mOgJ+VVstCzn1
         fQ532U3X7pBdKDhMxaM/UuHJgJRa20Xf4g4xPnrjqKp1U8VEHtd2F6zzU/qURIN//5Fb
         56q9wavCjQ/OVBjO6FUv54Q2nfw6ZZo7KaFNt6iPRzpDNWbl1+RD39FACDYf5LrLpjzG
         dm3arYsBmL0eJhclNp2lDcYXUkenG8rPlDHS067JTmcbAXFpSRfNQH5+FdUmRFAWTdJV
         MvdhR3gjO4DneUC8vL27nvebbwF03VIaXcYmua6XTbWmHEF/Sg/mjlr0m0wdgyCyF2W2
         exew==
X-Gm-Message-State: APjAAAWmrltkVo85x/auOBu8eIc/9uOr+wCXNX+Kh9wVr/3fzznBDMrF
        fO6pNT7kTF6lsK8DrTAuPKM=
X-Google-Smtp-Source: APXvYqyxKE/ZlL5AeplxZ/Y+q5YrXuSNm635G0XpvnAhwtx/3Dol3gehCPAgWLYG8ERvIbKsnqYd0g==
X-Received: by 2002:a63:495b:: with SMTP id y27mr5570062pgk.438.1571336504841;
        Thu, 17 Oct 2019 11:21:44 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:44 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 06/33] fix unused parameter warning in sfc_dump_regs()
Date:   Thu, 17 Oct 2019 11:20:54 -0700
Message-Id: <20191017182121.103569-6-zenczykowski@gmail.com>
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
  external/ethtool/sfc.c:3894:39: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  sfc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ia255a280742332c44b66bf8f5bb678abc7e3467b
---
 sfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sfc.c b/sfc.c
index b4c590f..69c61e2 100644
--- a/sfc.c
+++ b/sfc.c
@@ -3891,7 +3891,7 @@ print_complex_table(unsigned revision, const struct efx_nic_reg_table *table,
 }
 
 int
-sfc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+sfc_dump_regs(struct ethtool_drvinfo *info maybe_unused, struct ethtool_regs *regs)
 {
 	const struct efx_nic_reg *reg;
 	const struct efx_nic_reg_table *table;
-- 
2.23.0.866.gb869b98d4c-goog

