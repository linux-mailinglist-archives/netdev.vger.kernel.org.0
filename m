Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9552C507F20
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348230AbiDTC4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiDTC4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:56:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E909A35DFD
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:54:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so3719402pjb.2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=joW4E1DvY2ZDaPO9F2hhaKB7krtMJP5lrijMxwNZx/0=;
        b=BDflj+4tZSgvh6oXEd03Jy13Hi6i9qev0o4zLWFcmBraWQzv3slhOd6FBHEkYinJp3
         bDOCspCj+WIrThNsWuFI4AvES8CL59eHyY/RnBjyJXmNMUOBFc3DPjjgzdg3yvLWRQ0P
         bcuk2gzZVdPlr6g14Yi1NnEKe4vXS9XKtLJwfVCrdjAHn/QWLRVo/ZChljZBTzl3oEF7
         tzMVlIErDme52Ro+CTjWP0zTH6YJqkFXzD+rgwOLEyZHZG2u4piwD8R8DywERa/Cip/t
         6+HofYtuZsAvpOq/7u47JpeQLRavubvmGWzboFB88Mw1EsbUiXz661ETUk1HUFKUPFi5
         cadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=joW4E1DvY2ZDaPO9F2hhaKB7krtMJP5lrijMxwNZx/0=;
        b=v8xZrHAr7/F9/UqqgeXMgvy+dfkF3Tz9zHD/Uw3OxI/BkzvFpK8IKCepL5xtIwUrHq
         h48OcIm+oOeHIGZnZnMyKXl5xAa2zVDBqQHCW2iRjF/aBjBpxoByEEkWY2iKhQuNg0q+
         7gCtAyi34OGsQFdELa4TsYSfpl7Rzbn08o6SSATX7EdJT3ZECfPGOtBwrYbSr5IUg8Ya
         aWQqSPu5XTmU5DOkBClZaaOPx1awaPeXdyUtu4VTtXU3br35J1XxNbRngQ5NCT0g9jF6
         /97KjLjtNe/mgibG8XZtvewA6bfnzIFuUpZyN6fYcOnJ9gacTEtclcGZ9Y7yjdPyvqEA
         yv5Q==
X-Gm-Message-State: AOAM532tA9FNhTMfzawnOVZuOSXy2uBFVWXephRTa4xinPg/6jshXpO4
        PGDdq+ZQ+bqfNBmXePnXWF45E+dYz+/sDg==
X-Google-Smtp-Source: ABdhPJxUpDmL/U1pQZA3hSndCGKDmBRp/g/RFwK78bd7R96hqhNcLUq4NnFY90gY4TCEGBi/4a5APw==
X-Received: by 2002:a17:902:7d86:b0:156:434a:a901 with SMTP id a6-20020a1709027d8600b00156434aa901mr19000083plm.77.1650423244144;
        Tue, 19 Apr 2022 19:54:04 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm18561268pfh.83.2022.04.19.19.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 19:54:03 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] ip-link: put types on man page in alphabetic order
Date:   Tue, 19 Apr 2022 19:54:01 -0700
Message-Id: <20220420025401.25664-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lets try and keep man pages using alpha order, it looks like
it started that way then drifted.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in | 48 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index ec3cc4297da5..477e5ae24772 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -209,43 +209,43 @@ ip-link \- network device configuration
 .ti -8
 .IR TYPE " := [ "
 .BR amt " | "
-.BR bridge " | "
+.BR bareudp " |"
 .BR bond " | "
+.BR bridge " | "
 .BR can " | "
 .BR dummy " | "
-.BR hsr " | "
-.BR ifb " | "
-.BR ipoib " |"
-.BR macvlan  " | "
-.BR macvtap  " | "
-.BR vcan " | "
-.BR vxcan " | "
-.BR veth " | "
-.BR vlan " | "
-.BR vxlan " |"
-.BR ip6tnl " |"
-.BR ipip " |"
-.BR sit " |"
+.BR erspan " |"
+.BR geneve " |"
 .BR gre " |"
 .BR gretap " |"
-.BR erspan " |"
+.BR gtp " |"
+.BR hsr " | "
+.BR ifb " | "
+.BR ip6erspan " |"
 .BR ip6gre " |"
 .BR ip6gretap " |"
-.BR ip6erspan " |"
-.BR vti " |"
-.BR nlmon " |"
+.BR ip6tnl " |"
+.BR ipip " |"
+.BR ipoib " |"
 .BR ipvlan " |"
 .BR ipvtap " |"
 .BR lowpan " |"
-.BR geneve " |"
-.BR bareudp " |"
-.BR vrf " |"
 .BR macsec " |"
+.BR macvlan  " | "
+.BR macvtap  " | "
 .BR netdevsim " |"
+.BR nlmon " |"
 .BR rmnet " |"
-.BR xfrm " |"
-.BR gtp " |"
-.BR virt_wifi " ]"
+.BR sit " |"
+.BR vcan " | "
+.BR veth " | "
+.BR virt_wifi " |"
+.BR vlan " | "
+.BR vrf " |"
+.BR vti " |"
+.BR vxcan " | "
+.BR vxlan " |"
+.BR xfrm " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
-- 
2.35.1

