Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6821F3F62
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgFIPae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 11:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgFIPae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 11:30:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C01EC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 08:30:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i12so1553272pju.3
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=lbUbdI1W79b3WzSnB9TPnblvdY7hzoyrIw1X2UrT4qE=;
        b=aP3SMGWu3ZuAhlWy9N1MoZuIqBLNC4iiQp5Ki35vKlN5TyXe9huBMe2lyM0LKXC6U3
         EriV9mLpwkt32VQ/slFsOeIu3AzyNQcNIiPJUn/rWumGIiQUwl2SgeTiJXSiIBYlarTI
         lrfZUfKX43GnlR0gg2KToDxRy53qKmf35FDqRwrSr0TAMVo+bDRhx1T+wd9bPplsKCPX
         fZlOVQxex3Iex383uk8E4X39ajWr6Qk4TPK9mbbnF3B+IVb8UpsiZit7nS2BIzBjYljf
         4GR5sVrZIX7rUz7/Te72mLQ0ucCSDO273wpR8e4K/L65ZJHp7vmlmJZqaqRckB7dKun6
         /hIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=lbUbdI1W79b3WzSnB9TPnblvdY7hzoyrIw1X2UrT4qE=;
        b=R1xPvpSFXlluWPZBKxZM/S7OkBmAkAqBrorPptAeRUDdyyufzW4+qTJGJZnAcA2xzD
         EPtrGVon4WknvH/Ab4FRfkUlmt1xg6zQrBNhS14mS7GLGctfUOKv3pFydtiC/80Tq1vw
         cR7uBD/RRTyfBqw3ppYnmQxg4GNHKFhga2akGDNjnxwQ9x9kUKIgYFjQd7DfnrUmeHIj
         axpRqpApICFKr7b8NZyyk5IkcrlRaCuuAwcGa7wuJuJDnDP0xPT8iOAfY5cNAIMBtU02
         896CshRFTDIBdxgvoghEi5pAO5fn3bj8iSIlOO+K7AS2ABjbHN2/vn2tdgnMCStnAUjt
         MPyg==
X-Gm-Message-State: AOAM530iFKWr5FYQHxVYopo1h3A59IiT7K5trg7K+DKMc81WQZhJGBpi
        3AXHtopWnPeJevG1ELHMhrCUUwoV+GM=
X-Google-Smtp-Source: ABdhPJwlAUIt471vTEEZx9xevRqFnc3f7b7iHFH/1U90lqpU4Sn3DcpxfkRum0x46aaDLFOY7RNzKw==
X-Received: by 2002:a17:90a:5a07:: with SMTP id b7mr5258059pjd.130.1591716632078;
        Tue, 09 Jun 2020 08:30:32 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y5sm8835627pgl.85.2020.06.09.08.30.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 08:30:31 -0700 (PDT)
Date:   Tue, 9 Jun 2020 08:30:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 208107] New: hard lock with CONFIG_CGROUP_NET_PRIO enabled
Message-ID: <20200609083029.70596c4e@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 08 Jun 2020 21:53:11 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208107] New: hard lock with CONFIG_CGROUP_NET_PRIO enabled


https://bugzilla.kernel.org/show_bug.cgi?id=208107

            Bug ID: 208107
           Summary: hard lock with CONFIG_CGROUP_NET_PRIO enabled
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.42
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: cam@neo-zeon.de
        Regression: No

A bug was introduced with commit fc800ec491c39e42b65df72dc9ede3bb2d4a3755 where
my NFS server (which supports Kerberos) will lock up the system after a client
has mounted volumes export by the NFS server.

Unsetting CONFIG_CGROUP_NET_PRIO or reverting
fc800ec491c39e42b65df72dc9ede3bb2d4a3755 resolves the issue.

I get nothing on the console or in the logs once this occurs. The system is
locked until it finally restarts on its own or through user intervention. The
client machine I used for testing has CONFIG_CGROUP_NET_PRIO enabled in the
kernel, but it causes no issues there.

I suspect the Kerberos functionality has no impact on this issue, but I'm
presently unable to disable it.

I'm not actually using the functionality provided by CONFIG_CGROUP_NET_PRIO, so
I've disabled it for now.

All kernels since v5.4.42 are affected. By disabling this feature or reverting
fc800ec491c39e42b65df72dc9ede3bb2d4a3755 allows 5.4.2+ to work. I'm currently
running stable with v5.4.45.

The 5.5 and 5.6 series are unsurprisingly affected, and I suspect both series
would work with either of the fixes above.

Some info about the NFS server:
Debian 10 Buster
AMD EPYC 3251 8-core processor
128GB memory
Intel X540 10GB NIC PCIE nic (only 1 port is used)
2x Intel Corporation I350 Gigabit onboard NICs (both are used)

All NIC's are used in individual bridge interfaces for a total of 3 interfacs
(br0, br1, br2) to facilitate virtualization.

More info furnished upon request.

-- 
You are receiving this mail because:
You are the assignee for the bug.
