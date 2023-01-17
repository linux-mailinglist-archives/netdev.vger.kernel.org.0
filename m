Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11CC66E775
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjAQUJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjAQUID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:08:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A815AA64
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACA196152A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4745C433D2;
        Tue, 17 Jan 2023 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673982106;
        bh=UrPZTomHzTy0P4D5wdHC8Rbp5liOkhzEzSBvqd7gN9c=;
        h=From:To:Cc:Subject:Date:From;
        b=g9ObQSPOtRbouoWBvLapq/gHgRO4rHq7SyNro0Hq1psrIJqujaregY9lDrBvNMOjw
         N+1TLXNhPiT0w5vUSChscJnB3aqGAV9zWQhi83nRDX1vp9vgU+kdNPVpIogDlUCu7x
         DpSq4P7MUJfPb4qso2CX7U8/aUborEom9ult1HnNMYyvyQQ8qD601snl4QicOPc1FR
         DMxxCYCfqUVENAVqgebPLdbUNtwN8zWu2u7/MPBqrRRXguH+uPlvH+iBqc+K2q3EkT
         AcCOCc78q4go3DzXGYijpoOF5cYYZ+/EfmQygdcq0IG3wMKLNzDpuc3mV8u3DffKJb
         JesOtKYMJfDmQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add networking entries for Willem
Date:   Tue, 17 Jan 2023 11:01:41 -0800
Message-Id: <20230117190141.60795-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We often have to ping Willem asking for reviews of patches
because he doesn't get included in the CC list. Add MAINTAINERS
entries for some of the areas he covers so that ./scripts/ will
know to add him.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Please LMK if anyone would like to be added to these entries,
the maintainership is not meant to be exclusive.
---
 MAINTAINERS | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ba2e1feb83db..eae9095d2b07 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15756,6 +15756,12 @@ S:	Maintained
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/p54
 F:	drivers/net/wireless/intersil/p54/
 
+PACKET SOCKETS
+M:	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
+S:	Maintained
+F:	include/uapi/linux/if_packet.h
+F:	net/packet/af_packet.c
+
 PACKING
 M:	Vladimir Oltean <olteanv@gmail.com>
 L:	netdev@vger.kernel.org
@@ -19332,6 +19338,13 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Orphan
 F:	sound/soc/uniphier/
 
+SOCKET TIMESTAMPING
+M:	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
+S:	Maintained
+F:	Documentation/networking/timestamping.rst
+F:	include/uapi/linux/net_tstamp.h
+F:	tools/testing/selftests/net/so_txtime.c
+
 SOEKRIS NET48XX LED SUPPORT
 M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
@@ -21752,6 +21765,13 @@ T:	git git://linuxtv.org/media_tree.git
 F:	Documentation/admin-guide/media/zr364xx*
 F:	drivers/staging/media/deprecated/zr364xx/
 
+USER DATAGRAM PROTOCOL (UDP)
+M:	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
+S:	Maintained
+F:	include/linux/udp.h
+F:	net/ipv4/udp.c
+F:	net/ipv6/udp.c
+
 USER-MODE LINUX (UML)
 M:	Richard Weinberger <richard@nod.at>
 M:	Anton Ivanov <anton.ivanov@cambridgegreys.com>
-- 
2.39.0

