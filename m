Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738F867AB91
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 09:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjAYI0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 03:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbjAYIZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 03:25:57 -0500
X-Greylist: delayed 327 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Jan 2023 00:25:53 PST
Received: from mail.sven.de (paix.mosquito.net [37.187.101.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6519C4B899
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:25:53 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.sven.de (Postfix) with ESMTPSA id 8675BC00028;
        Wed, 25 Jan 2023 09:20:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sven.de; s=default;
        t=1674634823; bh=+xnvtTjmA8IexMUKL1l/rQ8Blcn3+OEampmzpiOpAJo=;
        h=Date:To:Cc:From:Subject;
        b=JHT/pYGPdsB8zjK3GWWqCPP6LxQHJw8CG3hxQqLzovxaaqArqKKcUdFH6Q0ZoAUGW
         OcfJ+EVZjTIstUwMPHuc/2cofIrdHSGvuKCZDrZD/CdBNTzf98ak403nsrERzrL4WE
         5OxvyipCi9Y3SnFpViUkMqH8M4B8iNyIKCjkngKk=
Message-ID: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
Date:   Wed, 25 Jan 2023 09:20:22 +0100
MIME-Version: 1.0
To:     netdev@vger.kernel.org
Cc:     sven-netdev@sven.de
From:   Sven Neuhaus <sven-netdev@sven.de>
Subject: [PATCH iproute2] ip-rule.8: Bring synopsis in line with description
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the option "priority" (with the aliases "preference" or "order") 
in the SYNOPSIS to be the same as under "DESCRIPTION".

diff --git a/man/man8/ip-rule.8 b/man/man8/ip-rule.8
index 2c12bf64..43820cf7 100644
--- a/man/man8/ip-rule.8
+++ b/man/man8/ip-rule.8
@@ -42,8 +42,8 @@ ip-rule \- routing policy database management
  .IR STRING " ] [ "
  .B  oif
  .IR STRING " ] [ "
-.B  pref
-.IR NUMBER " ] [ "
+.B  priority
+.IR PREFERENCE " ] [ "
  .IR l3mdev " ] [ "
  .B uidrange
  .IR NUMBER "-" NUMBER " ] [ "
