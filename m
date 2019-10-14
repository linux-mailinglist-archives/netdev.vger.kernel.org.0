Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09267D661F
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfJNPbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 11:31:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46974 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfJNPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 11:31:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so10573859pfg.13
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9oKl0MXzXfYFJXK/1h62AOMmwFAXy8ox9OCltlSZ/i8=;
        b=iRgXEmV5dlrctd9sOKaH7ep4iclKIA0fIWqS9zP76crmFyAgBeKjtbE92hixmnCSYG
         nesVpXnx48wU2dsLbRUwPtaacYf+HugT5T5qXuPJ+r1YTI34rgTu0EsOzRlzf2hGxYD0
         Hk+Nj3Y/lG0XayyyghtEMxsSjS7SP8kcTvJrv6cpoWZOqJPVIpTjPsUOVGfAmnxaITHG
         7QeYh91baylXK6Axbn9XQ6CPzB9XENLHYnurNgBR8hHGgncz+JBJO1vjNie90sfJYSzz
         RZB8YaypfiXIxysA7N1leWuesREmaW5gqcJL3lCPOuMOSyOwBrvhuDJJCtr4G2v4ZPvg
         b3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9oKl0MXzXfYFJXK/1h62AOMmwFAXy8ox9OCltlSZ/i8=;
        b=J8DItJXOUf+n6PGKoPKjV5+yVPXnnjtpT8AqzrWopx5cLw1ocazqkfmQQhH0iZhfyy
         NAYDoWgoalR674cPJHnoOvxtkoufdD4Ovf4uRL533PSHzn+KH7cEWL5ecq0AxDJevggD
         QpPLaP+71HNQFnR4so2d2jr+gvAS8c4lOohT+p9xtPuva7jCyerjE0QhuOyuC9waY1jU
         N+Ee+ZoiLSC6yGX6vtlrK36jxchk/P8YjdVZnqbpZ9J7SbTtBfdmU9CPI9iobONcNxMK
         jLnPe81T1jPrNSejMJGGC7xenma0YSJm1PweHGdWJzVViajGFQYTC6L9ZKsKCITNgOWa
         KMrQ==
X-Gm-Message-State: APjAAAXvfz+CqWu4Sme1ItcAhTC0F/ge3kkPaKeaeSY66k4icA3F5qKJ
        ciwO41PQawa7GEUn1Z7mB45bmuHF
X-Google-Smtp-Source: APXvYqwCsyxTkld68wyxaRFUoaj0fSl/Q+AbKBr9NmxkVbhaP+HQFdBL62THPTh28tHQdCbBcHIOfw==
X-Received: by 2002:aa7:870f:: with SMTP id b15mr32789004pfo.231.1571067095210;
        Mon, 14 Oct 2019 08:31:35 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w2sm20589172pfn.57.2019.10.14.08.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 08:31:33 -0700 (PDT)
Subject: Re: AW: big ICMP requests get disrupted on IPSec tunnel activation
To:     "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <EB8510AA7A943D43916A72C9B8F4181F629D9741@cvk038.intra.cvk.de>
 <d0c8ebbb-3ed3-296f-d84a-6f88e641b404@gmail.com>
 <EB8510AA7A943D43916A72C9B8F4181F629DD75A@cvk038.intra.cvk.de>
 <EB8510AA7A943D43916A72C9B8F4181F62A0774F@cvk038.intra.cvk.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e306f521-6d1e-837f-6cc6-8badb56e014c@gmail.com>
Date:   Mon, 14 Oct 2019 08:31:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <EB8510AA7A943D43916A72C9B8F4181F62A0774F@cvk038.intra.cvk.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/19 7:02 AM, Bartschies, Thomas wrote:
> Hello,
> 
> it took a while to build a testsystem for bisecting the issue. Finally I've identified the patch that causes my problems.
> BTW. The fq packet network scheduler is in use.
> 
> It's 
> [PATCH net-next] tcp/fq: move back to CLOCK_MONOTONIC
> 
> In the recent TCP/EDT patch series, I switched TCP and sch_fq clocks from MONOTONIC to TAI, in order to meet the choice done
> earlier for sch_etf packet scheduler.
> 
> But sure enough, this broke some setups were the TAI clock jumps forward (by almost 50 year...), as reported by Leonard Crestez.
> 
> If we want to converge later, we'll probably need to add an skb field to differentiate the clock bases, or a socket option.
> 
> In the meantime, an UDP application will need to use CLOCK_MONOTONIC base for its SCM_TXTIME timestamps if using fq 
> packet scheduler.
> 
> Fixes: 72b0094f9182 ("tcp: switch tcp_clock_ns() to CLOCK_TAI base")
> Fixes: 142537e41923 ("net_sched: sch_fq: switch to CLOCK_TAI")
> Fixes: fd2bca2aa789 ("tcp: switch internal pacing timer to CLOCK_TAI")
> Signed-off-by: Eric Dumazet <edumazet@xxxxxxxxxx>
> Reported-by: Leonard Crestez <leonard.crestez@xxxxxxx>
> 
> ----
> 
> After reverting it in a current 5.2.18 kernel, the problem disappears. There were some post fixes for other issues caused by this
> patch. These fixed other similar issues, but not mine. I've already tried to set the tstamp to zero in xfrm4_output.c, but with no
> luck so far. I'm pretty sure, that reverting the clock patch isn't the proper solution for upstream. So I what other way this can
> be fixed?


Thanks a lot Thomas for this report !

I guess you could add a debug check in fq to let us know the call graph.

