Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8F62B811B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgKRPq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgKRPq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:46:28 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9896EC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:46:28 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b12so1312587pjl.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=z7f9vk3jbmHk0v9t2KqGhxSimLXmaNVdp0VHEA18+X8=;
        b=wEaBGNhC4aIGlapuMb4UxZl4fI2kwdd4lhullknDNra0Fq9FZb4rdn0AdOLnsEzsRO
         4SFaHvStohy4bHMP7K3fx/kDNzjHG2HisnOMP+Diq0eFOBE444SpviB58/rgorP+0pNI
         FveO91o1lpXhdAEsJd7FOj4amovicpd3joOIpGPbnhINtKPtdBeXWu9F3S0Cu+Gp2udy
         mbwyn7/zJPuKxSMb1py41Jq8gP/4ZzhYiIHkzqysJglo7qRUr8AegGNcQFwmknr59ALE
         f8JZiWt3ah8y6cdRZVdsZnL8q+RxXPU7yEnU5N+NEdaa64lk7izf5xGX71StTI7IiN1f
         6IjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=z7f9vk3jbmHk0v9t2KqGhxSimLXmaNVdp0VHEA18+X8=;
        b=Jr35SYRTbZng0y5/UZ/aTIuamEUiqUrEsTbYCoYA2wlxdYJx0yYptCj0sfSgDAlgjM
         dPOqsYtqH4rTPUhM4eUWngBkY1uOaX7y5N5WP8cvJUgGRkab4KmVfidTDVq9NFdHpTcA
         nvTBA0NlCbfibqxx1xmLN+ucCFP4bxu/IhqitnlZzkciTd01xIJUZ8e0lbYY8UTCctd0
         AQX0yiKAkFBSx68hNz1pTT+P/z5ew8I9ziWX/7XldvcIsIkVkgtKDdbWzOZjHzYxNXPp
         JGCl2/T26rmWdvRWn95MMZM5cFIHupMaxfyhUd0IiR+ptswl/Qjs9Wie4HOsAFC1XOe2
         I1HA==
X-Gm-Message-State: AOAM5331iKZ81lsLL2KJQASz3uWuMS5qf/6mCEu78x8xPfDo0ygDhsvt
        p5TUvErYNCK3hwixyj4R1JRDAgVIbKwPfmRX
X-Google-Smtp-Source: ABdhPJweFXl/FeVbXWxnC2PFMilKxUyavgWlaUk1LtXT9sSjjQuiNsYeaj10kgbtsWebIQfAp4f74g==
X-Received: by 2002:a17:90a:4215:: with SMTP id o21mr503069pjg.166.1605714387514;
        Wed, 18 Nov 2020 07:46:27 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id fs11sm2931025pjb.56.2020.11.18.07.46.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:46:27 -0800 (PST)
Date:   Wed, 18 Nov 2020 07:46:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 210255] New: IP_UNICAST_IF has no effect on connect()ed
 UDP sockets
Message-ID: <20201118074611.0df443d6@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 18 Nov 2020 15:06:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 210255] New: IP_UNICAST_IF has no effect on connect()ed UDP sockets


https://bugzilla.kernel.org/show_bug.cgi?id=210255

            Bug ID: 210255
           Summary: IP_UNICAST_IF has no effect on connect()ed UDP sockets
           Product: Networking
           Version: 2.5
    Kernel Version: 5.9.0-36.fc34.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: mzxreary@0pointer.de
        Regression: No

The IP_UNICAST_IF sockopt has an effect for unconnected UDP sockets, and is
used as key for the route lookup. However, when using connect() on an UDP
socket, then the routing decision is already done at connect() time, and unlike
the routing decision for unconnected sockets the IP_UNICAST_IF sockopt is not
taken into consideration then.

I figure this was simply forgotten when IP_UNICAST_IF was added, but I am
pretty sure this should be corrected so that connected and unconnected UDP
sockets behave more alike.

(SO_BINDTODEVICE/SO_BINDTOINDEX actually works on both equally, but given they
do a lot more than IP_UNICAST_IF they are no replacement)

(This was noticed in context of the UDP/DNS code in systemd-resolved, see this
for further discussion:
https://github.com/systemd/systemd/issues/11935#issuecomment-618691018)

(The research on this was done by hvenev, not me, I am just propagating his
findings here.)

-- 
You are receiving this mail because:
You are the assignee for the bug.
