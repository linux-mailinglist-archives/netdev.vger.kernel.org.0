Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7C145B3C
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAVR6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:58:31 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35533 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVR6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:58:31 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so249602pjc.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5mdPLsw2X4SR6EReR+UAveAygx6hIdFiD69QjtVoZKQ=;
        b=0KR9gIZw/GYV+2DWH9ZExLYccopN3DIR6ooHBMVOZ2Q2mYpcjiVpw01IwT6jqansIc
         wNNbJb4THfWN8FMxfG0xJXCGHG0z/6Du7aj34KM8rKZoGZg+6XLwDJN5hYmylRojgcVd
         GbGcS9Xloe3kqplQeo4TEe4CdEblnRzvx9O3t73ID9zc3yAKamxCk9BbVwmGh0p/A4Qu
         fwH6ouWsxSsFXSIdazl1Ni6cgamLaaVWmkQC+HMWx5BJJksIfu1WzKwySVIIkxoZZDDg
         LL/lBcnspbcnJ/we7CDkhisqOkX5Ps/HZsprxTIuWZRXYW8+6m8SaQ5Jp6hVN+sWoy8F
         ZGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5mdPLsw2X4SR6EReR+UAveAygx6hIdFiD69QjtVoZKQ=;
        b=NREmWfjAn+1DVQsGv16d1yNyRy91eBgW3Kbu8F3AvQylNPxHP2fHa5p0KsQzMWFtG0
         VNukf+ZS1pppfnDJi1lkdcL3SYKJySsxCe+f+tBLGyrKe7tiNz84uVpR/ry4lfUYTT8r
         Jj+J1zyo9dEmQl5+dETE2wwNLkw6uEPPF7HMKuMmI57tIsu4ltdNC4OrWpvWLYA/A0Od
         w3/bw6uAja7Ng3CWpqQ5OfGYSICu+KxbWuW5fJJKEYO7hsY1vzoa2BlcQ5g1g58aHQpX
         nq+CquBLeDRjusveHXNuxqK2uypuvGYA8c+7qZidmp0z/lrhAwXzfwEhRQeHXIOKBQFT
         enow==
X-Gm-Message-State: APjAAAW9m0dy9chcN4tXW2olV7mZsyl9rTfzK3VqXeJhv7HzZYBpZ2+Z
        1a1R1vpvt+f6WHhRYcFLcrWF1xoDurU=
X-Google-Smtp-Source: APXvYqxnq1o/NtZcVlGuP7iXuTijs//zN6q3vlKRv8Ibc261f4acOeIFKm5of/drOk7CnaiO6gUehQ==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr4384565pjr.22.1579715910291;
        Wed, 22 Jan 2020 09:58:30 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h6sm30874584pfo.175.2020.01.22.09.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 09:58:29 -0800 (PST)
Date:   Wed, 22 Jan 2020 09:58:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 206281] New: Problem in IPsec route
Message-ID: <20200122095826.09b3ce3e@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 22 Jan 2020 14:34:49 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206281] New: Problem in IPsec route


https://bugzilla.kernel.org/show_bug.cgi?id=206281

            Bug ID: 206281
           Summary: Problem in IPsec route
           Product: Networking
           Version: 2.5
    Kernel Version: 3.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: brunopsitech@gmail.com
        Regression: No

I have a problem that seems to be IPSec routing. I am using a Centos 7.6 and
Libreswan 3.25. I have a closed VPN with a CheckPoint, where everything is
established, the package leaves my network and goes to the destination network
and when returning, Linux discards or does not route the package back, it
arrives and is discarded, but I can't find where . Does anyone have any ideas.

[root@firewall log]# tcpdump -i p3p2 esp

08:45:01.469829 IP XXX.5 > XXX.4: ESP(spi=0x673291bf,seq=0x5ae), length 92
08:45:01.510735 IP XXX.4 > XXX.5: ESP(spi=0xe28a2895,seq=0x5ae), length 92
08:45:04.289129 IP XXX.5 > XXX.4: ESP(spi=0x673291bf,seq=0x5af), length 116
08:45:04.329507 IP XXX.4 > XXX.5: ESP(spi=0xe28a2895,seq=0x5af), length 116
08:45:05.290342 IP XXX.5 > XXX.4: ESP(spi=0x673291bf,seq=0x5b0), length 116
08:45:05.328562 IP XXX.4 > XXX.5: ESP(spi=0xe28a2895,seq=0x5b0), length 116
08:45:06.291074 IP XXX.5 > XXX.4: ESP(spi=0x673291bf,seq=0x5b1), length 116
08:45:06.329088 IP XXX.4 > XXX.5: ESP(spi=0xe28a2895,seq=0x5b1), length 116

