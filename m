Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E0550DE95
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiDYLRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241784AbiDYLRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:17:37 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 392F93137E;
        Mon, 25 Apr 2022 04:14:32 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 415491E80D78;
        Mon, 25 Apr 2022 19:11:26 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YXA5B4jbnLbT; Mon, 25 Apr 2022 19:11:23 +0800 (CST)
Received: from [18.165.124.109] (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 16C8A1E80D76;
        Mon, 25 Apr 2022 19:11:23 +0800 (CST)
Message-ID: <2822d906-6006-2530-eca8-f4c398a1357d@nfschina.com>
Date:   Mon, 25 Apr 2022 19:14:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
To:     Sven Eckelmann <sven@narfation.org>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pabeni@redhat.com, sw@simonwunderlich.de
References: <3537486.13E77TLkhO@ripper>
From:   yuzhe <yuzhe@nfschina.com>
In-Reply-To: <3537486.13E77TLkhO@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for your reply, we have fixed our mail server. And I'll correct and resubmit my patch.

在 2022/4/22 15:55, Sven Eckelmann 写道:

> Hi,
>
> we neither received your mail via the mailing list nor our private mail
> servers. It seems your mail setup is broken:
>
>      Apr 21 15:48:37 dvalin postfix/smtpd[10256]: NOQUEUE: reject: RCPT from unknown[2400:dd01:100f:2:72e2:84ff:fe10:5f45]: 450 4.7.1 <ha.nfschina.com>: Helo command rejected: Host not found; from=<yuzhe@nfschina.com> to=<sven@narfation.org> proto=ESMTP helo=<ha.nfschina.co>
>
>
> And when I test it myself, it is also not working:
>
>      $ dig @8.8.8.8 ha.nfschina.com
>
>      ; <<>> DiG 9.16.27-Debian <<>> @8.8.8.8 ha.nfschina.com
>      ; (1 server found)
>      ;; global options: +cmd
>      ;; Got answer:
>      ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 39639
>      ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
>      
>      ;; OPT PSEUDOSECTION:
>      ; EDNS: version: 0, flags:; udp: 512
>      ;; QUESTION SECTION:
>      ;ha.nfschina.com.               IN      A
>      
>      ;; AUTHORITY SECTION:
>      nfschina.com.           600     IN      SOA     dns11.hichina.com. hostmaster.hichina.com. 2022011002 3600 1200 86400 600
>
>      ;; Query time: 328 msec
>      ;; SERVER: 8.8.8.8#53(8.8.8.8)
>      ;; WHEN: Fri Apr 22 09:51:56 CEST 2022
>      ;; MSG SIZE  rcvd: 105
>
>
> Please fix this before sending patches out.
>
>
> But the kernel test bot already demonstrated why this patch is not a good
> idea. You can improve it and resent it but I will not accept it in this form.
>
>
> Kind regards,
> 	Sven
