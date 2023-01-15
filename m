Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4448E66AEE3
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 01:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjAOAZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 19:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjAOAZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 19:25:32 -0500
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Jan 2023 16:25:32 PST
Received: from packetdump.shellforce.org (packetdump.ipv6.shellforce.org [IPv6:2a03:4000:6:125::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EBDA270
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 16:25:32 -0800 (PST)
Received: from [10.42.100.2] (unknown [172.23.0.102])
        by packetdump.shellforce.org (Postfix) with ESMTP id 8842A207C5;
        Sun, 15 Jan 2023 01:17:56 +0100 (CET)
Message-ID: <1488212e-7324-4f4a-d7d6-48ebd91a3936@shellforce.org>
Date:   Sun, 15 Jan 2023 00:17:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
From:   Stefan Pietsch <stefan+linux@shellforce.org>
Subject: [PATCH iproute2] man: ip-link.8: Fix formatting
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_05,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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