[root@firewall log]# ip xfrm policy
src 192.168.70.0/24 dst 10.20.0.0/24
        dir out priority 1042407 ptype main
        tmpl src XXX.5 dst XXX.4
                proto esp reqid 16393 mode tunnel
src 10.20.0.0/24 dst 192.168.70.0/24
        dir fwd priority 1042407 ptype main
        tmpl src XXX.4 dst XXX.5
                proto esp reqid 16393 mode tunnel
src 10.20.0.0/24 dst 192.168.70.0/24
        dir in priority 1042407 ptype main
        tmpl src XXX.4 dst XXX.5
                proto esp reqid 16393 mode tunnel

[root@firewall log]# ip xfrm state
src XXX.4 dst XXX.5
        proto esp spi 0xe28a2895 reqid 16393 mode tunnel
        replay-window 32 flag af-unspec
        auth-trunc hmac(sha1) 0x5735c07f9cf22f8953169d4d892aab3d837413c7 96
        enc cbc(des3_ede) 0x4c85d5d5e9fec7c7d3a98e52c89ecd530262e40ab81e1847
        anti-replay context: seq 0x5ba, oseq 0x0, bitmap 0xfffeffff
src XXX.5 dst XXX.4
        proto esp spi 0x673291bf reqid 16393 mode tunnel
        replay-window 32 flag af-unspec
        auth-trunc hmac(sha1) 0xddbec1fd0caac8c95de21e51d50eab409c15552f 96
        enc cbc(des3_ede) 0x6a0414dd357c9df601edcdfb461c73fa428ed41e1e40c6fc
        anti-replay context: seq 0x0, oseq 0x5ba, bitmap 0x00000000


# ipsec status

000 #1: "VPN":500 STATE_MAIN_I4 (ISAKMP SA established); EVENT_SA_EXPIRE in
164s; newest ISAKMP; lastdpd=-1s(seq in:0 out:0); idle; import:admin initiate
000 #2: "VPN":500 STATE_QUICK_I2 (sent QI2, IPsec SA established);
EVENT_SA_EXPIRE in 164s; newest IPSEC; eroute owner; isakmp#1; idle;
import:admin initiate
000 #2: "VPN" esp.673291bf@XXX.4 esp.e28a2895@XXX.5 tun.0@XXX.4 tun.0@XXX.5
ref=0 refhim=0 Traffic: ESPin=119KB ESPout=119KB! ESPmax=4194303B

# ipsec.conf
conn    VPN
        auto=start
        ikev2=no
        pfs=yes
        rekey=no
        authby=secret
        type=tunnel
        salifetime=28800
        ikelifetime=28800
        ike=3des-sha1;modp1024
        phase2=esp
        phase2alg=3des-sha1;modp1024
        left=XXX.5
        leftsubnet=192.168.70.0/24
        leftsourceip=XXX.5
        right=XXX.4
        rightsubnet=10.20.0.0/24
        rightsourceip=XXX.4

I run a tcpdump in ip_vti0 interface of VPN, and i recive the package right
back, but for some reason the package dont arrive in lan interface of firewall,
i already clean up every rule of netfilter and nothing

I put a LOG in netfilter and i recive the follow log

[36651.164496] VPN INPUT FW: IN=ip_vti0 OUT= MAC= SRC=10.20.0.100 DST=XXX.4
LEN=84 TOS=0x00 PREC=0x00 TTL=253 ID=36963 DF PROTO=ICMP TYPE=0 CODE=0 ID=911
SEQ=2


The Linux dont must put a OUT=LAN_interface ?

The problem is, the package return in interface ip_vti0 but not forward to LAN
network, and i dont have any netfilter rule

-- 
You are receiving this mail because:
You are the assignee for the bug.
