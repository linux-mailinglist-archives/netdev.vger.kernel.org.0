Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD63589CE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhDHQcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhDHQcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:32:15 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CCBC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 09:32:03 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id i3so2772878oik.7
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NyyXsr6pNPWbhXTrA9x7ciY2EiNlgOW0HqJjPrTlb30=;
        b=iip2QCE8BVGzPCcWy3KAxsV8YvhUfG7rrIITBIAG7knGnMVkx+k823U9f6TLKtKfGA
         HWzixivOjIwBV00HDh5iM0hetAsvdHGMMHd1vda3P/E5dcLTJSMDFhamvVGbEN12UIfG
         NlV6VYDC5gRZW8DhVeb+y2O8/gvocn8klQ2qVh3n6zaksvWnr4kvJRXvxw66AbnUwyV6
         UJn6cu0OszqwGZ9nK4ptIZOPx2ieCQK/BHW6/YBmAoQLQA7+Z9Q+wh2HPwGwEm8UtELs
         4xJQLEioRpq/CzSdI5K+pyTsCe+YU00oyRMCLOyUyPZxHm/TbaLA081VlwSfxBz4rJcj
         OI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NyyXsr6pNPWbhXTrA9x7ciY2EiNlgOW0HqJjPrTlb30=;
        b=YITMBwgiL+G5hD9tcttd+LC6Rie3XFKkqjCFkIO2QtLkh3XshIjF54EKcB+v5aTMFi
         R09Or73czNDPxHaD59RoopR4F94NwUs9rhQ82fC/5h92IGeIfHgdPhn2buQB49LZqGht
         HsaYy00RG0ih3r2bICEV6jhlRCYkEPp3ElSu6iZ3Po4/GZ4nlUhzvVXYRB2Y74Q13YY7
         s+tQpIcNgzbxmrIS7t/XO0Vrj+PZlJxxgJ79l9gpJKbvK6PVKFWHsEwHjEjgeo2GTR2L
         ahVoiydZ+RSrlZ5Hvayra4ybI0fLqPjKUY0yGqArdaKB4GkIjRPbW+3ggA6AkjjU6AhI
         Uhyw==
X-Gm-Message-State: AOAM533Ai/cPWNVJCPDZtcKyypvr9f4d9MOe/hiWiuGg76tZwpHSln1w
        D7h5ey1xe8fLPJ4Y3iIepf96akmQM8xeBs2Je/VWtILTn/M=
X-Google-Smtp-Source: ABdhPJx4B8+x8PYDyFzaIM3Ppmo8DbTy59R38ZzFBYJ/7cSKgl2HVsM9ATHQ8JUKKZKmcVPnlCaACXHeXDybsTsAukE=
X-Received: by 2002:aca:ea06:: with SMTP id i6mr6881011oih.82.1617899522940;
 Thu, 08 Apr 2021 09:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSh4UxWxtedFuyDK41+98o8A_p-cvcCGW9kobNwUfJPg_8dHg@mail.gmail.com>
In-Reply-To: <CAFSh4UxWxtedFuyDK41+98o8A_p-cvcCGW9kobNwUfJPg_8dHg@mail.gmail.com>
From:   Tom Cook <tom.k.cook@gmail.com>
Date:   Thu, 8 Apr 2021 17:31:51 +0100
Message-ID: <CAFSh4Uw=sgzbdkevCHWdeMhcrn=y4QTDWufDT=7nSo-R5Q1iLw@mail.gmail.com>
Subject: Re: bind() and PACKET_MULTICAST
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never mind.  In case anyone was wondering, PACKET_ADD_MEMBERSHIP is a
SOL_PACKET option, not SOL_SOCKET.  Only took me two days to spot!

