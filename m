Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E636920CB22
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgF1X6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 19:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgF1X6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 19:58:42 -0400
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBBEC03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 16:58:42 -0700 (PDT)
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id 05SNwesk005710
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:58:40 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is 05SNwesk005710
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id 05SNwelZ016379
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:58:40 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id 05SNwe5R016378
        for netdev@vger.kernel.org; Sun, 28 Jun 2020 23:58:40 GMT
Date:   Sun, 28 Jun 2020 23:58:40 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] devlink-dev.8: use a single-font macro for one argument
Message-ID: <20200628235840.GA16308@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Use a single-font macro for one argument.

  Remove unnecessary quotes for a single font macro.

  Join some lines into one.

  The output of "nroff" and "groff" is unchanged, except for a font
change in two lines.

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man8/devlink-dev.8 | 89 +++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index ac01bf60..279100c3 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -26,61 +26,60 @@ devlink-dev \- devlink device configuration
 .B devlink dev help
 
 .ti -8
-.BR "devlink dev eswitch set"
-.IR DEV
-.RI "[ "
+.B devlink dev eswitch set
+.I DEV
+[
 .BR mode " { " legacy " | " switchdev " } "
-.RI "]"
-.RI "[ "
+] [
 .BR inline-mode " { " none " | " link " | " network " | " transport " } "
-.RI "]"
-.RI "[ "
+] [
 .BR encap-mode " { " none " | " basic " } "
-.RI "]"
+]
 
 .ti -8
-.BR "devlink dev eswitch show"
-.IR DEV
+.B devlink dev eswitch show
+.I DEV
 
 .ti -8
-.BR "devlink dev param set"
-.IR DEV
-.BR name
-.IR PARAMETER
-.BR value
-.IR VALUE
+.B devlink dev param set
+.I DEV
+.B name
+.I PARAMETER
+.B value
+.I VALUE
 .BR cmode " { " runtime " | " driverinit " | " permanent " } "
 
 .ti -8
-.BR "devlink dev param show"
-.RI "[ "
-.IR DEV
-.BR name
-.IR PARAMETER
-.RI "]"
+.B devlink dev param show
+[
+.I DEV
+.B name
+.I PARAMETER
+]
 
 .ti -8
-.BR "devlink dev reload"
-.IR DEV
-.RI "[ "
-.BI "netns { " PID " | " NAME " | " ID " }
-.RI "]"
+.B devlink dev reload
+.I DEV
+[
+.B netns
+.RI "{ " PID " | " NAME " | " ID " }"
+]
 
 .ti -8
-.BR "devlink dev info"
-.RI "[ "
-.IR DEV
-.RI "]"
+.B devlink dev info
+[
+.I DEV
+]
 
 .ti -8
-.BR "devlink dev flash"
-.IR DEV
-.BR file
-.IR PATH
-.RI "["
-.BR target
-.IR ID
-.RI "]"
+.B devlink dev flash
+.I DEV
+.B file
+.I PATH
+[
+.B target
+.I ID
+]
 
 .SH "DESCRIPTION"
 .SS devlink dev show - display devlink device attributes
@@ -159,8 +158,8 @@ Configuration mode in which the new value is set.
 
 .SS devlink dev param show - display devlink device supported configuration parameters attributes
 
-.BR name
-.IR PARAMETER
+.B name
+.I PARAMETER
 Specify parameter name to show.
 If this argument is omitted all parameters supported by devlink devices are listed.
 
@@ -170,8 +169,8 @@ If this argument is omitted all parameters supported by devlink devices are list
 .I "DEV"
 - Specifies the devlink device to reload.
 
-.BR netns
-.BI { " PID " | " NAME " | " ID " }
+.B netns
+.RI { " PID " | " NAME " | " ID " }
 - Specifies the network namespace to reload into, either by pid, name or id.
 
 .SS devlink dev info - display device information.
@@ -200,13 +199,13 @@ If this argument is omitted all devices are listed.
 .I "DEV"
 - specifies the devlink device to write to.
 
-.BR file
+.B file
 .I PATH
 - Path to the file which will be written into device's flash. The path needs
 to be relative to one of the directories searched by the kernel firmware loaded,
 such as /lib/firmware.
 
-.BR component
+.B component
 .I NAME
 - If device stores multiple firmware images in non-volatile memory, this
 parameter may be used to indicate which firmware image should be written.
-- 
2.27.0
