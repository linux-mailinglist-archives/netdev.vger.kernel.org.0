Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625D628C808
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 06:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgJMEjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 00:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgJMEjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 00:39:53 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77593C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 21:39:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x13so13286328pfa.9
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 21:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=h/SYra0nJ3lAnbnnToGH+G1Xs8BxrRKZg1vS9nYb6KE=;
        b=CDD6AyZXmgMc6ml8p1hRESvOHidFzxnkg6jAV1DPwtTjlNF7L6D8OfHojERcYRHaAk
         xbfDW64hNUdMJqa6ysDrY1cReePbveNe4F67AA8vRxaQ3qr72c27FtIvWCitvOfaPlg1
         NbOiz/RsrcFhNPa3diRBLGuPPnpexyvDfXD0GNvdnPstaRaGjhD3JQ23bV3abxoOL41S
         B4JtJRZsf3tTKNJ+Hwfw8ZAMJl23r0cP3JuQpjDCOd9h7haxSQPFuUr7cOVkW9oVpsW0
         GGo13jjH+FAzBt7zTvozyDh1LJEG96IfmkX81FU5BG6lTu0O0h0YD6tF4UyZ9j8kIGRw
         ScuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=h/SYra0nJ3lAnbnnToGH+G1Xs8BxrRKZg1vS9nYb6KE=;
        b=fPoSG0WYXv8ZM7CzpgaaOg93iJS4bqZ+DjiKuR8o9oo4NvK5nzPr6j4CQ2blV8ebXe
         8F7FXKsBD44qGpEIPzJtpxZfRZbemyDAjYl24oR/Yy0fTlulx/B/CJjEzpR5JAMh4ioz
         hJn8enlQfgorwvZyHQyDrBrTsVN7Xcoh+r3RdsnpcAJL3QU2hqVIDoqoujHFP6JNIbLm
         9qndPsTKE26iVjvNqUwnESMl7inAqq5Q53M43qrpqXDcGsZMGRTfz8igxiZzZMqvMDEk
         1qqgzctFlBymprFIy3N0XktI2nqkLP99D/IO9boh0LX7+DY4LzDB+Cr/fTfUNuwGgZBL
         jZwA==
X-Gm-Message-State: AOAM532eWq7EEjLJQDIwd/VX5O/rP0NSTWmZk6qoL/D5ncRQIoTwDs2/
        Hv6SdWhvMW3xhKgMR0j8cwM=
X-Google-Smtp-Source: ABdhPJypVz/zIT6e9UhembZLVBxVxJ36iqJ6GvOXJzwBLuuj+J4mNPFZy4BqW6sDNIPZcFiZWokdWA==
X-Received: by 2002:a62:9245:0:b029:156:4a19:a250 with SMTP id o66-20020a6292450000b02901564a19a250mr4506411pfd.2.1602563992902;
        Mon, 12 Oct 2020 21:39:52 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21sm8559762pfk.169.2020.10.12.21.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 21:39:52 -0700 (PDT)
Date:   Tue, 13 Oct 2020 12:39:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: vxlan_asymmetric.sh test failed every time
Message-ID: <20201013043943.GL2531@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

When run vxlan_asymmetric.sh on RHEL8, It failed every time. I though that
it may failed because the kernel version is too old. But today I tried with
latest kernel, it still failed. Would you please help check if I missed
any configuration?

# uname -r
5.9.0
# ip -V
ip utility, iproute2-ss200602
# netsniff-ng -v
netsniff-ng 0.6.6 (Syro), Git id: (none)
# cp forwarding.config.sample forwarding.config

# ./vxlan_asymmetric.sh
RTNETLINK answers: File exists
TEST: ping: local->local vid 10->vid 20                             [FAIL]
TEST: ping: local->remote vid 10->vid 10                            [ OK ]
TEST: ping: local->remote vid 20->vid 20                            [ OK ]
TEST: ping: local->remote vid 10->vid 20                            [FAIL]
TEST: ping: local->remote vid 20->vid 10                            [FAIL]
INFO: deleting neighbours from vlan interfaces
TEST: ping: local->local vid 10->vid 20                             [FAIL]
TEST: ping: local->remote vid 10->vid 10                            [ OK ]
TEST: ping: local->remote vid 20->vid 20                            [ OK ]
TEST: ping: local->remote vid 10->vid 20                            [FAIL]
TEST: ping: local->remote vid 20->vid 10                            [FAIL]
TEST: neigh_suppress: on / neigh exists: yes                        [ OK ]
TEST: neigh_suppress: on / neigh exists: no                         [ OK ]
TEST: neigh_suppress: off / neigh exists: no                        [ OK ]
TEST: neigh_suppress: off / neigh exists: yes                       [ OK ]

# dmesg
[...snip...]
[ 1518.885526] device br1 entered promiscuous mode
[ 1518.886211] device br1 left promiscuous mode
[ 1518.890637] device br1 entered promiscuous mode
[ 1518.941524] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1518.949522] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1519.165569] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1519.166900] IPv6: vlan10-v: IPv6 duplicate address fe80::200:5eff:fe00:101 used by 00:00:5e:00:01:01 detected!
[ 1519.392633] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1519.741559] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1519.861641] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1519.862993] IPv6: vlan20-v: IPv6 duplicate address fe80::200:5eff:fe00:101 used by 00:00:5e:00:01:01 detected!
[ 1520.181565] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1520.182739] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1524.853572] net_ratelimit: 4 callbacks suppressed
[ 1524.854346] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1525.365565] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1533.557792] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1534.069921] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1550.965225] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
[ 1551.477294] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
[ 1558.064257] device w3 left promiscuous mode
[ 1558.073279] br1: port 4(w3) entered disabled state
[...snip...]

Thanks
Hangbin
