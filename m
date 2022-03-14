Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D734D8A01
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbiCNQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbiCNQjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:39:24 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFE115A38
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:38:14 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b67so13244151qkc.6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b1iJxFkm/w4/onTlDY40QsChw60WC3EjtSdohCcuRK0=;
        b=XDUjrUHf4xFhE6hX+U+Sv0h5Qx76hvPmVpLbeyaOFtwImNJlJ+3LSB2hy7qIBtpQ4m
         4k1d5rhk1vuhtVhI1dt9o80ZrSQYbR4GsAHsByTHoiW2k4706KkmolSqq1fm4SjSEk4+
         vTyIctRfplywuvU6aKzwf4D2NZJ6gX4NWTF1QRbtdD7UBIVMG2ollrKkr8C3+oFzmiZB
         J3OdxTBKHCpCiVFslWgjhE/j+btsaIX/RvQs1Ri8CnuuVGDY9SZUZI2Yldqbnqinrbro
         pGpfQSRlBiiF1MGoebOjxX6fkI2OhcRSszXbmCioqZyAPWB6klStlaxn6RAGObeR5y3v
         0f+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b1iJxFkm/w4/onTlDY40QsChw60WC3EjtSdohCcuRK0=;
        b=4LSz3Z9PLspf3/gHTu+pGP/4QEG0sk87JzVWd+jh5BGhYUFo0CFgvwEUex7uMPEEaS
         PE/FGwalXYqOxKri8u3i37Ld4Rtu2sZ1HdWXAm+Pbv6DKKtdiXK/+EO/L0WXomdcTEYr
         Qfq5MlBm4FaLrCdNa1Nfv/1pl4xPqkaUVCYMuQ7qAHgSs0aZRRw2VnPyv4k5Ss+j6Htq
         TgjL9DjgV9hmCvqD2wJIwz8AterN+wsMWZpKH3y78OZ9ZdkUsa8inWinc0iXG/6nyVt5
         TwqDp4+Ym6Bls5dVshOBLdfJWAfQ3N3ZVOzyCqHloeiKU9lBzAAKnFsdu0vg0eFdSiAU
         yGbA==
X-Gm-Message-State: AOAM531am7ZH7aA8m9OF8dh1gnk8vY1W8OyEeCDVSXt/ewaLB/vBuplp
        9jOe2Bq+JliIHs5LZ23iQOlTeQ==
X-Google-Smtp-Source: ABdhPJyq2ay6WZt9dEmQNrjRDkCv5iRX1/BTnxXwn1xnMR2zwDNm2bYyMg420Rt+1jAiRCZUazmdvA==
X-Received: by 2002:a37:96c3:0:b0:67b:31d5:e1c3 with SMTP id y186-20020a3796c3000000b0067b31d5e1c3mr15178211qkd.465.1647275893133;
        Mon, 14 Mar 2022 09:38:13 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a051300b002dff3437923sm11441983qtx.11.2022.03.14.09.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:38:12 -0700 (PDT)
Message-ID: <ae876912-dda3-057c-ac29-c472ce94a8d0@mojatatu.com>
Date:   Mon, 14 Mar 2022 12:38:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [net-next v10 1/2] net: sched: use queue_mapping to pick tx queue
Content-Language: en-US
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
 <20220314141508.39952-2-xiangxia.m.yue@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220314141508.39952-2-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-14 10:15, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patch fixes issue:
> * If we install tc filters with act_skbedit in clsact hook.
>    It doesn't work, because netdev_core_pick_tx() overwrites
>    queue_mapping.
> 
>    $ tc filter ... action skbedit queue_mapping 1
> 
> And this patch is useful:
> * We can use FQ + EDT to implement efficient policies. Tx queues
>    are picked by xps, ndo_select_queue of netdev driver, or skb hash
>    in netdev_core_pick_tx(). In fact, the netdev driver, and skb
>    hash are _not_ under control. xps uses the CPUs map to select Tx
>    queues, but we can't figure out which task_struct of pod/containter
>    running on this cpu in most case. We can use clsact filters to classify
>    one pod/container traffic to one Tx queue. Why ?
> 
>    In containter networking environment, there are two kinds of pod/
>    containter/net-namespace. One kind (e.g. P1, P2), the high throughput
>    is key in these applications. But avoid running out of network resource,
>    the outbound traffic of these pods is limited, using or sharing one
>    dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
>    (e.g. Pn), the low latency of data access is key. And the traffic is not
>    limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
>    This choice provides two benefits. First, contention on the HTB/FQ Qdisc
>    lock is significantly reduced since fewer CPUs contend for the same queue.
>    More importantly, Qdisc contention can be eliminated completely if each
>    CPU has its own FIFO Qdisc for the second kind of pods.
> 
>    There must be a mechanism in place to support classifying traffic based on
>    pods/container to different Tx queues. Note that clsact is outside of Qdisc
>    while Qdisc can run a classifier to select a sub-queue under the lock.
> 
>    In general recording the decision in the skb seems a little heavy handed.
>    This patch introduces a per-CPU variable, suggested by Eric.
> 
>    The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
>    - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
>      is set in qdisc->enqueue() though tx queue has been selected in
>      netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
>      firstly in __dev_queue_xmit(), is useful:
>    - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
>      in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
>      For example, eth0, macvlan in pod, which root Qdisc install skbedit
>      queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
>      eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
>      because there is no filters in clsact or tx Qdisc of this netdev.
>      Same action taked in eth0, ixgbe in Host.
>    - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
>      in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
>      in __dev_queue_xmit when processing next packets.
> 
>    For performance reasons, use the static key. If user does not config the NET_EGRESS,
>    the patch will not be compiled.
> 
>    +----+      +----+      +----+
>    | P1 |      | P2 |      | Pn |
>    +----+      +----+      +----+
>      |           |           |
>      +-----------+-----------+
>                  |
>                  | clsact/skbedit
>                  |      MQ
>                  v
>      +-----------+-----------+
>      | q0        | q1        | qn
>      v           v           v
>    HTB/FQ      HTB/FQ  ...  FIFO
> 
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Kevin Hao <haokexin@gmail.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
