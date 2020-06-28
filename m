Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F220CB13
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 01:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgF1X0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 19:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgF1X0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 19:26:15 -0400
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9057C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 16:26:14 -0700 (PDT)
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id 05SNQCcO004245
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:26:13 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is 05SNQCcO004245
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id 05SNQCeu014922
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:26:12 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id 05SNQCKl014921
        for netdev@vger.kernel.org; Sun, 28 Jun 2020 23:26:12 GMT
Date:   Sun, 28 Jun 2020 23:26:12 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] devlink.8: Use a single-font macro for a single argument
Message-ID: <20200628232612.GA14888@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Use a single-font macro for a single argument

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man8/devlink.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 7f4eda56..866fda51 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -31,7 +31,7 @@ Read commands from provided file or standard input and invoke them.
 First failure will cause termination of devlink.
 
 .TP
-.BR "\-force"
+.B \-force
 Don't terminate devlink on errors in batch mode.
 If there were any errors during execution of the commands, the application return code will be non zero.
 
-- 
2.27.0
