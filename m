Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9ED4D295B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiCIHSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiCIHSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:35 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80764B63
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:33 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id q5so1730739ljb.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=LweIlgGI06DKFwjChhelSszMy23ZQQQAOUJlAf3eHT8=;
        b=pFW+eKFv2wetV4f1u2rHooMT59GSYKFG5dgmAeWiRt9QtKYRlzxwv5cwZI33Xxkew9
         8XLu5gX7mMq6j17yeMkP6/4c9hZG64bYFeW4MMnVtMkbwWUUiWnKAMeCiG0VHxG2d0Bn
         rTVQEY22IibTQkHDmnV3jlxLo5sZPNmvUQZPzcS2nqvg3vPLRjHy0AZtt/RJ5Ek1h8hU
         qomsTFXzif8w25UVLzeOWiAQvjH8/ckXeObTd7aGXh1rqSDMpGI4y282+s2zomOSDgTm
         Zr1b5qbeGc5X7VNAPQE9T4xRSpdYK6cCooH2gmznIiiOkv37W03Pq2cxZ9/qpPmBmImx
         tGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=LweIlgGI06DKFwjChhelSszMy23ZQQQAOUJlAf3eHT8=;
        b=lhgjIJF3OpJDaJCib3HERJ7YLo7ecCRoWdD9ikCj0Zc+ZOwCCVGN/Lpt9SPIGntMuo
         OB8vDAkFdcqFESi/tTVFxcqg9WbO95eM7h8ZMzalYdWZKyzbetVMkksHWcwzVEnJymoj
         mWkOgP8gM8inlmGY25YiDx4kV4VsqkYe7p+Srf+W+EosbmDT398589u9bJZnY3m8UQMj
         TaSBlm3YkIw919+CyLRsVPStHhjsOf+YkeCGRb1/9bA/Iv/WCEed9DGwvB6wXFCZG4Pu
         vsA3L88lEpjNrdttlTDGoV1Ty7kyF2Lhx6NJN9LcVmB9zIKruqFUx2TOM3y2Wzb2N0HV
         78DQ==
X-Gm-Message-State: AOAM531QyZqat6sQOmxR6tIYTOV8uwtGyVhiNECe/KInrluYlS+AWgnw
        vSPgEri/h/Cb9w/sWCBBPEayyP1iCt8KnA==
X-Google-Smtp-Source: ABdhPJyi5Crtj0+DugVkF1hJWzWPk9/qz4+rTB8mve2cKpYFxBMoam2AlaygZ9FUALySb2Ggs15G/A==
X-Received: by 2002:a05:651c:b10:b0:247:f37f:f595 with SMTP id b16-20020a05651c0b1000b00247f37ff595mr3848196ljr.444.1646810251385;
        Tue, 08 Mar 2022 23:17:31 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:30 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 6/6] man: ip-link: whitespace fixes to odd line breaks mid sentence
Date:   Wed,  9 Mar 2022 08:17:16 +0100
Message-Id: <20220309071716.2678952-7-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309071716.2678952-1-troglobit@gmail.com>
References: <20220309071716.2678952-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some options, spread across the man page, were accidentally (?) space
indented (possible bullet list auto-indent in editors), causing odd line
breaks in presentation mode (emacs, nroff, etc.).  This patch aligns the
multi-line descriptions to column zero, in line with other such option
descriptions.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/ip-link.8.in | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 11a02331..870e8c43 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -481,11 +481,11 @@ where <phy_dev> is the physical device to which VLAN device is bound.
 
 .BR gvrp " { " on " | " off " } "
 - specifies whether this VLAN should be registered using GARP VLAN
-  Registration Protocol.
+Registration Protocol.
 
 .BR mvrp " { " on " | " off " } "
 - specifies whether this VLAN should be registered using Multiple VLAN
-  Registration Protocol.
+Registration Protocol.
 
 .BR loose_binding " { " on " | " off " } "
 - specifies whether the VLAN device state is bound to the physical device state.
@@ -2189,9 +2189,9 @@ parameter must be specified.
 .sp
 .BI query_rss " on|off"
 - toggle the ability of querying the RSS configuration of a specific
-  VF. VF RSS information like RSS hash key may be considered sensitive
-  on some devices where this information is shared between VF and PF
-  and thus its querying may be prohibited by default.
+VF. VF RSS information like RSS hash key may be considered sensitive
+on some devices where this information is shared between VF and PF
+and thus its querying may be prohibited by default.
 .sp
 .BI state " auto|enable|disable"
 - set the virtual link state as seen by the specified VF. Setting to
@@ -2454,7 +2454,7 @@ option above.
 
 .BR mcast_flood " { " on " | " off " }"
 - controls whether a given port will flood multicast traffic for which
-  there is no MDB entry. By default this flag is on.
+there is no MDB entry. By default this flag is on.
 
 .BR bcast_flood " { " on " | " off " }"
 - controls flooding of broadcast traffic on the given port. By default
@@ -2462,7 +2462,7 @@ this flag is on.
 
 .BR mcast_to_unicast " { " on " | " off " }"
 - controls whether a given port will replicate packets using unicast
-  instead of multicast. By default this flag is off.
+instead of multicast. By default this flag is off.
 
 .BI group_fwd_mask " MASK "
 - set the group forward mask. This is the bitmask that is applied to
-- 
2.25.1

