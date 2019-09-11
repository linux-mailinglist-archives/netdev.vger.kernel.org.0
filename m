Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B275B0252
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfIKRCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 13:02:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53969 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728937AbfIKRCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 13:02:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id q18so4349017wmq.3
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 10:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m++32JIxc41aXRdT2B3EUO2/DOSEdcHwmUa6A7SORRk=;
        b=o0i3o6j/axRZvXg2BuAU+l8ryMJC4mnwIMVS/no+heoKb8ulDMtm+MtrGPdDAwnrlF
         3PPHQbP3IzNAswVTI4pwLqxZ6C5qXjKJ9W4ZHY25FLnRbkLBp2Rz+EfcpqHvofZl3Jf3
         F7S88LmJLRqU/TH3wGFZGLWnD+a/cvLhVTW0JuLl39B0fA8u91c3AO+4cPZKU9mkJ5WX
         7kVm+nhb1M2E+Jkpx09kSWH4tYakBGvwmACNCRFbuu9Dmd9PQ08Ug0xSQZUnBl/UZ5s/
         2xyciDRK9xljorVw4tt+H0FaHNQ1BvKux7wZL5dNOJmkthLIHD7rmPx7qCpTtcgd8iao
         DQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m++32JIxc41aXRdT2B3EUO2/DOSEdcHwmUa6A7SORRk=;
        b=EMOWreD8kHdYHXItI9EarVrGWtCiR9DlWA4QTEi21PS2tjXMZQFELkW+Qo9bfaDgt2
         CNOTeiYwqHQ/t1z1LUCMCdrh133Zn/y9/iScwqlfWJSVQtE4xFbpvRNZdjBMFEKaKnZa
         23w6hWrJxVe6nhPnZpdNrTOjDKEailpPBRIuFqjESRPSj5pyrcgriR/aYj7HzPH90Wvo
         yV7RkC0BeALNkATweuTqjnpJDqcHboDQDCaqcOrIvgTg2hPgmfY9nlTxdGpwBVbDg/3O
         k2Eq2ob77MVA/wrxVlpYi518gIrpLI/dkTDIEHvKoOxbkKVwMhmShonpebzlTtmgaNIP
         oUnQ==
X-Gm-Message-State: APjAAAURqrDrOi/IUAlHBRp0PHvJQ7ZoaM5xIx/GF9yfl5edmDQJ0wax
        PZmyWXWlpn+eKSAxjahbqtgtaz+6
X-Google-Smtp-Source: APXvYqwg0Bcy77bpHgqmNFFqWX/FeWQ95jx68bG+i6XNLSRJCjiN0L3xRnIPi2zM4cOlo6QHfbSS3g==
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr5026984wme.16.1568221323860;
        Wed, 11 Sep 2019 10:02:03 -0700 (PDT)
Received: from dahern-DO-MB.local ([148.69.85.38])
        by smtp.googlemail.com with ESMTPSA id h7sm3988385wmb.34.2019.09.11.10.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 10:02:02 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Gowen <gowen@potatocomputing.co.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b300235a-00f8-0689-8544-9db07cbd1e21@gmail.com>
Date:   Wed, 11 Sep 2019 18:02:01 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At LPC this week and just now getting a chance to process the data you sent.

On 9/9/19 8:46 AM, Gowen wrote:
> the production traffic is all in the 10.0.0.0/8 network (eth1 global VRF) except for a few subnets (DNS) which are routed out eth0 (mgmt-vrf)
> 
> 
> Admin@NETM06:~$ ip route show
> default via 10.24.12.1 dev eth0
> 10.0.0.0/8 via 10.24.12.1 dev eth1
> 10.24.12.0/24 dev eth1 proto kernel scope link src 10.24.12.9
> 10.24.65.0/24 via 10.24.12.1 dev eth0
> 10.25.65.0/24 via 10.24.12.1 dev eth0
> 10.26.0.0/21 via 10.24.12.1 dev eth0
> 10.26.64.0/21 via 10.24.12.1 dev eth0

interesting route table. This is default VRF but you have route leaking
through eth0 which is in mgmt-vrf.

> 
> 
> Admin@NETM06:~$ ip route show vrf mgmt-vrf
> default via 10.24.12.1 dev eth0
> unreachable default metric 4278198272
> 10.24.12.0/24 dev eth0 proto kernel scope link src 10.24.12.10
> 10.24.65.0/24 via 10.24.12.1 dev eth0
> 10.25.65.0/24 via 10.24.12.1 dev eth0
> 10.26.0.0/21 via 10.24.12.1 dev eth0
> 10.26.64.0/21 via 10.24.12.1 dev eth0

