Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358FC4A643
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfFRQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:09:17 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44110 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfFRQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:09:17 -0400
Received: by mail-pf1-f201.google.com with SMTP id 5so9574631pff.11
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6IDFouL/H7+c/7AlvTo7X9/eywwkp4tDYTIp5DP7IoQ=;
        b=RTGBpnGivsxhigxzXCCAyfitf1UP+bR777ZW4X0Ba2SvpIluQba8Nf28uEO6Pd9o5s
         +DdSidPp3cu9c3gNfbjiGWKpQeMTdOmgV0ErJWHNaAe0K7qVk7B+O1OKDTT6ILNlyls+
         pWPCf5BrzJNSRDnYReBKEBGriap1vFXaaeb9PyfTjd3fhJ8mp/Uc7PdAJxBBm/QvZSJp
         knf9G59aFXUt0qSOC5r8zoML2Fg9jW4Trxe1ox6ApyOhgbutcRhBbP6Kjj7oI4W0jSqH
         +qXOzddWWWJgYAjKHtU21bNuYSe64JmBWXkGng+stzLXFms86RDD6dxgTMcJp1ySq/LL
         8KCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6IDFouL/H7+c/7AlvTo7X9/eywwkp4tDYTIp5DP7IoQ=;
        b=LcmeCm0g3YL1gH7BIl2Y6IsORbudj+H4RrSn5cR03OFr74UbkT3IsH/OtYKfEGbvnF
         ZNMsX+QfTKciR1dHNj+aWwYhHmFNZKAvGEOiko4JHqlEAx1cDzZi5vx10GhfmDGEunTe
         fICyne00LqGLNGH5HGvVqP/K/WTOUn13D2ZiBxHs4qAmi7r/YN6kXxgNAbHskUyKrKKi
         dtMrdISxntbNVgL0ZM8iR18L0tkjLIBkEnJI+FtjyailpXCKCYqSY9S8ugpcCXLsUHo5
         kiow8/gX9wJJGOMHlO8FtOYPWPSeDczrpuZgfdAKuqdJbP4FVRTa5iBMBLdUQL+uvD+F
         1Fgg==
X-Gm-Message-State: APjAAAVpZPcMyVW9AO9mfw+o8XpV7/vhYkyFhB6TXzM8fa2qWwtpVYCn
        MDdil1nIA+eStc64zHAkMmeR8YTHYg==
X-Google-Smtp-Source: APXvYqyo4hLXmSpMPPPSg/4SQs1y7daEnNSSdHXidTKy9+Ir8lzk1kY1I65tbUu+DwL1MAJ839z0DtEdbg==
X-Received: by 2002:a17:902:6902:: with SMTP id j2mr42357327plk.321.1560874156473;
 Tue, 18 Jun 2019 09:09:16 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:09:10 -0700
In-Reply-To: <20190618083900.78eb88bd@bootlin.com>
Message-Id: <20190618160910.62922-1-nhuck@google.com>
Mime-Version: 1.0
References: <20190618083900.78eb88bd@bootlin.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] net: mvpp2: cls: Add pmap to fs dump
From:   Nathan Huckleberry <nhuck@google.com>
To:     davem@davemloft.net, maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
Added a usage consistent with other fops to dump pmap
to userspace.

Cc: clang-built-linux@googlegroups.com
Link: https://github.com/ClangBuiltLinux/linux/issues/529
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 0ee39ea47b6b..55947bc63cfd 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -566,6 +566,9 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
 	debugfs_create_file("hits", 0444, prs_entry_dir, entry,
 			    &mvpp2_dbgfs_prs_hits_fops);
 
+	ddebugfs_create_file("pmap", 0444, prs_entry_dir, entry,
+			     &mvpp2_dbgfs_prs_pmap_fops);
+
 	return 0;
 }
 
-- 
2.22.0.410.gd8fdbe21b5-goog

