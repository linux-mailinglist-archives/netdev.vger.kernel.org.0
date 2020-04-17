Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD01AD653
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgDQGmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgDQGl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 02:41:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7EDC061A0C;
        Thu, 16 Apr 2020 23:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q1X56wwvXyEiLB1Ou7FCQcBPEZmOKPYROLn8C9j/eXo=; b=eDcyIdMIuzkRZdnw25wrMRa1yW
        ggLc1WAIHqRTXTMmIawh+ud4RXkZCFuLjHwFevctyw8SDh0KRWejytc5ejSh3DLQOD3WBda4ce9Iw
        FhV8AEe8+PxPJx9Y5EE8RJSpUqWQYodELk5qcF8UekPODUr4khgh7a2v7rMES401vYjOegmvmrDeC
        GdLjz6bLmE00yV1Kr44mjhjZ3E2of4aRjSTZIqi2kMSrsRCRoBNXhC9vRop1LR0/D9LaDLXHvhGWp
        106jnwiwaX2rMIeEsuAPBjgLjsOkoQaAFfHAhZYbWr8y3B6zOSn8cWiL+lYPEhnk9/BXPwl7VLNZ1
        ck/7WHtA==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPKhH-0002hh-17; Fri, 17 Apr 2020 06:41:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 2/6] firmware_loader: remove unused exports
Date:   Fri, 17 Apr 2020 08:41:42 +0200
Message-Id: <20200417064146.1086644-3-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417064146.1086644-1-hch@lst.de>
References: <20200417064146.1086644-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither fw_fallback_config nor firmware_config_table are used by modules.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/firmware_loader/fallback_table.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback_table.c b/drivers/base/firmware_loader/fallback_table.c
index ba9d30b28edc..0a737349f78f 100644
--- a/drivers/base/firmware_loader/fallback_table.c
+++ b/drivers/base/firmware_loader/fallback_table.c
@@ -21,7 +21,6 @@ struct firmware_fallback_config fw_fallback_config = {
 	.loading_timeout = 60,
 	.old_timeout = 60,
 };
-EXPORT_SYMBOL_GPL(fw_fallback_config);
 
 #ifdef CONFIG_SYSCTL
 struct ctl_table firmware_config_table[] = {
@@ -45,5 +44,4 @@ struct ctl_table firmware_config_table[] = {
 	},
 	{ }
 };
-EXPORT_SYMBOL_GPL(firmware_config_table);
 #endif
-- 
2.25.1

