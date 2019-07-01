Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DFC5B713
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfGAIpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:45:44 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:46660 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfGAIpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 04:45:44 -0400
Received: by mail-pg1-f174.google.com with SMTP id i8so2488824pgm.13
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 01:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmIQTVezf0Ag+Dm9FyktGRzvtIo7c1dt2XsDapMoMcw=;
        b=YdJlE2dxgn0NJdJl9LN1qBZMvryR2/ORmBXIGnEQxnNk0dHfkvBPDyO9wxv0KfC7lX
         HnWPjQNovzCjwQnMJvST9F+fNVqk8mHDs8S7zZ8O0iSltGqOoDNvmC7qYmgXH+WjgUd5
         GGbfdOQ+aIf5T6O5JJAVtRZ4bpFCDuH6pT+L9vDt2DjDFs/cjZYutt/+HT7rxymf52sE
         qgM4ztv27RIWMCBCq1k/cTjRBV/kndSWm0qpf4e5F3dqk3mfRho3pH8IYaotWVKKOlxC
         SXZfXQPmSG7TQg5LFAG5f+CHh6w+/cDhXvR3IP2M/fuObGEDwSn32J2gjAlaoiYiLW5J
         RVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmIQTVezf0Ag+Dm9FyktGRzvtIo7c1dt2XsDapMoMcw=;
        b=pSfax0apnwjFdvqcEGrAqY2L2Qn8kiZL38XmIjeUqFDp8PJlcucryYKk+y99j67aVe
         pe4XgfoBn+M3bb5dGF5LKWnXLTLLIJeKbGTsEQ6TK21bJG+dMUTrleTU74uL9PHIKMV3
         bpNtlTzo9MwsV9xZoTQm19OjKawAxjHtlpyqlCnDoOr/vYnwPlJpOTiYMuvFcLx3faqk
         9jYdXnM+BfGqhZsa5GVYHAzhXrfCfqYg2rPQOZUVAA1OzyRLClXsO1bycr1AqYiKrLTL
         eKG8/YmI3PuV0ZYFyOlbJV7M77td2k9HJ9iKUzHYJ1p86ps46OACLhD0+z6yWCrifKfv
         GPAA==
X-Gm-Message-State: APjAAAXIRCPfaoHwQ4DRve25Nm0TKR7F4bGT6zIUf5+UR0Th7emQwCVe
        8bma0wgCxHjVF9QIsfb47uxjm/weBkI=
X-Google-Smtp-Source: APXvYqzYWg2YQ+oFgn++G/o6jQZOTFiugZPpvkTMZXXXGjSKmafJHd9gQaLI4Tvg3lwUpRPDlDk14g==
X-Received: by 2002:a65:6497:: with SMTP id e23mr3324324pgv.89.1561970743736;
        Mon, 01 Jul 2019 01:45:43 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b5sm23864788pga.72.2019.07.01.01.45.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 01:45:43 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] Documentation/networking: fix default_ttl typo in mpls-sysctl
Date:   Mon,  1 Jul 2019 16:45:28 +0800
Message-Id: <20190701084528.25872-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

default_ttl should be integer instead of bool

Reported-by: Ying Xu <yinxu@redhat.com>
Fixes: a59166e47086 ("mpls: allow TTL propagation from IP packets to be configured")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/mpls-sysctl.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/mpls-sysctl.txt b/Documentation/networking/mpls-sysctl.txt
index 2f24a1912a48..025cc9b96992 100644
--- a/Documentation/networking/mpls-sysctl.txt
+++ b/Documentation/networking/mpls-sysctl.txt
@@ -30,7 +30,7 @@ ip_ttl_propagate - BOOL
 	0 - disabled / RFC 3443 [Short] Pipe Model
 	1 - enabled / RFC 3443 Uniform Model (default)
 
-default_ttl - BOOL
+default_ttl - INTEGER
 	Default TTL value to use for MPLS packets where it cannot be
 	propagated from an IP header, either because one isn't present
 	or ip_ttl_propagate has been disabled.
-- 
2.19.2

