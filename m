Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D477E182679
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 02:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgCLBG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 21:06:59 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:40244 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbgCLBG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 21:06:59 -0400
Received: by mail-qt1-f172.google.com with SMTP id n5so3104923qtv.7
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 18:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ev8lm5ygXnR686vqTntiRRz9gKv6J5FR+M1iqWBA41M=;
        b=hOQ0R8TKnuQa10mzEhoYmz33kSggAyFzn9vObHf0QsX/RKuGyrYq7gUUnf0m2X+nar
         nts+vpKqg1zhpxC6NdVH9ynAMOfxSYv9vj+g2yiPUh73cIhk9YgPTi+Q9pwIJnTFqtyW
         Qbr2tbKh+ZEaNhnbjd9cpcrzID7Tzwr+j9qEZnyWmwjffiXdwSW93JkKgu51iuYkX4P0
         PMmd1HugLjTaoAVaE+lrCqKhOYas/GWo/Yqdw1P0tMcuLZV0mRXbwLfWJOMd7CIknn+H
         NMyc0a+0t5bw8d6lx17dos/JZY3EXEa9PHQVZwCy+n9P7chsoig8zgi3I5Xl9tZ7xCdh
         O44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ev8lm5ygXnR686vqTntiRRz9gKv6J5FR+M1iqWBA41M=;
        b=fobimLm64v81tIR2vfdGzwtFRMkuaO4dqm5R4fpT3o1ZxD6faT5PW/2sAdORaytmkc
         pby5jNhiECaVWDqRCeH7n89yiBtnXCpx/N38vaJcdkiMSZwEOK1BFlYjeopD+cjineAm
         wJnTRMY7f1bPPjyqBzTXPYxDP+m0TLWnk/rWzL9FXv1G6zgTOIA9XDE2g251njicnYqy
         yXYZ3TxgWcbBC/hKVRl9UmQKjzMZB6OvRsPMKDCYPaUS+tmmqIj70Wx1ZSISAKW+Z4/X
         oKC89CyI9r4zylX54z9clFU1p4qqPTcbUIGSoBFiUXw7qhqNxuZW+K3KIsPwCRh8j5cC
         vV+Q==
X-Gm-Message-State: ANhLgQ1Rmabt41JsR5vB8Ob+G9z6ChtCk2CU9UncqKfDtA5gqDFhaNE1
        sV/KRVxGchWvZYRErKFu35hSdDCU
X-Google-Smtp-Source: ADFU+vsmHuGEyYIxydAUY1+x7a7EfeC6LkpDXnNkuRG+jTEW47snAYrpyfCQw9eQs/cvvHY3r9qWAg==
X-Received: by 2002:aed:2266:: with SMTP id o35mr5223491qtc.392.1583975217061;
        Wed, 11 Mar 2020 18:06:57 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5964:b1d3:d29b:6c68? ([2601:282:803:7700:5964:b1d3:d29b:6c68])
        by smtp.googlemail.com with ESMTPSA id o7sm8540961qtg.63.2020.03.11.18.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 18:06:56 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
Date:   Wed, 11 Mar 2020 19:06:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310204721.7jo23zgb7pjf5j33@topsnens>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 2:47 PM, Maximilian Bosch wrote:
> Hi!
> 
> I suspect I hit the same issue which is why I decided to respond to this
> thread (if that's wrong please let me know).
> 
>> sudo sysctl -a | grep l3mdev
>>
>> If not,
>> sudo sysctl net.ipv4.raw_l3mdev_accept=1
>> sudo sysctl net.ipv4.udp_l3mdev_accept=1
>> sudo sysctl net.ipv4.tcp_l3mdev_accept=1
> 
> On my system (NixOS 20.03, Linux 5.5.8) those values are set to `1`, but
> I experience the same issue.
> 
>> Since Kernel 5 though I am no longer able to update – but the issue is quite a curious one as some traffic appears to be fine (DNS lookups use VRF correctly) but others don’t (updating/upgrading the packages)
> 
> I can reproduce this on 5.4.x and 5.5.x. To be more precise, I suspect
> that only TCP traffic hangs in the VRF. When I try to `ssh` through the
> VRF, I get a timeout, but UDP traffic e.g. from WireGuard works just fine.
> 
> However, TCP traffic through a VRF works fine as well on 4.x (just tested this on
> 4.19.108 and 4.14.172).

functional test script under tools/testing/selftests/net covers VRF
tests and it ran clean for 5.4 last time I checked. There were a few
changes that went into 4.20 or 5.0 that might be tripping up this use
case, but I need a lot more information.

> 
> I use VRFs to enslave my physical uplink interfaces (enp0s31f6, wlp2s0).
> My main routing table has a default route via my WireGuard Gateway and I
> only route my WireGuard uplink through the VRF. With this approach I can
> make sure that all of my traffic goes through the VPN and only the
> UDP packets of WireGuard will be routed through the uplink network.

are you saying wireguard worked with VRF in the past but is not now?


> 
> As mentioned above, the WireGuard traffic works perfectly fine, but I
> can't access `<vpn-uplink>` via SSH:
> 
> ```
> $ ssh root@<vpn-uplink> -vvvv
> OpenSSH_8.2p1, OpenSSL 1.1.1d  10 Sep 2019
> debug1: Reading configuration data /home/ma27/.ssh/config
> debug1: /home/ma27/.ssh/config line 5: Applying options for *
> debug1: Reading configuration data /etc/ssh/ssh_config
> debug1: /etc/ssh/ssh_config line 5: Applying options for *
> debug2: resolve_canonicalize: hostname <vpn-uplink> is address
> debug1: Control socket "/home/ma27/.ssh/master-root@<vpn-uplink>:22" does not exist
> debug2: ssh_connect_direct
> debug1: Connecting to <vpn-uplink> [<vpn-uplink>] port 22.
> # Hangs here for a while
> ```
> 
> I get the following output when debugging this with `tcpdump`:
> 
> ```
> $ tcpdump -ni uplink tcp
> 20:06:40.409006 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], seq 4123706560, win 65495, options [mss 65495,sackOK,TS val 3798273519 ecr 0,nop,wscale 7], length 0
> 20:06:40.439699 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], seq 3289740891, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 1100235016 ecr 3798273519,nop,wscale 7], length 0
> 20:06:40.439751 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], seq 4123706561, win 0, length 0

that suggests not finding a matching socket, so sending a reset.

> 20:06:41.451871 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [S], seq 4123706560, win 65495, options [mss 65495,sackOK,TS val 3798274562 ecr 0,nop,wscale 7], length 0
> 20:06:41.484498 IP <vpn-uplink>.22 > 10.214.40.237.58928: Flags [S.], seq 3306036877, ack 4123706561, win 65160, options [mss 1460,sackOK,TS val 1100236059 ecr 3798274562,nop,wscale 7], length 0
> 20:06:41.484528 IP 10.214.40.237.58928 > <vpn-uplink>.22: Flags [R], seq 4123706561, win 0, length 0
> ```
> 
> AFAICS every SYN will be terminated with an RST which is the reason why
> the connection hangs.
> 
> I can work around the issue by using `ip vrf exec`. However I get the
> following error (unless I run `ulimit -l 2048`):
> 
> ```
> Failed to load BPF prog: 'Operation not permitted'
> ```

'ip vrf exec' loads a bpf program and that requires locked memory, so
yes, you need to increase it.

Let's start with lookups:

perf record -e fib:* -a -g
<run test that fails, ctrl-c>
perf script

That shows the lookups (inputs, table id, result) and context (stack
trace). That might give some context.
