Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049954D3A34
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiCITZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237865AbiCITY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:59 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401BB11A18
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:44 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id w12so5535558lfr.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=UthmHaaVxco4V0h/OoLn4yD1U0+Z55/3wlWJmfcNf3A=;
        b=pTJhqBUwRcCZyOxDkckNERhTRNpoD5L6qCyqCBR88TAYh64yvIj1zUTwDYBr2xKa4G
         17B3OuJV9miLxSnVSKFFmKoxTsHSrTXZspZSsPTf1a/O6NDhybr3s4ZsNbnrSYXwQFw1
         x73tcRNKMafPoUuLv0EvlcP/wcJ/C5F0NJJcF06O6e7gL65C/tfsvumS9tW7gHvZdECs
         v+nCdvDgRy4RVBPDyndEHPO88NW8Ax3GGEMUiVivXTge+qql+tK7ZQm+xyRJ15m5o4ke
         vZHz6x75ddze3162j++V/fo+kwDlWSsDSBzzaIhflFrS8r+T1VLbfJeIM8hMvcUuSnZL
         UfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=UthmHaaVxco4V0h/OoLn4yD1U0+Z55/3wlWJmfcNf3A=;
        b=OYikzbHLRVfYV6p8b9JvgepNvLaNGMP6uQosQBaMqSu+Z/nt+oICF24ZOYVyD1iUK1
         kon5650VrP0PuewgCKkwCpIkf7WtBh8JqhIEh9a0PGNyKz2N7W21JdUr/SD5jbxCI/SB
         U+CsIEoXIChNYak75m7FzKhIrKTwLaybhHFWRuAw3HHVw/HQfgzn72rXWvrGaX0+wRfy
         7YHeIxici4/7/PYOn1cZ/QTdzQK33ik6DM/QFHY8bo4ejLvx+dipUJ81fulLA/7gZ+tl
         uTyc0eLLDnYxPjq1kLS0MaQK+BmIUdrPehQaYLI+34vc/xh3Wrb0xWeUMeytGsXs97ne
         1yHg==
X-Gm-Message-State: AOAM530zydq/8LsJmdA6lttOPtWNL7r1TTIsoFHXow+e7DmABU3FY1Hg
        OZoHP+RNmG5w+Rgmcn+LVxzT/mLohEwn8Q==
X-Google-Smtp-Source: ABdhPJwadzvbEyiRPAiSyCuwILkX8LOVhCLZLOw0f9rsB/t+5ljbHsk06Bi+t+34cIC7Z2NpH9/MOw==
X-Received: by 2002:a05:6512:3f05:b0:443:bf88:aeba with SMTP id y5-20020a0565123f0500b00443bf88aebamr676400lfa.561.1646853821962;
        Wed, 09 Mar 2022 11:23:41 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:41 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 7/7] man: ip-link: whitespace fixes to odd line breaks mid sentence
Date:   Wed,  9 Mar 2022 20:23:16 +0100
Message-Id: <20220309192316.2918792-8-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
References: <20220309192316.2918792-1-troglobit@gmail.com>
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
index 1237ff4c..c142d80a 100644
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
@@ -2458,11 +2458,11 @@ this flag is on.
 
 .BR mcast_flood " { " on " | " off " }"
 - controls whether a given port will flood multicast traffic for which
-  there is no MDB entry. By default this flag is on.
+there is no MDB entry. By default this flag is on.
 
 .BR mcast_to_unicast " { " on " | " off " }"
 - controls whether a given port will replicate packets using unicast
-  instead of multicast. By default this flag is off.
+instead of multicast. By default this flag is off.
 
 .BI group_fwd_mask " MASK "
 - set the group forward mask. This is the bitmask that is applied to
-- 
2.25.1

