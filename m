Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB18A66D051
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjAPUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjAPUlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:41:47 -0500
X-Greylist: delayed 159827 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 12:41:46 PST
Received: from packetdump.shellforce.org (packetdump.shellforce.org [5.45.100.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4932411A
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:41:45 -0800 (PST)
Received: from [10.42.100.2] (unknown [172.23.0.102])
        by packetdump.shellforce.org (Postfix) with ESMTP id 0CD0320774;
        Mon, 16 Jan 2023 21:41:44 +0100 (CET)
Message-ID: <e59c7cdf-9c54-00e3-bc9b-22fa471bd5ab@shellforce.org>
Date:   Mon, 16 Jan 2023 20:41:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Stefan Pietsch <stefan+linux@shellforce.org>
Subject: [RESEND PATCH iproute2] man: ip-link.8: Fix formatting
To:     netdev@vger.kernel.org
Content-Language: en-US
Cc:     stephen@networkplumber.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Stefan Pietsch <stefan+linux@shellforce.org>
---
 man/man8/ip-link.8.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 4956220b..ac33b438 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -301,6 +301,7 @@ Link types:
 .sp
 .B bond
 - Bonding device
+.sp
 .B bridge
 - Ethernet Bridge device
 .sp
-- 
2.39.0
