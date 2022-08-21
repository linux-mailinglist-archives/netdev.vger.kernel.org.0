Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8B259B67B
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 23:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiHUVsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 17:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiHUVsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 17:48:13 -0400
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Aug 2022 14:48:09 PDT
Received: from mail.citrus-it.net (mail.citrus-it.net [89.248.55.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB091EEF5
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 14:48:09 -0700 (PDT)
Authentication-Results: citrusmail; dkim=pass header.i=@ovsienko.info
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ovsienko.info;
        s=2022-04-13; t=1661117957;
        bh=gwUeQW8rDMg0CCiXtd1fGrqirtZM8Zfr5AxSn4uWPEQ=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=Odvp6m2Rwngzf2iUgvliqPhnWZt87adFU7iMgRS0KCGpJxO2OLgl1cK+PAJWnZM3f
         P/lAClvEF0DvY/yrQYS7ecpuZJe1l3wyGQf7JxGHG7F1jKPSt36TzHbh/HVk5GszKA
         nlj+d14ikJ0bUTp6wZu1hPc6i5YgFImZce62iaf8JTKj3WLSzEix3GUKvvCXEJ9/TP
         BFNLRbrkwLJy06NPLdN43QD0IUY0dRF4h0aAXtVSQ3cOVYitHqxS1LVOcwLcLCL4A1
         Q4vaFT2ujyxShpycD1bCjNdd0kcZKwuNE8YZPrXraiK8O6WIXlNhvJHhZd2ZUqoKom
         sdei+oKKhdLzA==
Received: from mail.citrus-it.net (mail.citrus-it.net [89.248.55.111])
        by mail.citrus-it.net with ESMTP id 27LLdHjL004157
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:39:17 GMT
X-Citrus-Remote-IP: 129.151.73.121
Date:   Sun, 21 Aug 2022 22:39:12 +0100
From:   Denis Ovsienko <denis@ovsienko.info>
To:     netdev@vger.kernel.org
Subject: [PATCH] man: fix a typo in devlink-dev(8)
Message-ID: <20220821223912.6651714c@mobilepc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Citrus-Version: 6.0.3ba253c
X-Citrus-ID: 427LLdHjL004157
X-Citrus-Spam: Whitelisted
X-Citrus-Trust: Trusted
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=46rom fa2bc8d1cdc77fb06109d7ff14e9baf69e28869a Mon Sep 17 00:00:00 2001
From: Denis Ovsienko <denis@ovsienko.info>
Date: Sun, 21 Aug 2022 22:32:57 +0100
Subject: [PATCH] man: fix a typo in devlink-dev(8)

Signed-off-by: Denis Ovsienko <denis@ovsienko.info>
---
 man/man8/devlink-dev.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 2a776416..e9d091df 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -250,7 +250,7 @@ If this argument is omitted all devices are listed.
 .B file
 .I PATH
 - Path to the file which will be written into device's flash. The path nee=
ds
-to be relative to one of the directories searched by the kernel firmware l=
oaded,
+to be relative to one of the directories searched by the kernel firmware l=
oader,
 such as /lib/firmware.
=20
 .B component
--=20
2.34.1