On Tue, Apr 6, 2021 at 8:13 PM Tom Cook <tom.k.cook@gmail.com> wrote:
>
> Can someone please suggest why the code below doesn't do as expected?
> I expect it to bind an AF_PACKET socket to an interface and receive
> packets with ethertype 0x5eeb that arrive at multicast MAC address
> 77:68:76:68:76:69 on that interface.  In practice, nothing arrives.
>
> If I comment out the call to bind(), it receives packets with
> ethertype 0x5eeb that are addressed to 77:68:76:68:76:69 and are
> received on any interface on the system, not just eth0.  (There are no
> packets with ethertype 0x5eeb sent to any other address, so this may
> be coincidence.)
>
> If I change either use of ether_type to be ETH_P_ALL instead (and
> re-instate the bind() call), then it receives all ethernet frames
> received on eth0.
>
> Is this a bug?  Or is it as expected and I have to use some other
> mechanism (BPF?) to filter the frames?
>
> Thanks for any assistance,
> Tom
>
> Code:
>
> #include <arpa/inet.h>
> #include <linux/if_packet.h>
> #include <sys/socket.h>
> #include <sys/ioctl.h>
> #include <net/if.h>
> #include <net/ethernet.h>
> #include <string.h>
> #include <stdio.h>
> #include <stdlib.h>
>
> const unsigned short eth_type = 0x5eeb;
>
> int main() {
>     int fd = socket(AF_PACKET, SOCK_RAW, htons(eth_type));
>     if (fd < 0) {
>         perror("socket");
>         exit(1);
>     }
>
>     struct ifreq ifr;
>     const char * if_name = "eth0";
>     size_t if_name_len = strlen (if_name);
>     memcpy(ifr.ifr_name, if_name, if_name_len);
>     ioctl(fd, SIOCGIFINDEX, &ifr);
>     printf("Interface has index %d\n", ifr.ifr_ifindex);
>
>     struct sockaddr_ll addr = {0};
>     addr.sll_family = AF_PACKET;
>     addr.sll_ifindex = ifr.ifr_ifindex;
>     addr.sll_protocol = htons(eth_type);
>     addr.sll_pkttype = PACKET_MULTICAST;
>     if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
>         perror("bind");
>         exit(1);
>     }
>
>     unsigned char mcast[ETH_ALEN] = {0x77, 0x68, 0x76, 0x68, 0x76, 0x69};
>     struct packet_mreq mreq = {0};
>     mreq.mr_ifindex = ifr.ifr_ifindex;
>     mreq.mr_type = PACKET_MR_MULTICAST;
>     memcpy(mreq.mr_address, mcast, ETH_ALEN);
>     mreq.mr_alen = ETH_ALEN;
>     if(setsockopt(fd, SOL_SOCKET, PACKET_ADD_MEMBERSHIP, &mreq,
> sizeof(mreq)) < 0) {
>         perror("setsockopt");
>         exit(1);
>     }
>
>     char buf [2048];
>     struct sockaddr_ll src_addr;
>     socklen_t src_addr_len = sizeof(src_addr);
>     ssize_t count = recvfrom(fd, buf, sizeof(buf), 0, (struct
> sockaddr*)&src_addr, &src_addr_len);
>     if (count == -1) {
>         perror("recvfrom");
>         exit(1);
>     } else {
>         printf("Received frame.\n");
>         printf("Dest MAC: ");
>         for (int ii = 0; ii < 5; ii++) {
>             printf("%02hhx:", buf[ii]);
>         }
>         printf("%02hhx\n", buf[5]);
>         printf("Src MAC: ");
>         for (int ii = 6; ii < 11; ii++) {
>             printf("%02hhx:", buf[ii]);
>         }
>         printf("%02hhx\n", buf[11]);
>     }
> }
>
> And here is a short Python3 programme to generate such frames (install
> pyroute2 package and run as `sudo python3 test.py eth0`):
>
> import socket
> from pyroute2 import IPDB
> import sys
> import struct
> import binascii
> import time
>
> ip = IPDB()
>
> SMAC=bytes.fromhex(ip.interfaces[sys.argv[1]]['address'].replace(':', ''))
> DMAC=bytes.fromhex('776876687669')
>
> s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
> s.bind((sys.argv[1], 0x5eeb))
> #s.bind((sys.argv[1], 0))
>
> dgram = struct.pack("!6s6sHH", DMAC, SMAC, 0x5eeb, 0x7668)
> print(' '.join('{:02x}'.format(x) for x in dgram))
>
> while True:
>     s.send(dgram)
>     time.sleep(0.1)