Something like the following :

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 98dd87ce15108cfe1c011da44ba32f97763776c8..2aa41a39e81b94f3b7092dc51b91829f5929634d 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -380,9 +380,14 @@ static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
 {
        struct rb_node **p, *parent;
        struct sk_buff *head, *aux;
+       s64 delay;
 
        fq_skb_cb(skb)->time_to_send = skb->tstamp ?: ktime_get_ns();
 
+       /* We should really add a TCA_FQ_MAX_HORIZON  at some point :( */
+       delay = fq_skb_cb(skb)->time_to_send - ktime_get_ns();
+       WARN_ON_ONCE(delay > 60 * NSEC_PER_SEC);
+
        head = flow->head;
        if (!head ||
            fq_skb_cb(skb)->time_to_send >= fq_skb_cb(flow->tail)->time_to_send) {


> 
> ---
> [PATCH net] net: clear skb->tstamp in bridge forwarding path
> Matteo reported forwarding issues inside the linux bridge, if the enslaved interfaces use the fq qdisc.
> 
> Similar to commit 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths"), we need to clear the tstamp field in
> the bridge forwarding path.
> 
> Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Reported-and-tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> and
> 
> net: clear skb->tstamp in forwarding paths
> 
> Sergey reported that forwarding was no longer working if fq packet scheduler was used.
> 
> This is caused by the recent switch to EDT model, since incoming packets might have been timestamped by __net_timestamp()
> 
> __net_timestamp() uses ktime_get_real(), while fq expects packets using CLOCK_MONOTONIC base.
> 
> The fix is to clear skb->tstamp in forwarding paths.
> 
> Fixes: 80b14dee ("net: Add a new socket option for a future transmit time.")
> Fixes: fb420d5d ("tcp/fq: move back to CLOCK_MONOTONIC")
> Signed-off-by: default avatarEric Dumazet <edumazet@google.com>
> Reported-by: default avatarSergey Matyukevich <geomatsi@gmail.com>
> Tested-by: default avatarSergey Matyukevich <geomatsi@gmail.com>
> Signed-off-by: default avatarDavid S. Miller <davem@davemloft.net>
> 
> Best regards,
> --
> Thomas Bartschies
> CVK IT Systeme
> 
> 
> -----Ursprüngliche Nachricht-----
> Von: Bartschies, Thomas 
> Gesendet: Dienstag, 17. September 2019 09:28
> An: 'David Ahern' <dsahern@gmail.com>; 'netdev@vger.kernel.org' <netdev@vger.kernel.org>
> Betreff: AW: big ICMP requests get disrupted on IPSec tunnel activation
> 
> Hello,
> 
> thanks for the suggestion. Running pmtu.sh with kernel versions 4.19, 4.20 and even 5.2.13 made no difference. All tests were successful every time.
> 
> Although my external ping tests still failing with the newer kernels. I've ran the script after triggering my problem, to make sure all possible side effects happening. 
> 
> Please keep in mind, that even when the ICMP requests stalling, other connections still going through. Like e.g. ssh or tracepath. I would expect that all connection types would be affected if this is a MTU problem. Am I wrong?
> 
> Any suggestions for more tests to isolate the cause? 
> 
> Best regards,
> --
> Thomas Bartschies
> CVK IT Systeme
> 
> -----Ursprüngliche Nachricht-----
> Von: David Ahern [mailto:dsahern@gmail.com]
> Gesendet: Freitag, 13. September 2019 19:13
> An: Bartschies, Thomas <Thomas.Bartschies@cvk.de>; 'netdev@vger.kernel.org' <netdev@vger.kernel.org>
> Betreff: Re: big ICMP requests get disrupted on IPSec tunnel activation
> 
> On 9/13/19 9:59 AM, Bartschies, Thomas wrote:
>> Hello together,
>>
>> since kenel 4.20 we're observing a strange behaviour when sending big ICMP packets. An example is a packet size of 3000 bytes.
>> The packets should be forwarded by a linux gateway (firewall) having multiple interfaces also acting as a vpn gateway.
>>
>> Test steps:
>> 1. Disabled all iptables rules
>> 2. Enabled the VPN IPSec Policies.
>> 3. Start a ping with packet size (e.g. 3000 bytes) from a client in 
>> the DMZ passing the machine targeting another LAN machine 4. Ping 
>> works 5. Enable a VPN policy by sending pings from the gateway to a 
>> tunnel target. System tries to create the tunnel 6. Ping from 3. immediately stalls. No error messages. Just stops.
>> 7. Stop Ping from 3. Start another without packet size parameter. Stalls also.
>>
>> Result:
>> Connections from the client to other services on the LAN machine still 
>> work. Tracepath works. Only ICMP requests do not pass the gateway 
>> anymore. tcpdump sees them on incoming interface, but not on the outgoing LAN interface. IMCP requests to any other target IP address in LAN still work. Until one uses a bigger packet size. Then these alternative connections stall also.
>>
>> Flushing the policy table has no effect. Flushing the conntrack table has no effect. Setting rp_filter to loose (2) has no effect.
>> Flush the route cache has no effect.
>>
>> Only a reboot of the gateway restores normal behavior.
>>
>> What can be the cause? Is this a networking bug?
>>
> 
> some of these most likely will fail due to other reasons, but can you run 'tools/testing/selftests/net/pmtu.sh'[1] on 4.19 and then 4.20 and compare results. Hopefully it will shed some light on the problem and can be used to bisect to a commit that caused the regression.
> 
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/net/pmtu.sh
> 
