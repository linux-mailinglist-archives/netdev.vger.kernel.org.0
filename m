Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B18401132
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhIESps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:45:48 -0400
Received: from hmm.wantstofly.org ([213.239.204.108]:55336 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhIESpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 14:45:47 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Sep 2021 14:45:47 EDT
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 0B7057F5FC; Sun,  5 Sep 2021 21:37:00 +0300 (EEST)
Date:   Sun, 5 Sep 2021 21:37:00 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org,
        Pete Morici <pmorici@dev295.com>
Subject: [PATCH iproute2] man: ip-macsec: fix gcm-aes-256 formatting issue
Message-ID: <YTUOTGy8vaj45bBA@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ip link add' invocation template at the top of the ip-macsec man
page formats with a pair of extra double quotes:

   ip  link  add  link DEVICE name NAME type macsec [ [ address <lladdr> ]
   port PORT | sci <u64> ]  [  cipher  {  default  |  gcm-aes-128  |  gcm-
   aes-256"}][" icvlen ICVLEN ] [ encrypt { on | off } ] [ send_sci { on |

This is due to missing whitespace around the gcm-aes-256 identifier
in the source file.

Fixes: b16f525323357 ("Add support for configuring MACsec gcm-aes-256 cipher type.")
Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
 man/man8/ip-macsec.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 6739e51c..bb816157 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -10,7 +10,7 @@ ip-macsec \- MACsec device configuration
 |
 .BI sci " <u64>"
 ] [
-.BR cipher " { " default " | " gcm-aes-128 " | "gcm-aes-256" } ] ["
+.BR cipher " { " default " | " gcm-aes-128 " | " gcm-aes-256 " } ] ["
 .BI icvlen " ICVLEN"
 ] [
 .BR encrypt " { " on " | " off " } ] ["
-- 
2.31.1
