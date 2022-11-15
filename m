Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2700E62AEA9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiKOWw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKOWw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:52:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C0539D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:52:57 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s196so14952770pgs.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G4PYGIy6iZhzmsVgcd/gTIzh9xG2CHq2q/zJTOQ/8Ac=;
        b=Zi1iIhx3fHQJl7uJRulOKDQB5+SRGtIFtBUnC8f4F3PPj+8Hky3yZjHf66Hecdn5wz
         lEu852kYpuwX+NH5+3Lb/YUUSPtPLyX4yi5LzW/jGRN7lDeS8gRfW+1Hv2Up0N4oKCcr
         XCHM1PbaZZpZUC35ca5aY1yWH/YsF+4TtYqRgE3Dtxve2RzPQkAke4kVPeDH9c7/t4Nj
         X/YLD/0J3E0KccpwaAkoahAaMuZHFYIfiGBLLYLyVSTaYVGb4D4ZcSL6ts/ZE++PP7z0
         D9mK+1f7WAPRttAqCRPAXGJsvG7JkUktUr+HGw3Zz5WHAuGWevWxR0GEZD1B44o8ALq3
         xv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4PYGIy6iZhzmsVgcd/gTIzh9xG2CHq2q/zJTOQ/8Ac=;
        b=T27nxEelNgvCajd3HzgsxpsLYkDpIr+9OEyZIllJF6gjE0bJEg6boczbCY3Zwz4LXJ
         p1T/cZFpL7LUWzBJ/IPiGLDggJr5L9AHysF9gC2dH6gnwwxilNGyWHIjzH90q94QyJaP
         VgSbaIxcZE+knOpgax9Kwl+f438IPJukqgpqrGICIcngRAaEGrXezrA5D44xoHIIgNXm
         SkfKqO0q20LBnhvEu0NIzFPIURVHDBfN04w0DJVD2Pooy4ktRPSVYa4U7KLetF0uGhQW
         dyzboAdq6xCsiyrEg0AABuRPvjlYAqfkbaJrHAul3QUZyfIM479tFRR4nM5hqua7qWkX
         Z1ZA==
X-Gm-Message-State: ANoB5pmeo70UQyskrCxqHfb3xZIY0XLXbSRwmGbPtyuKklakN5sqMc+N
        RHzfWsa8TC6yuQfit2FUqEAc2PNWwWdruQ==
X-Google-Smtp-Source: AA0mqf5yTEVN5s2qydzwY8oTrIVRVmittZ/vIQ79MD8A7v/DUbBmBu4YaZeRdRxeVZhjHPgsjsVj9w==
X-Received: by 2002:a63:5f0b:0:b0:476:d44d:355 with SMTP id t11-20020a635f0b000000b00476d44d0355mr2399469pgb.289.1668552776385;
        Tue, 15 Nov 2022 14:52:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 73-20020a62194c000000b0056ded8d5918sm9301675pfz.134.2022.11.15.14.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 14:52:55 -0800 (PST)
Message-ID: <21a88fb8-c1a0-a901-3ba0-606ecb4a723d@gmail.com>
Date:   Tue, 15 Nov 2022 14:52:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: don't leak tagger-owned storage on switch
 driver unbind
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114143551.1906361-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 06:35, Vladimir Oltean wrote:
> In the initial commit dc452a471dba ("net: dsa: introduce tagger-owned
> storage for private and shared data"), we had a call to
> tag_ops->disconnect(dst) issued from dsa_tree_free(), which is called at
> tree teardown time.
> 
> There were problems with connecting to a switch tree as a whole, so this
> got reworked to connecting to individual switches within the tree. In
> this process, tag_ops->disconnect(ds) was made to be called only from
> switch.c (cross-chip notifiers emitted as a result of dynamic tag proto
> changes), but the normal driver teardown code path wasn't replaced with
> anything.
> 
> Solve this problem by adding a function that does the opposite of
> dsa_switch_setup_tag_protocol(), which is called from the equivalent
> spot in dsa_switch_teardown(). The positioning here also ensures that we
> won't have any use-after-free in tagging protocol (*rcv) ops, since the
> teardown sequence is as follows:
> 
> dsa_tree_teardown
> -> dsa_tree_teardown_master
>     -> dsa_master_teardown
>        -> unsets master->dsa_ptr, making no further packets match the
>           ETH_P_XDSA packet type handler
> -> dsa_tree_teardown_ports
>     -> dsa_port_teardown
>        -> dsa_slave_destroy
>           -> unregisters DSA net devices, there is even a synchronize_net()
>              in unregister_netdevice_many()
> -> dsa_tree_teardown_switches
>     -> dsa_switch_teardown
>        -> dsa_switch_teardown_tag_protocol
>           -> finally frees the tagger-owned storage
> 
> Fixes: 7f2973149c22 ("net: dsa: make tagging protocols connect to individual switches from a tree")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

