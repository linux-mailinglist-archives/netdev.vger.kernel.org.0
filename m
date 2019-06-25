Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38A155190
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbfFYOYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:24:18 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51462 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730019AbfFYOYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:24:17 -0400
Received: by mail-wm1-f50.google.com with SMTP id 207so3064141wma.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TeUjgBwgJ9iMSzTQ1lt+AyZnR9g9BOEHzmsZ4nUkRag=;
        b=sXWoKy77Nw74hxskTUMHtjTiMginSrzo5gGVT83a4c+2LuDIfVx4VZ8uoAMLE/DwIw
         Jh3zjTM4nop4eulay0xUXM8SWrHVVqMu55VmRlFGFIN+2AkTqWMKUiVdkdzwl9pPxUuo
         N0bs393lcWlCVebT5Alts4X4yW4aUzVPwZS+wa22OCVJeTRBIFzkJO+kY+IArBR5e0Lc
         qSByXwqQf1uoeca2le5m6OTPiYHTScujcqL++BZik/e4aCNdlxHgvm6UqqS2l5iwqM5O
         lAe9hfAX7mBFBltqll1/BBXnKtK0O8ikuo7kCgzMaLqaLFxCBovU+iiYx/9xehv/zq46
         QGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TeUjgBwgJ9iMSzTQ1lt+AyZnR9g9BOEHzmsZ4nUkRag=;
        b=XdrrTtu4+XvudYu7Rd8ZnpgGT108rLkt4EfdtJ5K9jgWRT/G9zzfSBp5rriupB+vN6
         ygQGNJgtSFspc5IBD7mvCIG+SBB8PsFvwuZf30PeaPipqU+8JLUQvcj8RudiesaEndGH
         tCQTKPFeO7Psc2yfnUDtiZpVUfraDksIXIiV8noSLBe/axVeo83ADJ+dWMwXg3QE+Iki
         zTYyRcXOfOq5ZEfEaNhapiDU4ype71vQ1bsHp46xmeT/VAcViuZVcr7Ku/nJhE5ZuGLc
         j2v02L4bmLU+rgjOTSEwnYguCTr3mnvK7DVlrjAS3+7ByBoqxWTT/EDiBbu21L3uocnq
         Khfg==
X-Gm-Message-State: APjAAAWCF6v/FFdOBTievSH1YcVlqGJv1HFFHpYA1JyDEdNkK9xe9yhe
        qjHeGGRUZSdad1nJyziyvi1u+UbQ
X-Google-Smtp-Source: APXvYqzCPXjGdZa6/Wjo/rhQbJ6JvLmRdqoNCBJsAIAKNpaT0lEegusXrZ7hBTIRQnlF/i/utEtkiA==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr19152897wmb.32.1561472656454;
        Tue, 25 Jun 2019 07:24:16 -0700 (PDT)
Received: from [192.168.8.147] (104.84.136.77.rev.sfr.net. [77.136.84.104])
        by smtp.gmail.com with ESMTPSA id n1sm11238247wrx.39.2019.06.25.07.24.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 07:24:15 -0700 (PDT)
Subject: Re: Warnings generated from tcp_sacktag_write_queue.
To:     Chinmay Agarwal <chinagar@codeaurora.org>, netdev@vger.kernel.org
Cc:     sharathv@codeaurora.org, kapandey@codeaurora.org
References: <20190625130706.GA6891@chinagar-linux.qualcomm.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ab6bb900-e9b7-f2b2-0a56-d1c9e14d2db6@gmail.com>
Date:   Tue, 25 Jun 2019 16:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625130706.GA6891@chinagar-linux.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 6:07 AM, Chinmay Agarwal wrote:
> Dear All,
> 
> We are hitting the following WARN_ON condition:
> 
> 	WARN_ON((int)tcp_packets_in_flight(tp) < 0);
> 
> 	tcp_packets_in_flight =  packets_out –( lost_out +
> 	sacked_out ) + retrans_out  (This value is coming -ve)
> 
> The tcp socket being used is in fin_wait_1 state.
> The values for variables just before the crash:
> packets_out = 0,
> retrans_out = 28,
> lost_out = 38,
> sacked_out = 8
> 
> 
> The only place I can find the packets_out value being set as 0 is:
> 
> void tcp_write_queue_purge(struct sock *sk)
> {
> ...
> 
> 	tcp_sk(sk)->packets_out = 0;
>         inet_csk(sk)->icsk_backoff = 0;
> }
> 
> Is there some code flow where packets_out can be set to 0 and other
> values can remain unchanged?
> If not, is there some scenario which may lead to "tcp_write_queue_purge"
> called and not followed up by "tcp_clear_retrans"?
> 
> According to my understanding we should call "tcp_clear_retrans" after
> setting packets_out to 0.
> 
> [ 1950.556150] Call trace:
> [ 1950.558689] tcp_sacktag_write_queue+0x704/0x72c
> [ 1950.561313] init: Untracked pid 10745 exited with status 0
> [ 1950.563441] tcp_ack+0x3a4/0xd40
> [ 1950.563447] tcp_rcv_state_process+0x1e8/0xbbc
> [ 1950.563457] tcp_v4_do_rcv+0x18c/0x1cc
> [ 1950.563461] tcp_v4_rcv+0x84c/0x8a8
> [ 1950.563471] ip_protocol_deliver_rcu+0xdc/0x190
> [ 1950.563474] ip_local_deliver_finish+0x64/0x80
> [ 1950.563479] ip_local_deliver+0xc4/0xf8
> [ 1950.563482] ip_rcv_finish+0x214/0x2e0
> [ 1950.563486] ip_rcv+0x2fc/0x39c
> [ 1950.563496] __netif_receive_skb_core+0x698/0x84c
> [ 1950.563499] __netif_receive_skb+0x3c/0x7c
> [ 1950.563503] process_backlog+0x98/0x148
> [ 1950.563506] net_rx_action+0x128/0x388
> [ 1950.563519] __do_softirq+0x20c/0x3f0
> [ 1950.563528] irq_exit+0x9c/0xa8
> [ 1950.563536] handle_IPI+0x174/0x278
> [ 1950.563540] gic_handle_irq+0x124/0x1c0
> [ 1950.563544] el1_irq+0xb4/0x12c
> [ 1950.563556] lpm_cpuidle_enter+0x3f4/0x430
> [ 1950.563561] cpuidle_enter_state+0x124/0x25c
> [ 1950.563565] cpuidle_enter+0x30/0x40
> [ 1950.563575] call_cpuidle+0x3c/0x60
> [ 1950.563579] do_idle+0x190/0x228
> [ 1950.563583] cpu_startup_entry+0x24/0x28
> [ 1950.563588] secondary_start_kernel+0x12c/0x138
> 


You do not provide what exact kernel version you are using,
this is probably the most important information we need.


