Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2304827F66A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgJAAF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbgJAAF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:27 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42ED32085B;
        Thu,  1 Oct 2020 00:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510727;
        bh=3gxw13tMwww5Zoj4cA3F2PRtClm/f7JvfdUGN79ftM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXuOMD2/k3lBX8LRN8RoF40GI5CUNp1KY5DA1C6sYdRX+BRcT9P5e36Eu6rCd9Q2D
         CQhyAeDyxJorRd8DiN2F9qynMYkyk6xQpRBHD/6H4G1qIIhYoRgnpb9VhAaHKjAdSr
         WMRkoz8jnM1COFDtop+znlkjkkpaerQ83Hw3xKPk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 1/9] genetlink: add missing kdoc for validation flags
Date:   Wed, 30 Sep 2020 17:05:10 -0700
Message-Id: <20201001000518.685243-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validation flags are missing kdoc, add it.

Fixes: ef6243acb478 ("genetlink: optionally validate strictly/dumps")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index b9eb92f3fe86..a3484fd736d6 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -130,6 +130,7 @@ genl_dumpit_info(struct netlink_callback *cb)
  * @cmd: command identifier
  * @internal_flags: flags used by the family
  * @flags: flags
+ * @validate: validation flags from enum genl_validate_flags
  * @doit: standard command callback
  * @start: start callback for dumps
  * @dumpit: callback for dumpers
-- 
2.26.2

