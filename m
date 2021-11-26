Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE945E67F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357906AbhKZDYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232356AbhKZDWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFAD461059;
        Fri, 26 Nov 2021 03:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637896777;
        bh=7P4+MwEtkgPx8blO/Sa52+h7SYZwv9quy9/dFPUaO7A=;
        h=From:To:Cc:Subject:Date:From;
        b=WKi/GZd8ZfFMfgHIj8oRTOU8FtebBrB/pp8VJ0MaKesodsHokEKWahh2PgzmMVUmW
         KGMvqiOdSb9iQnGssADTObxqxZxLW/M2hii4wPk6OVWytiPR2iq/8H3PkxtJBnYOib
         +531bLG6b9fcKAXUGgvy72EnspHZqInIQRXKVsBGo7GrTShUBS1nb6FD6jeE5RzZDf
         ZVl3nDKCbANUZLIJ6fSr5TwNChcJyHqchnQLmGMmUdnRpdxlQdAzUSimkA6zuBOiWu
         sresmRbPOOrDp5QyXraWSAvvwH+mPK2lG5ykWqUf0nXJUGz9RBqf3CbUJl/8Dk1J5Z
         vyb4HPPr2hw1w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        richardcochran@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ptp: fix filter names in the documentation
Date:   Thu, 25 Nov 2021 19:19:21 -0800
Message-Id: <20211126031921.2466944-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the filter names are missing _PTP in them.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/timestamping.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index a722eb30e014..80b13353254a 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -486,8 +486,8 @@ of packets.
 Drivers are free to use a more permissive configuration than the requested
 configuration. It is expected that drivers should only implement directly the
 most generic mode that can be supported. For example if the hardware can
-support HWTSTAMP_FILTER_V2_EVENT, then it should generally always upscale
-HWTSTAMP_FILTER_V2_L2_SYNC_MESSAGE, and so forth, as HWTSTAMP_FILTER_V2_EVENT
+support HWTSTAMP_FILTER_PTP_V2_EVENT, then it should generally always upscale
+HWTSTAMP_FILTER_PTP_V2_L2_SYNC, and so forth, as HWTSTAMP_FILTER_PTP_V2_EVENT
 is more generic (and more useful to applications).
 
 A driver which supports hardware time stamping shall update the struct
-- 
2.31.1

