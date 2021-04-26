Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1484D36B35A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhDZMph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhDZMpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 08:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 176226109E;
        Mon, 26 Apr 2021 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619441091;
        bh=NE+xm+f+ZJ85P38dX7m6iAxgUXVguyX058JBJSO5kzU=;
        h=Date:From:To:Cc:Subject:From;
        b=ukAowdUM+xgdiBuKHs9WSOJQXpYd0eGm1XWXaDt+tU0pBfPATgHAaUPyrodw6lSKl
         4uOheMcLdJ0TJ/tVzm3PO30Qr/UnLyt/WLCQ/db2w+NarQiRTqenffumuxMkyURRmg
         UqjMPq0OSb89BnGxt/ZLrKC/IXCOK0eu1HgT4TWsT/jk7Cx8UbOYgC29tUw5egyjLk
         goxLXipQxIlAUkTTyFJnrdIC5EnY+Cx+wQoEdz+wbmoTOh4sgJcfQonwmGfMf/Zde8
         GobRxKE3GVnJPvopOz57tLb8DG7H+JWiYVIfTz1E+hLYMeeCkR+qfnfEH9cIkhchAk
         281u7dTSdTfew==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 92FD040647; Mon, 26 Apr 2021 09:44:47 -0300 (-03)
Date:   Mon, 26 Apr 2021 09:44:47 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Linux Networking Development Mailing List 
        <netdev@vger.kernel.org>
Subject: [PATCH 1/1] net: Fix typo in comment about ancillary data
Message-ID: <YIa1vyM7xuTKUqAL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ingo sent typo fixes for tools/ and this resulted in a warning when
building the perf/core branch that will be sent upstream in the next
merge window:

  Warning: Kernel ABI header at 'tools/perf/trace/beauty/include/linux/socket.h' differs from latest version at 'include/linux/socket.h'
  diff -u tools/perf/trace/beauty/include/linux/socket.h include/linux/socket.h

Fix the typo on the kernel file to address this.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/socket.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 385894b4a8bbac2c..b8fc5c53ba6fa755 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -85,7 +85,7 @@ struct mmsghdr {
 
 /*
  *	POSIX 1003.1g - ancillary data object information
- *	Ancillary data consits of a sequence of pairs of
+ *	Ancillary data consists of a sequence of pairs of
  *	(cmsghdr, cmsg_data[])
  */
 
-- 
2.26.2

