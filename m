Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F88365B6C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhDTOsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhDTOsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:48:03 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB6EC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 07:47:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w10so26791668pgh.5
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=78jgJfCB/NiII6yWOpBjMQh7kzJPawiHybMe75ze5p0=;
        b=mfTwyedCcZmacrB6nMtdxrftMHIOuu4dflCAq8NfOYfdksJDTV7nZeGVfxNfL+EzbH
         1gjX1CVXoKR/gkHkLXrg35VcU1ec9uG9vU7q/TRhdGo6I8EJMqO+Dm1lbktyQK5SST6S
         V/CxWSO2exVPSoWGfFaD6TktcRHxrbBO197rzk5MpA+M/EXCyQnV2jzDzHLLWySuuBXc
         0N6gahLfBv+G+I+5BM1AWn5VvTMiOZDNZRfeo16CkO148MwX2LZ1FYM6UTfoyynHFqWo
         A5oDNRl7fJG4szZVRR9C7zVPqu/wDfh2a3iVYjSXx9WMjbVhU2Jsh+T5yIEiJAasKMeF
         S7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=78jgJfCB/NiII6yWOpBjMQh7kzJPawiHybMe75ze5p0=;
        b=CilVjYI2rjcywRak6NJ33cIzGLnurDME/G+sNllSh8+ZtF4nACytgDidxKdmQQgOo+
         N+frVl9bwfPU7T1cHek2oZME4kZxdHBeg6K9raa/XU9wPNEzqRTOTwfSVam7ILTnBXP1
         0TMxiwHcC8CiHO9D3lM7tQDiqknthvjBkUmizqdcwdN+d+rGgvE1DaOFzs0Xza8/jIUV
         7lIMHe9hNo8fBXZN99AJSdEif6Ee/dBt4aOR0DtQ4fPlpVT7Gm8UHKejPMJK4rOdCP9T
         +ETI9omu7/q14j5h7O8IJ3xIMjRXHAUeGVQF6XuCKxSxc/J5cW3HG3rPFF40TC+mPrr1
         AQrA==
X-Gm-Message-State: AOAM5310DCO0JlFyk8bYGhytdjcK0BAvVstWD1gEgOJX0FO8VrYdUFSx
        05oNF/rhgJHy+g+wb07vGmSrRQ==
X-Google-Smtp-Source: ABdhPJyCNEDnob0YdNAWI51T4LYHJMEYRYV/eLVyjt42RcpkK053UrkU0hrjVxa+KKiejtFie+Rvgw==
X-Received: by 2002:a63:d009:: with SMTP id z9mr17212604pgf.16.1618930051655;
        Tue, 20 Apr 2021 07:47:31 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id z188sm5009103pgb.89.2021.04.20.07.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:47:31 -0700 (PDT)
Date:   Tue, 20 Apr 2021 07:47:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Fw: [Bug 212731] New: USB Ethernet adapter ASIX AX88179 disconnects
 under heavy load.
Message-ID: <20210420074723.0ea444b8@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 20 Apr 2021 02:24:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212731] New: USB Ethernet adapter ASIX AX88179 disconnects under heavy load.


https://bugzilla.kernel.org/show_bug.cgi?id=212731

            Bug ID: 212731
           Summary: USB Ethernet adapter ASIX AX88179 disconnects under
                    heavy load.
           Product: Networking
           Version: 2.5
    Kernel Version: 5.11.13
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: kozyavk@gmail.com
        Regression: No

Hi!

I bought three USB3.0-Ethernet adapters (AX88179) on Aliexpress in attempt to
make three small arm servers from scavenged tablets.

Two of the tablets are Allwinnwer A10 based and one is based on Amlogic
8726-MX.
For A10 tablets I compiled the latest mainline kernel (5.11.13). For Amlogic I
compiled kernel sources which they provided in 2014 (3.10.10). All boards have
Ubuntu 20.04 rootfs.
I tried ax88179 driver included in kernel, I also tested the latest driver from
ASIX web site. All possible combinations of these boards, kernels and drivers
have similar problem:

When I install and run transmission-daemon to download some torrents - network
connection between tablet and external devices disappears (Transmission loses
connection too). From inside of tablet I can ping ASIX adapter's IP, but I
can't ping router or any Internet address. I can't ping tablet from outside. 
Adapter's LINK LED in ON and even ACT LED is blinking but there is no actual
connection.
There are no (relevant) error messages in syslog or dmesg.

I tried to disable green ethernet etc - didn't help (options ax88179_178a
bEEE=0 bGETH=0).
I tried to find some buffers I could increase or some options like ethernet
flow control that could possibly help me, but ethtool refuses to set any of
them which is strange, because all those options are available in driver for
Windows OS.

I also tried to provide separate power supply for the adapter, add more
capacitors to stabilize adapter's power supply, used different USB ports and
external hubs, different ethernet cables... it changed nothing.

When systemd-networkd is used to manage network, the connectivity of dead
adapter usually could be restored by replugging ethernet cable. I can see "link
state is 0   link state is 1" in syslog
The connectivity can also be restored by running 
ip link set dev usbnet0 down 
ip link set dev usbnet0 up

The amount of time between the launch of Transmission and network disappearance
is usually less than 5 minutes on download speed about 20-40Mbps ( 3 files, 10
peers each). If download speed is limited in Transmission's config  to less
than 10Mbps - the time before network disappearance can be much larger but the
device could stay online for 5 hours and then have dozen of disconnects during
the sixth hour. So this timeout is unsteady.

I also made a test on DELL Latitude 3490 laptop with latest KDE Neon installed
(I think it has Ubuntu's x86_64 kernel as is). The problem with adapter remains
on conventional laptop too. After a few minutes of downloading the message
appears "Limited connection. The adapter appears to be connected to network but
Internet in unreachable" - something like that.

Then I connected my laptop to my network provider directly (bypassing router) -
the problem remained. 

So the problem is not in my switch/router or my old ARM boards. It is either
adapter itself or something in the software. 

And finally, I made two tests on the same laptop running Windows 10. I used
uTorrent instead of Transmission but with the same heavy load.
The adapter works flawlessly on Windows under any load. At least during 24
hours.

So, I think there is some problem with driver for AX88179 devices.
I hope actually, that the problem is just in the size of some buffers in USB or
TCP/IP stack, but I have no clue what could it be.
I use some tuning of TCP/IP for higher network load on my other device:

net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.udp_mem = 8388608 12582912 16777216
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 65536 8388608

but it doesn't help me with ASIX.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