The DNS servers are 10.24.65.203 or 10.24.64.203 which you want to go
out mgmt-vrf. correct?

10.24.65.203 should hit the route "10.24.65.0/24 via 10.24.12.1 dev
eth0" for both default VRF and mgmt-vrf.

10.24.64.203 will NOT hit a route leak entry so traverse the VRF
associated with the context of the command (mgmt-vrf or default). Is
that intentional? (verify with: `ip ro get 10.24.64.203 fibmatch` and
`ip ro get 10.24.64.203 vrf mgmt-vrf fibmatch`)


> 
> 
> 
> The strange activity occurs when I enter the command “sudo apt update” as I can resolve the DNS request (10.24.65.203 or 10.24.64.203, verified with tcpdump) out eth0 but for the actual update traffic there is no activity:
> 
> 
> sudo tcpdump -i eth0 '(host 10.24.65.203 or host 10.25.65.203) and port 53' -n
> <OUTPUT OMITTED FOR BREVITY>
> 10:06:05.268735 IP 10.24.12.10.39963 > 10.24.65.203.53: 48798+ [1au] A? security.ubuntu.com. (48)
> <OUTPUT OMITTED FOR BREVITY>
> 10:06:05.284403 IP 10.24.65.203.53 > 10.24.12.10.39963: 48798 13/0/1 A 91.189.91.23, A 91.189.88.24, A 91.189.91.26, A 91.189.88.162, A 91.189.88.149, A 91.189.91.24, A 91.189.88.173, A 91.189.88.177, A 91.189.88.31, A 91.189.91.14, A 91.189.88.176, A 91.189.88.175, A 91.189.88.174 (256)
> 
> 
> 
> You can see that the update traffic is returned but is not accepted by the stack and a RST is sent
> 
> 
> Admin@NETM06:~$ sudo tcpdump -i eth0 '(not host 168.63.129.16 and port 80)' -n
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
> 10:17:12.690658 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [S], seq 2279624826, win 64240, options [mss 1460,sackOK,TS val 2029365856 ecr 0,nop,wscale 7], length 0
> 10:17:12.691929 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [S], seq 1465797256, win 64240, options [mss 1460,sackOK,TS val 3833463674 ecr 0,nop,wscale 7], length 0
> 10:17:12.696270 IP 91.189.88.175.80 > 10.24.12.10.40216: Flags [S.], seq 968450722, ack 2279624827, win 28960, options [mss 1418,sackOK,TS val 81957103 ecr 2029365856,nop,wscale 7], length 0                                                                                                                            
> 10:17:12.696301 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [R], seq 2279624827, win 0, length 0
> 10:17:12.697884 IP 91.189.95.83.80 > 10.24.12.10.52362: Flags [S.], seq 4148330738, ack 1465797257, win 28960, options [mss 1418,sackOK,TS val 2257624414 ecr 3833463674,nop,wscale 8], length 0                                                                                                                         
> 10:17:12.697909 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [R], seq 1465797257, win 0, length 0
> 
> 
> 
> 
> I can emulate the DNS lookup using netcat in the vrf:
> 
> 
> sudo ip vrf exec mgmt-vrf nc -u 10.24.65.203 53
> 

`ip vrf exec mgmt-vrf <COMMAND>` means that every IPv4 and IPv6 socket
opened by <COMMAND> is automatically bound to mgmt-vrf which causes
route lookups to hit the mgmt-vrf table.

Just running <COMMAND> (without binding to any vrf) means no socket is
bound to anything unless the command does a bind. In that case the
routing lookups determine which egress device is used.

Now the response comes back, if the ingress interface is a VRF then the
socket lookup wants to match on a device.

Now, a later response shows this for DNS lookups:

  isc-worker0000 20261 [000]  2215.013849: fib:fib_table_lookup: table
10 oif 0 iif 0 proto 0 0.0.0.0/0 -> 127.0.0.1/0 tos 0 scope 0 flags 0
==> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0
  isc-worker0000 20261 [000]  2215.013915: fib:fib_table_lookup: table
10 oif 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0
flags 4 ==> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0
  isc-worker0000 20261 [000]  2220.014006: fib:fib_table_lookup: table
10 oif 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0
flags 4 ==> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0

which suggests your process is passing off the DNS lookup to a local
process (isc-worker) and it hits the default route for mgmt-vrf when it
is trying to connect to a localhost address.

For mgmt-vrf I suggest always adding 127.0.0.1/8 to the mgmt vrf device
(and ::1/128 for IPv6 starting with 5.x kernels - I forget the exact
kernel version).

That might solve your problem; it might not.

(BTW: Cumulus uses fib rules for DNS servers to force DNS packets out
the mgmt-vrf interface.)
