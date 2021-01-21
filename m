Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C512FEE01
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbhAUPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732309AbhAUPDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 10:03:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4257C238E3;
        Thu, 21 Jan 2021 15:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611241379;
        bh=no3I8p0qoKwfhqpyoqJiTHHRrUZ0jwr0iqDdTjZ2Kr8=;
        h=From:To:Cc:Subject:Date:From;
        b=lmEbVA49iS9V8KAQ9htAKiTkqtJmXnsCsxSUaFx5dxDqze4fRpAFlFp/qa0RpboUJ
         TWPrhaTPbqJRJSR7yRGhUs7/yu0iM0vGmrupJMCrzdA8/YCiQcuKXcD328Qo8Y1nOt
         fwdsY7uCS0Q+/1hM2bs9wz8Ndwy3jNqN5razESuUvXFD+UehZ7NLL/5rOlWispakqt
         jJUc8AzlWqHF6XYVx+derfPsrJolduQWfiHZltSMpMW/+hJlxiqP6ez0BCJE/A0JKD
         935i7voEuztO0uPywAMeKANjoTPjiR/SjVMkXTuLtmrkSYcJV4yMb8j+s9ildmpcTJ
         RfP8MeWlhdvgg==
Received: by pali.im (Postfix)
        id 08114774; Thu, 21 Jan 2021 16:02:56 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] doc: networking: ip-sysctl: Document conf/all/disable_ipv6 and conf/default/disable_ipv6
Date:   Thu, 21 Jan 2021 16:02:44 +0100
Message-Id: <20210121150244.20483-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds documentation for sysctl conf/all/disable_ipv6 and
conf/default/disable_ipv6 settings which is currently missing.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..c7b775da9554 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1807,12 +1807,24 @@ seg6_flowlabel - INTEGER
 ``conf/default/*``:
 	Change the interface-specific default settings.
 
+	These settings would be used during creating new interfaces.
+
 
 ``conf/all/*``:
 	Change all the interface-specific settings.
 
 	[XXX:  Other special features than forwarding?]
 
+conf/all/disable_ipv6 - BOOLEAN
+	Changing this value is same as changing ``conf/default/disable_ipv6``
+	setting and also all per-interface ``disable_ipv6`` settings to the same
+	value.
+
+	Reading this value does not have any particular meaning. It does not say
+	whether IPv6 support is enabled or disabled. Returned value can be 1
+	also in the case when some interface has ``disable_ipv6`` set to 0 and
+	has configured IPv6 addresses.
+
 conf/all/forwarding - BOOLEAN
 	Enable global IPv6 forwarding between all interfaces.
 
-- 
2.20.1

