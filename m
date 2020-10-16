Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFED290202
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 11:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406032AbgJPJfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 05:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405602AbgJPJf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 05:35:27 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBFEC061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 02:35:27 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t6so807490qvz.4
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 02:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=kTL8KbBSI0PcS7UrUtEs69uV66CPRIVv/CKLzegyajI=;
        b=JZlZclLMtR+uBeAFY9HIUeNr913zwNSPbLEYoyqZ23tLEVSsq9YVR4M9dR8aA+dFQH
         UqvW9U987TFG4FuzSfbdlwNRwbwtZtqp2iSDvWXEwMXoLdv9E7OvBz/mdEYN9lyzb3Ke
         xlcjENCsHFAX+SlZkRYk84RjGHYnycoY+tixuTmH0rBh9dxOarSFNb0ouLzIXNzWRRJO
         QJ03f8aJh61B6ewPxVTKbTKBAbkcPWBJ3r79IV7ccBgY1dopk3fjOVUrpYry2fsUI6t9
         fMmMPlpjgsVypIL81b+Ll2ZZJXDqUHYeDe7sJrtG/jnEmB2n9Av2EkU1cpRrqFb7POwI
         7YXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=kTL8KbBSI0PcS7UrUtEs69uV66CPRIVv/CKLzegyajI=;
        b=QqvieLSHkZQUG5YEGJWm51MREgT18rQO37A4ycJsbjxkRng0Eafo1TUYW2pDvU6A8R
         /7n/nXggVSIQeIL+VKdSCd12RkweqX8gG+5ujVas0e/7Y+0lX2SnVNY+UdvO509ph4ZM
         MIC0PpBETcUsvJUMUbEAn4J5WyFLaigepT2VqDT1riaj0hte7FOJKl9VilwO6V2ZaEtj
         c8f8cVdWg0kABIhm+7cKs6+1+LXlk2D8q4qnb4976r49TKwFI5vjY0uokxSGXlryAR1+
         s1rJF6TnclxA9YrzaW7LOcLoq4P6JrI+bsYGB5Nylf0wtnIbG9rlM/DAC63fvIco4wg5
         Cv7w==
X-Gm-Message-State: AOAM531Ct2A2tKCqesx82XuTLD5xZhSK/tGYkiz/gp5uVmU3MbVEHZX9
        nfwLOQkEt1df+sHZqn1LWGxlbXU2LGXpcHCXndg=
X-Google-Smtp-Source: ABdhPJyYkAIJ3d4kEo3kKj4YzGbkdy7mSbNbEei4GIHZrw8zOCDqaO9v1XNwdZlHSVLwY2uKHlTDQaLT180uLZ75nPI=
X-Received: by 2002:a0c:9e0e:: with SMTP id p14mr2895900qve.25.1602840926171;
 Fri, 16 Oct 2020 02:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZv=13q8NXbjdf7+R=wu0Q5=Vj9covZ24e9Ew2DCd7S==A@mail.gmail.com>
In-Reply-To: <CAA85sZv=13q8NXbjdf7+R=wu0Q5=Vj9covZ24e9Ew2DCd7S==A@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Fri, 16 Oct 2020 11:35:15 +0200
Message-ID: <CAA85sZs9wswn06hd7ien2B_fyqFM9kEWL_-vXQN-sjhqisizaQ@mail.gmail.com>
Subject: Re: ixgbe - only presenting one out of four interfaces on 5.9
To:     jeffrey.t.kirsher@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding netdev, someone might have a clue of what to look at...

