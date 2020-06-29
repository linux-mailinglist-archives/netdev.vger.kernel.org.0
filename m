Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBE20CB42
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 02:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgF2Amv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 20:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgF2Amu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 20:42:50 -0400
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6E2C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 17:42:50 -0700 (PDT)
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id 05T0gmON008068
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:42:48 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is 05T0gmON008068
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id 05T0gmCk018569
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:42:48 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id 05T0gm93018568
        for netdev@vger.kernel.org; Mon, 29 Jun 2020 00:42:48 GMT
Date:   Mon, 29 Jun 2020 00:42:48 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] devlint-health.8: use a single-font macro for a single
 argument
Message-ID: <20200629004248.GA18528@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Use a single font macro for a single argument.

  Remove unnecessary quotes for a single-font macro.

  Join two lines into one.

  The output of "nroff" and "groff" is unchanged.

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man8/devlink-health.8 | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/man/man8/devlink-health.8 b/man/man8/devlink-health.8
index 8a3c77be..215f549b 100644
--- a/man/man8/devlink-health.8
+++ b/man/man8/devlink-health.8
@@ -18,49 +18,47 @@ devlink-health \- devlink health reporting and recovery
 \fB\-V\fR[\fIersion\fR] }
 
 .ti -8
-.BR "devlink health show"
+.B devlink health show
 .RI "[ " DEV ""
 .B reporter
 .RI ""REPORTER " ] "
 
 .ti -8
-.BR "devlink health recover"
+.B devlink health recover
 .RI "" DEV ""
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
-.BR "devlink health diagnose"
+.B devlink health diagnose
 .RI "" DEV ""
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
-.BR "devlink health dump show"
+.B devlink health dump show
 .RI "" DEV ""
 .B  reporter
 .RI "" REPORTER ""
 
 .ti -8
-.BR "devlink health dump clear"
+.B devlink health dump clear
 .RI "" DEV ""
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
-.BR "devlink health set"
+.B devlink health set
 .RI "" DEV ""
 .B reporter
 .RI "" REPORTER ""
-.RI "[ "
+[
 .BI "grace_period " MSEC "
-.RI "]"
-.RI "[ "
+] [
 .BR auto_recover " { " true " | " false " } "
-.RI "]"
-.RI "[ "
+] [
 .BR auto_dump " { " true " | " false " } "
-.RI "]"
+]
 
 .ti -8
 .B devlink health help
-- 
2.27.0
