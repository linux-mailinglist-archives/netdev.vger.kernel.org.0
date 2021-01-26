Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56153055F4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316908AbhAZXMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405814AbhAZUzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:55:37 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B6AC061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 12:54:57 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h15so7962415pli.8
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 12:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Mu9tN6AsBt6hm5TaGfWVwOd2skOhyaD6lKELefiqJLc=;
        b=m9FSaiY+0VTgOU2Mmq+8oaNSr/lZjeurXQ52fFeMk4qb1BitDkXKxuVRueY8ETyt/B
         wW/z33p6HAvZ97wp04+ZW6Gbjo1qAq6uQfW2wsVf/HPjcOm7KgNV4otWqVqIR0cA44T9
         n/+wIp9mQKVedAVY0eNu7CFHmRYYQT4PBi0A7KuWoXJLqttNbKX4J90+5HdLfWunoxNi
         YRJwOzUBx2NWw6Nje6VwgY8/hFCLDPTphnnolnXkaNpWWDXRhN13TSl+rQJqY4y98ZMy
         dXRqltO334ukS+n6AEg5IzeDZ6XkZYsKtGiSSlDOHLGLk5gD9bhyT4651wN8QySRCCCO
         5YBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Mu9tN6AsBt6hm5TaGfWVwOd2skOhyaD6lKELefiqJLc=;
        b=VbdGD8chhBRzLL+Hd6Zg4iX5sgJvs/ItGHe69QQLkmiODLZf9tJizMdwLNDrxknKkx
         /jKuWxYIW/WVMjhH87lZBIMa05mvZ12pnVIfVhwmLl5fbpfOzYSrg4oyEwe+hk6KXBgo
         fRGnRIXNDNDkjXsuGhQsdYHgr0FIJtQxHcDMG1lvakuHSh9X5zgRcJ6bzI59wMUVG3i8
         8hKFwPKiizd7IAp+c/gXBKPi7q2abk1Hc1HBsrlR8QUQeaaRGKl1CfBB8g5dKXlY2gvz
         BAvIdPhsTVPfnii1KMa1j28RRU8Z+GzeDEKSUxweikQXtulRIgvoP+reXjjPrfxQPuhg
         iBdg==
X-Gm-Message-State: AOAM532RK+aabuEQPR3v3bWt379hZWX/NUWtPwCnZa/miTprFx/LD0NS
        HI8eeiZeR2HSBYZBCU8Qk/BAp0iUcZ/v3w==
X-Google-Smtp-Source: ABdhPJyzbcVuxHOfPTMrwkd3SWERPbeFawhOz2K3p8tBEv2YLU9P91eWIHp1ie+WdNn4i5kI2mGo8w==
X-Received: by 2002:a17:90a:eac3:: with SMTP id ev3mr1681418pjb.27.1611694496558;
        Tue, 26 Jan 2021 12:54:56 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id r21sm5495pgg.34.2021.01.26.12.54.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 12:54:56 -0800 (PST)
Date:   Tue, 26 Jan 2021 12:54:34 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 211363] New: i40e: WARNING from i40e when ethtool -S is
 run.
Message-ID: <20210126125434.570fa71e@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 26 Jan 2021 19:23:29 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 211363] New: i40e: WARNING from i40e when ethtool -S is run.


https://bugzilla.kernel.org/show_bug.cgi?id=211363

            Bug ID: 211363
           Summary: i40e: WARNING from i40e when ethtool -S is run.
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: wilder@us.ibm.com
        Regression: No

When veb-stats are enabled ethtool -S hits the WARN_ONCE in
i40e_add_one_ethtool_stat().

To reproduce:
ethtool --set-priv-flags <int> veb-stats on
ethtool -S <int>

unexpected stat size for veb.tc_%u_tx_packets
WARNING: CPU: 61 PID: 10113 at
drivers/net/ethernet/intel/i40e/i40e_ethtool.c:110
i40e_add_one_ethtool_stat+0x140/0x1a0 [i40e]
<cut>
[  649.377973] Call Trace:
[  649.377980] [c000003b6d937810] [c00800000debab54]
i40e_add_one_ethtool_stat+0x13c/0x1a0 [i40e] (unreliable)
[  649.377996] [c000003b6d937890] [c00800000def3b4c]
__i40e_add_ethtool_stats+0x84/0x6698 [i40e]
[  649.378010] [c000003b6d937920] [c00800000debe904]
i40e_get_ethtool_stats+0x2bc/0x4e0 [i40e]
[  649.378023] [c000003b6d937a20] [c000000000c99854] dev_ethtool+0x6c4/0x2be0
[  649.378033] [c000003b6d937b30] [c000000000c1340c] dev_ioctl+0x5ac/0xa50
[  649.378042] [c000003b6d937bc0] [c000000000b8ca7c] sock_do_ioctl+0xac/0x1b0
[  649.378051] [c000003b6d937c40] [c000000000b8d564] sock_ioctl+0x234/0x4a0
[  649.778238] [c000003b6d937d10] [c000000000559c40] do_vfs_ioctl+0xe0/0xbd0
[  649.778247] [c000003b6d937de0] [c00000000055a904] sys_ioctl+0xc4/0x160
[  649.778257] [c000003b6d937e30] [c00000000000b408] system_call+0x5c/0x70

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
