Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C724BE561
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiBURCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:02:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiBURBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:01:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEABB2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:01:30 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so5592226pjj.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=t5qkLERN8RmnZXnJDpbX4L9+MArkJkNBAVtfLHqiaLQ=;
        b=jEy3j24PP96iHPAE6pLgb4Z0MOj8bQPEPqKGf204ASZa3o6FRz3SAJbH0mlboHmA/2
         2VMauptRh8HOZ4t9V8V8YLNZJqy4lck1aPUWSugWao8RqXgfiS0LXn8YBQfxF+tshLg1
         KC6sL6Potuwu5h4CSeXiMgboeOAMynkmFCzBP28evIcu3PwH+mCvqB6ZRHX5h8ihLwCV
         tDnpDaGruhof8sM6d1L9wfbqTIPXG6seg2zk7VJq1CK7VnIC9IwnfqOSW6UNwOncq/Uy
         T53XAUElSFG6Nf1/DPs2tfFyvUNPfgK0rWllTyRQXEce2o+jj0AdNKtbTwvgCq6bKIqI
         ZJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=t5qkLERN8RmnZXnJDpbX4L9+MArkJkNBAVtfLHqiaLQ=;
        b=xGQTQq0noRNoLrOoXn9aZr74r8/SHTh40BmZIm72d+cLzzpsSDezU8sFRsYvQXQQli
         UbtJTsX9xNs+/qDggVzEWkog5XP2Ru8JXotch/1OefmOA4DCJ30bJEPIYMA5XkpmNZBO
         YZc0BRx1tkAEfa2x8/Hqkdx/bb63T2Bh+yp0fZxRs97Alcw5lHLVyJJMPtEvky31gXli
         x00defdmO5cGY1EFLmiinQaJf6pMZFtIiw9qwLqUJjCwug0wd9BKYBqjexLRvzVVFydy
         ulVi5IiIY9iTgy/meemCg4wfvmFS/sbWW3dWvQwCKf+66cyoo9u2yjVCby+ogxYQLWJM
         nnBw==
X-Gm-Message-State: AOAM532SBNLewFWaq2Rp3DI4j9WDmui71t0Xv39RXdYrA0ESk9GA67md
        T0Z9H/2uSK8CIWVk8qkg8AGQPRSwIhZkj2Ey
X-Google-Smtp-Source: ABdhPJw68eNpeX6Ej5FVNC1IXBel3pfyZwuS4re+tl1v1R2iJSBKLtkwcXxcYPqUYc6W6Ea6GKmFrw==
X-Received: by 2002:a17:902:ec83:b0:14f:ba2b:990c with SMTP id x3-20020a170902ec8300b0014fba2b990cmr5618399plg.119.1645462888054;
        Mon, 21 Feb 2022 09:01:28 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id n13sm8076815pjq.13.2022.02.21.09.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 09:01:27 -0800 (PST)
Date:   Mon, 21 Feb 2022 09:01:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 215627] New: Failed to load firmware for bnx2 / Broadcom
 BCM57810  NetXtreme II 10 Gigabit Ethernet
Message-ID: <20220221090124.0a14ad40@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 21 Feb 2022 09:57:09 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215627] New: Failed to load firmware for bnx2 / Broadcom BCM57810  NetXtreme II 10 Gigabit Ethernet


https://bugzilla.kernel.org/show_bug.cgi?id=215627

            Bug ID: 215627
           Summary: Failed to load firmware for bnx2 / Broadcom BCM57810
                    NetXtreme II 10 Gigabit Ethernet
           Product: Networking
           Version: 2.5
    Kernel Version: 5.16.7-2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ivailo.at@gmail.com
        Regression: No

Hi all,

Since kernel was updated to 5.16 version (Debian bookworm (testing)), there is
a problem with Ethernet controller. Failed to load bnx2x firmware.

________________________________________________________________________

lcpci:

bd:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme II
BCM57810 10 Gigabit Ethernet (rev 10)
bd:00.1 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme II
BCM57810 10 Gigabit Ethernet (rev 10)

________________________________________________________________________

dmesg output:

[    1.555781] bnx2x 0000:bd:00.0: firmware: failed to load
bnx2x/bnx2x-e2-7.13.21.0.fw (-2)
[    1.555904] bnx2x 0000:bd:00.0: Direct firmware load for
bnx2x/bnx2x-e2-7.13.21.0.fw failed with error -2
[    1.555912] bnx2x 0000:bd:00.0: firmware: failed to load
bnx2x/bnx2x-e2-7.13.15.0.fw (-2)
[    1.555971] bnx2x 0000:bd:00.0: Direct firmware load for
bnx2x/bnx2x-e2-7.13.15.0.fw failed with error -2
[    1.556091] bnx2x: probe of 0000:bd:00.0 failed with error -2


[    1.556115] bnx2x 0000:bd:00.1: msix capability found
[    1.556288] bnx2x 0000:bd:00.1: part number 0-0-0-0
[    1.604171] bnx2x 0000:bd:00.1: firmware: failed to load
bnx2x/bnx2x-e2-7.13.21.0.fw (-2)
[    1.604242] bnx2x 0000:bd:00.1: Direct firmware load for
bnx2x/bnx2x-e2-7.13.21.0.fw failed with error -2
[    1.604259] bnx2x 0000:bd:00.1: firmware: failed to load
bnx2x/bnx2x-e2-7.13.15.0.fw (-2)
[    1.604327] bnx2x 0000:bd:00.1: Direct firmware load for
bnx2x/bnx2x-e2-7.13.15.0.fw failed with error -2
[    1.604491] bnx2x: probe of 0000:bd:00.1 failed with error -2
______________________________________________________________________

Kernel: linux-image-5.16.0-1-amd64  5.16.7-2  

firmware-bnx2x: 20210818-1  all  Binary firmware for Broadcom NetXtreme II 10Gb
_______________________________________________________________________

Thank you!

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
