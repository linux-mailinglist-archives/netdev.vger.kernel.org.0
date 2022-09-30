Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32835F12EF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiI3ToQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiI3ToP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:44:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDB617B50E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:44:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id jo24so4255895plb.13
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WQBhlPWYsN3wB5rSUpwV3Ex8lv9E3GKUvio9xVRzOZs=;
        b=vyxcvDVRrp5JUj16dNzi0kt/IqVk62wtJ4sjd1hxnVVpodtq8mm7Nh6nwgJgAt3US4
         PSvi2wPZsT6Wgo0M6HkT5Nzaxys/0kvcbIfn+E7+uDEsEaPzfvmep3to/M/dpLWLxdHw
         cQ/3GtEwI/3gjz8+XMKetGnB9fslLp1/93BjDNMRoufQJ3OWa8WGOfkZwCAh11YVauug
         PCuVR6NzDUyF484XhLNWqf0cJc3mbE4y5RXfz/gHf0XkL6kzDfo7XF3AKYy48cxqG2ib
         YJcVKvc6Z2aPGtZAo5jDkzFFtdKBPrZCznXEry4dzTOuDNmsxt69y/n0KHzsk4GCmSGw
         7vCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WQBhlPWYsN3wB5rSUpwV3Ex8lv9E3GKUvio9xVRzOZs=;
        b=GgoEN2Be4wvBBGWUhZVLDtUiX6gtiJ0TP6BtJSig4FnPjCiUpUnBZhj25glIiftzl3
         sZ3lx6WlNqRySiOQBWxsQHntN8a+RCzggO25nBJCz/jlrsVRWvL0q1CfPs4pfLdEdvvT
         xO2/TZCf5slvqKxa2gEUe68JyaJLX4zuiLWx06bVB2p/5Ga2CLg6mdTTN1WMmBFGrh6e
         /bAdjXWuiMcQB2DHUxCxukeaAfIdW2hhDx+trycMCbFqJjTnwK9R6kj9wP2oPmV0JeE2
         fTlyhzw+p4eamOt/L2aTWTBmw9crdONSsfbesOX5oFY133KjLkWzooE/Z9ut4gb1dwa7
         eSQA==
X-Gm-Message-State: ACrzQf20RxO/LiByofBaWjbxyrwd/HN16rZlLaxeUXRSaUpzAFGouvbn
        fscCaPW4lc2Vi06QXASZTp3O5eLYYQyWpw==
X-Google-Smtp-Source: AMsMyM7kCVU8VdqbbEq1eA4ZuylzjtdrsYYAN9XYMvkgboAOv0FE98stWOsPkfX5JozbG5YEkzHHow==
X-Received: by 2002:a17:902:d4d2:b0:178:491b:40d with SMTP id o18-20020a170902d4d200b00178491b040dmr10536973plg.79.1664567053373;
        Fri, 30 Sep 2022 12:44:13 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id i17-20020a170902cf1100b00177e5d83d3esm2276821plg.88.2022.09.30.12.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:44:13 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     jiri@nividia.com, Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] devlink: fix man page for linecard
Date:   Fri, 30 Sep 2022 12:44:11 -0700
Message-Id: <20220930194411.73209-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing make check on iproute2 runs several checks including man page
checks for common errors. Recent addition of linecard support to
devlink introduced this error.

Checking manpages for syntax errors...
an-old.tmac: <standard input>: line 31: 'R' is a string (producing the registered sign), not a macro.
Error in devlink-lc.8

Fixes: 4cb0bec3744a ("devlink: add support for linecard show and type set")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/devlink-lc.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink-lc.8 b/man/man8/devlink-lc.8
index 1661b9bd6917..b588cbc0020f 100644
--- a/man/man8/devlink-lc.8
+++ b/man/man8/devlink-lc.8
@@ -28,7 +28,7 @@ devlink-lc \- devlink line card configuration
 .B "devlink lc show"
 .RI "[ " DEV " [ "
 .BI lc " LC_INDEX
-.R  " ] ]"
+] ]
 
 .ti -8
 .B devlink lc help
-- 
2.35.1

