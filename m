Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6E45D040
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 23:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbhKXWsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 17:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345477AbhKXWsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 17:48:19 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0094C06173E
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 14:45:08 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i12so4030362pfd.6
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5OHD8nvAzcGYtmdFFwK0hJdx6ueQwnR7ir7IqTvMNcQ=;
        b=K32W0jPQdEbsIOCvHMUUgQY7TUdXBon+PvzX+X2Keqo9FxvVaE3incmD4catVEDEAE
         R4nPi69I7PvR6nLA/rWUR688EyApu4jwP73tKDCCkQdvYkRRXfrxY+KEmTtZrqr4GHVM
         5umX0bJ1x/Tnu6HdpTfyzQ0CJaoeJu061+UMQI+vHq/rxmL0x9GufulO5cDFdd1+tYJV
         Sm3ZAOt6w5lzAhjtLPLbQoSckkY45cwBFLI002sVZajzCbw4m7P7Os1B+fo4t94xl5VR
         iR1uFqMqjgsFRQvyYL50fUeV6u9HlSZYfozj+OKWyw40cPAmkvYAIKsBsxkV0kFzNiIE
         NxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5OHD8nvAzcGYtmdFFwK0hJdx6ueQwnR7ir7IqTvMNcQ=;
        b=wy0wAf6FQG5DtpFjs/QRZkXR1aLV6RINbyqxtStTwKCwy5dFXNgnCn7GA39CpIb/33
         rdtGwX6Yit+KhtzaPd2dN1iV78z6X/obL0ittF92TUPOBmtXrOE12foh3QXLqP7xAbh0
         f020HQo+B58kCkOM8Lzn9DgT6YWR3kzIQuywg0V5Bo//pTfSBhSsUJNeC8uDtYlcDLHF
         w9bS8k2IPYXp55aXArQZU7du2FyZ93C+ws5C8/+Nxwux5H4mZNf5eWlPoLFYCuZ3BJAC
         OJUfU5JIxzABF3nhOH8ndVbXtWBHJxcXppbxcxFg/ZLMy2BjkIvNThGLQkSkxxfH2G8g
         ZA9A==
X-Gm-Message-State: AOAM533+oLnuS7ShNBGNYHYiTLOaz8TXod3AWf3KZhK6FvFH/Qj2iuUw
        /Xyph7mDOaTGyw3vzxS8EJ5kLUeegt6+gwwW
X-Google-Smtp-Source: ABdhPJzW0GM06ZDDe/oBWDi+ICMswbm2ZDsuP++OyIiHe5TAQLVLmsBwZDBnyQi42scmSoCbBPyKGA==
X-Received: by 2002:a65:5b41:: with SMTP id y1mr13036075pgr.481.1637793907957;
        Wed, 24 Nov 2021 14:45:07 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id a13sm824000pfv.99.2021.11.24.14.45.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 14:45:07 -0800 (PST)
Date:   Wed, 24 Nov 2021 14:45:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215129] New: Linux kernel hangs during power down
Message-ID: <20211124144505.31e15716@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 24 Nov 2021 21:14:53 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215129] New: Linux kernel hangs during power down


https://bugzilla.kernel.org/show_bug.cgi?id=215129

            Bug ID: 215129
           Summary: Linux kernel hangs during power down
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: martin.stolpe@gmail.com
        Regression: No

Created attachment 299703
  --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit  
Kernel log after timeout occured

On my system the kernel is waiting for a task during shutdown which doesn't
complete.

The commit which causes this behavior is:
[f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
parent before ethtool ioctl ops

This bug causes also that the system gets unresponsive after starting Steam:
https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