On Mon, Oct 12, 2020 at 9:20 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> Hi,
>
> I was really surprised when i rebooted my firewall and there was
> network issues, I was even more surprised when
> only one of the four ports of my ixbe (x553) nic was available when booted.
>
> You can actually see it dmesg... And i tried some basic looking at
> changes to see if it was obvious.... but..
>
> anyway, on v5.8.14:
> dmesg |grep ixgbe
> [    1.355454] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver -
> version 5.1.0-k
> [    1.355455] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
> [    1.711629] ixgbe 0000:06:00.0: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    1.838170] ixgbe 0000:06:00.0: MAC: 6, PHY: 27, PBA No: 030000-000
> [    1.838173] ixgbe 0000:06:00.0: 0c:c4:7a:fa:3d:4a
> [    1.882060] ixgbe 0000:06:00.0: Intel(R) 10 Gigabit Network Connection
> [    1.882196] libphy: ixgbe-mdio: probed
> [    2.234835] ixgbe 0000:06:00.1: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    2.361374] ixgbe 0000:06:00.1: MAC: 6, PHY: 27, PBA No: 030000-000
> [    2.361377] ixgbe 0000:06:00.1: 0c:c4:7a:fa:3d:4b
> [    2.405281] ixgbe 0000:06:00.1: Intel(R) 10 Gigabit Network Connection
> [    2.757541] ixgbe 0000:07:00.0: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    2.884104] ixgbe 0000:07:00.0: MAC: 6, PHY: 27, PBA No: 030000-000
> [    2.884107] ixgbe 0000:07:00.0: 0c:c4:7a:fa:3d:4c
> [    2.928022] ixgbe 0000:07:00.0: Intel(R) 10 Gigabit Network Connection
> [    3.280728] ixgbe 0000:07:00.1: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    3.407274] ixgbe 0000:07:00.1: MAC: 6, PHY: 27, PBA No: 030000-000
> [    3.407276] ixgbe 0000:07:00.1: 0c:c4:7a:fa:3d:4d
> [    3.451155] ixgbe 0000:07:00.1: Intel(R) 10 Gigabit Network Connection
> [    4.648725] ixgbe 0000:07:00.0 eno3: renamed from eth2
> [    4.659827] ixgbe 0000:06:00.0 eno1: renamed from eth0
> [    4.674272] ixgbe 0000:07:00.1 eno4: renamed from eth3
> [    4.685838] ixgbe 0000:06:00.1 eno2: renamed from eth1
> [    6.070294] ixgbe 0000:06:00.0: registered PHC device on eno1
> [    7.178307] ixgbe 0000:07:00.0: registered PHC device on eno3
> [    7.421199] ixgbe 0000:07:00.1: registered PHC device on eno4
> [    7.662712] ixgbe 0000:06:00.1: registered PHC device on eno2
> [    9.587640] ixgbe 0000:06:00.0 eno1: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [   10.605594] ixgbe 0000:07:00.1 eno4: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [   10.754615] ixgbe 0000:07:00.0 eno3: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [   10.768586] ixgbe 0000:06:00.1 eno2: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
>
> on 5.9:
> dmesg |grep ixbge
> [    1.570400] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver
> [    1.570401] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
> [    1.928030] ixgbe 0000:06:00.0: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    2.054554] ixgbe 0000:06:00.0: MAC: 6, PHY: 27, PBA No: 030000-000
> [    2.054556] ixgbe 0000:06:00.0: 0c:c4:7a:fa:3d:4a
> [    2.098404] ixgbe 0000:06:00.0: Intel(R) 10 Gigabit Network Connection
> [    2.098541] libphy: ixgbe-mdio: probed
> [    2.453350] ixgbe 0000:06:00.1: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    2.579938] ixgbe 0000:06:00.1: MAC: 6, PHY: 27, PBA No: 030000-000
> [    2.579941] ixgbe 0000:06:00.1: 0c:c4:7a:fa:3d:4b
> [    2.623783] ixgbe 0000:06:00.1: Intel(R) 10 Gigabit Network Connection
> [    2.987339] ixgbe 0000:07:00.0: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    3.113864] ixgbe 0000:07:00.0: MAC: 6, PHY: 27, PBA No: 030000-000
> [    3.113867] ixgbe 0000:07:00.0: 0c:c4:7a:fa:3d:4c
> [    3.157635] ixgbe 0000:07:00.0: Intel(R) 10 Gigabit Network Connection
> [    3.529503] ixgbe 0000:07:00.1: Multiqueue Enabled: Rx Queue count
> = 12, Tx Queue count = 12 XDP Queue count = 0
> [    3.656041] ixgbe 0000:07:00.1: MAC: 6, PHY: 27, PBA No: 030000-000
> [    3.656043] ixgbe 0000:07:00.1: 0c:c4:7a:fa:3d:4d
> [    3.699856] ixgbe 0000:07:00.1: Intel(R) 10 Gigabit Network Connection
> [    4.646247] ixgbe 0000:06:00.0 eno1: renamed from eth0
> [    6.183074] ixgbe 0000:06:00.0: registered PHC device on eno1
> [    9.570382] ixgbe 0000:06:00.0 eno1: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
>
> lspci....
> 06:00.0 Ethernet controller: Intel Corporation Ethernet Connection
> X553 1GbE (rev 11)
> 06:00.1 Ethernet controller: Intel Corporation Ethernet Connection
> X553 1GbE (rev 11)
> 07:00.0 Ethernet controller: Intel Corporation Ethernet Connection
> X553 1GbE (rev 11)
> 07:00.1 Ethernet controller: Intel Corporation Ethernet Connection
> X553 1GbE (rev 11)
>
> ethtool -i eno1 and eno2
> driver: ixgbe
> version: 5.1.0-k
> firmware-version: 0x80000877
> expansion-rom-version:
> bus-info: 0000:06:00.0 (and 0000:06:00.1)
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
>
> while eno3 and eno4 gives:
> driver: ixgbe
> version: 5.1.0-k
> firmware-version: 0x8000087c
> expansion-rom-version:
> bus-info: 0000:07:00.0 (and 0000:07:00.1)
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
>
> Any ideas?
