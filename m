Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4D495C01
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiAUIfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:35:05 -0500
Received: from vz-vol-pic.sui-inter.net ([80.74.145.88]:57966 "EHLO
        vz-vol-pic.sui-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379609AbiAUIe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:34:27 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2022 03:34:27 EST
Received: from [192.168.1.121] (localhost [127.0.0.1]) by vz-vol-pic.sui-inter.net (Postfix) with ESMTPSA id E2CCF3DA134A
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 09:27:05 +0100 (CET)
Authentication-Results: volta.metanet.ch;
        spf=pass (sender IP is 62.202.183.147) smtp.mailfrom=thomas@niederb.ch smtp.helo=[192.168.1.121]
Received-SPF: pass (volta.metanet.ch: connection is authenticated)
To:     netdev@vger.kernel.org
From:   Thomas Niederberger <thomas@niederb.ch>
Subject: [PATCH iproute2] Fix typo in optimistic flag
Message-ID: <42921e5f-7955-56c8-5a16-008967ae6ba7@niederb.ch>
Date:   Fri, 21 Jan 2022 09:27:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DC312879DD7FF8ABF46D7E31"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------DC312879DD7FF8ABF46D7E31
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi netdev-team

Attached you find a very small patch that fixes a typo in the man page 
of ip address.
Thanks for all your good work!

Cheers,
Thomas

--------------DC312879DD7FF8ABF46D7E31
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-man-Fix-a-typo-in-the-flag-documentation-of-ip-addre.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-man-Fix-a-typo-in-the-flag-documentation-of-ip-addre.pa";
 filename*1="tch"

From 9cae61cde6a5e07e8ae83f3eb9ecc25fd7de29d4 Mon Sep 17 00:00:00 2001
From: Thomas Niederberger <thomas@niederb.ch>
Date: Fri, 21 Jan 2022 09:05:02 +0100
Subject: [PATCH] man: Fix a typo in the flag documentation of ip address

Signed-off-by: Thomas Niederberger <thomas@niederb.ch>
---
 man/man8/ip-address.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 65f67e06..a614ac64 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -93,7 +93,7 @@ ip-address \- protocol address management
 
 .ti -8
 .IR CONFFLAG " := "
-.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimstic " | " noprefixroute " | " autojoin " ]"
+.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimistic " | " noprefixroute " | " autojoin " ]"
 
 .ti -8
 .IR LIFETIME " := [ "
-- 
2.25.1


--------------DC312879DD7FF8ABF46D7E31--
