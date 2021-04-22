Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89274368419
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbhDVPqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbhDVPqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:46:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C18FC061363
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 08:43:49 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id z16so33108214pga.1
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 08:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=veKfPd8hjR8ZaHZDt/Ls8q2fgKgRX8IUImITU6NKqQ8=;
        b=AULEk5Pu7NJa9I+ukF5g4ADGkbMMWKKm2hwwcq5d2zP7FaHQu8FwMD9kLXgU0viu1R
         YgOw0wEewbiz1yLq1lEsTOMn6KH4mlQ7ND1z/3RqUEnON6sH4g2wrCydvJJGpjdeEC7U
         8+wXmDvFMijfzlJViBUdXISA0rAQrP8zdC9DpViRTPipQ9Rpz8uDmUsN8gBc7Jxy+X96
         Xg5J1PR2OojVZyRpYtMFUY4dJYH0GR7lbvb75ZGkZLc6jhOelN9lzY5rwvq2K/lWYRyy
         hG4A4sd9U1lGRxWl2p+hJZzFAOAAV9A9Br5sLagTy+qDmWC2SO9XhbphCz/HPAyOqRbT
         C1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=veKfPd8hjR8ZaHZDt/Ls8q2fgKgRX8IUImITU6NKqQ8=;
        b=oPENfKa78xd+evj4WOW/c9l4dnfhQ/vx2pKb7yR7o9qhmWUL+JnxgKKi0vJ6fpoaqa
         5awWwGLmFXq3VHpE5nTV5NeZD6wFgES3bLIcq64qdbpPqCwaeGqfDAy3OLfCcJPRks0P
         SdpFIrJ0OUHwudkxYhByzaQd3BCLn5Po21OYv1tBzV74CjykB7AWLEVBFoo7mG+CWfj9
         1N3BZZpj4jO9VaZBnXIXwYD06n8wLrgZwsyBvgYXQZNdQGP8aK9PAoDZF7uRKcRP3Ikn
         nxrfbku6OvNP1opFdj8dOi9MGNYrOA0G2JvwrASUxVLkceARh8zg74jI720C4sjeepxi
         KFpQ==
X-Gm-Message-State: AOAM533UKUT4waeuTqge18T+XwcsGuP3XQ06RPPErUU+eifgdcYYYKdh
        cr483xAmNDrDb+8fXzfZTh2xSE13IljrUA==
X-Google-Smtp-Source: ABdhPJwhqeUIZ5xCAhO7Amvov0FODDswYOWEHPs79gbpS7mK8GpWSQSYlUmoxAVP2s5VzJ0c1Fi8qA==
X-Received: by 2002:a62:824c:0:b029:21b:66f5:c813 with SMTP id w73-20020a62824c0000b029021b66f5c813mr3998378pfd.32.1619106227911;
        Thu, 22 Apr 2021 08:43:47 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id h6sm2547548pfb.157.2021.04.22.08.43.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:43:47 -0700 (PDT)
Date:   Thu, 22 Apr 2021 08:43:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212749] New: ping over geneve over ipv6 would fail
Message-ID: <20210422084331.432a4a24@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 22 Apr 2021 09:42:25 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212749] New: ping over geneve over ipv6 would fail


https://bugzilla.kernel.org/show_bug.cgi?id=3D212749

            Bug ID: 212749
           Summary: ping over geneve over ipv6 would fail
           Product: Networking
           Version: 2.5
    Kernel Version: 5.12.0-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jishi@redhat.com
        Regression: No

ping over geneve over ipv6 would fail on 5.10.0-rc7 after commit=20
Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git
            Commit: 88a5af943985 - Merge tag 'net-5.12-rc8' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

reproducer:

ip netns add client                                                        =
    =20
ip netns add server                                                        =
    =20
ip link add veth0_c type veth peer name veth0_s                            =
    =20
ip link set veth0_c netns client                                           =
    =20
ip link set veth0_s netns server                                           =
    =20
ip netns exec client ip link set lo up                                     =
    =20
ip netns exec client ip link set veth0_c up                                =
    =20
ip netns exec server ip link set lo up                                     =
    =20
ip netns exec server ip link set veth0_s up                                =
    =20
ip netns exec client ip addr add 2000::1/64 dev veth0_c                    =
    =20
ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c                  =
    =20
ip netns exec server ip addr add 2000::2/64 dev veth0_s                    =
    =20
ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s                  =
    =20
ip netns exec client ping 10.10.0.2 -c 2                                   =
    =20
ip netns exec client ping6 2000::2 -c 2                                    =
    =20
ip netns exec client ip link add geneve1 type geneve vni 1234 remote 2000::2
ttl 64                  =20
ip netns exec server ip link add geneve1 type geneve vni 1234 remote 2000::1
ttl 64                  =20
ip netns exec client ip link set geneve1 up                                =
    =20
ip netns exec client ip addr add 1.1.1.1/24 dev geneve1                    =
    =20
ip netns exec server ip link set geneve1 up                                =
    =20
ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
ip netns exec client ping 1.1.1.2 -c 3

actual result:
+ ip netns exec client ping 1.1.1.2 -c 3                                   =
    =20
PING 1.1.1.2 (1.1.1.2) 56(84) bytes of data.                               =
    =20
=46rom 1.1.1.1 icmp_seq=3D1 Destination Host Unreachable                     =
      =20
=46rom 1.1.1.1 icmp_seq=3D2 Destination Host Unreachable                     =
      =20
=46rom 1.1.1.1 icmp_seq=3D3 Destination Host Unreachable                     =
      =20

--- 1.1.1.2 ping statistics ---                                            =
    =20
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2072ms

expected result:
ping should pass

BTW, ping over geneve over ipv4 would pass

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
