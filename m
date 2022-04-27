Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B1251210B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiD0Q1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243392AbiD0Q1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:27:01 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053E03153E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:21:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v10so1819640pgl.11
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kxJFwDAnb/shdeBAyOf4aMKQjxm2b1fMnfFFvKBGDbk=;
        b=cUyRxXRoUD4XRcPG+s0AztlsfMV1a0y3I6P5vGReix3eGRVA5hIfZMqrIdHL9RGO68
         tMnIyw9/u635JfVVSi+nRO+IXfh7P1u+NnNWCno4tJBPcmNql4jYMnCrw2x19qDLhQBb
         0m83yhQstl71uX1DhNFVmpiW07GI9UoEVa3f4l2zbakEzRY/HyI4Y8u24HU5lFxa8dVr
         JhSavtitPGw+oGcqn/vKEMAWWaNJxbOWe0uVTrXLaZVmcFWS75xiAfpNM7k0vucjK8yT
         c2gZ3c4wd6rNudnbzteeSR5AelBkOkSQnz6kCmNouXvLnUx1l619eFzS57VENb93BUbE
         rjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kxJFwDAnb/shdeBAyOf4aMKQjxm2b1fMnfFFvKBGDbk=;
        b=1nMVHgDd2hTRtNq901C43zv9OiXFt0TBYwfQXC15V8d2s7i8FyRglEvN7l35Y+wc8X
         o2eHbzrln5sgvkM+1788VSs/E9nRlRyf3mRRNunMhubbjT1KFR5uBNKoOFtThKhl7Mjx
         1uO905ItflT+l/pkjGV/tWyNah4pLzgr5/hKFNruvFZV858l2JG88l8F3U2jW5WU6wGW
         6yHNAzf6QVCKP9mIzKvy99aiaZldRyO45LUpiuBt0mhqbNIWPZ0J5eHSldMd+MpfDuAi
         kg10up5IpLn2lWgp8zI8oUw7nS8JmCroINTx5wSQYStsfXRHpFQjyivH9IQo+wFYe4Re
         /jTA==
X-Gm-Message-State: AOAM531NZmFgi4LaJ08SFML/QSwlfbHTsOgCyweVEyzq5eO4F8sQu9mA
        FBGkOk675fO5BlpA1pB5M9W7+wPjfEM=
X-Google-Smtp-Source: ABdhPJxgLFUESv9rB3/dIcDVLf1tAdI7cKcuvr9nlkOGa01BRClI8hSMbz8W0yERNZy0WyaOKOdaNg==
X-Received: by 2002:a05:6a00:140e:b0:4e1:c81a:625c with SMTP id l14-20020a056a00140e00b004e1c81a625cmr30750757pfu.39.1651076508987;
        Wed, 27 Apr 2022 09:21:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u26-20020a63471a000000b003aa1ad643bdsm16662386pga.47.2022.04.27.09.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:21:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     michael.chan@broadcom.com, zajec5@gmail.com, andy@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] MAINTAINERS: Update BNXT entry with firmware files
Date:   Wed, 27 Apr 2022 09:21:45 -0700
Message-Id: <20220427162145.121370-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There appears to be a maintainer gap for BNXT TEE firmware files which
causes some patches to be missed. Update the entry for the BNXT Ethernet
controller with its companion firmware files.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f585242da63d..0316d0c9a908 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3927,7 +3927,9 @@ BROADCOM BNXT_EN 50 GIGABIT ETHERNET DRIVER
 M:	Michael Chan <michael.chan@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/firmware/broadcom/tee_bnxt_fw.c
 F:	drivers/net/ethernet/broadcom/bnxt/
+F:	linux/firmware/broadcom/tee_bnxt_fw.h
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Arend van Spriel <aspriel@gmail.com>
-- 
2.25.1

