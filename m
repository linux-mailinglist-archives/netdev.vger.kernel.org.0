Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305A05BE1B4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiITJQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiITJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:16:31 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD71EE2D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:16:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r18so4539491eja.11
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=v6Fmj83hx1h9EOaSFrL3lfhYXbz4XGnMveaMkf6jjPQ=;
        b=oWXQ6TZyU38Tt6B0tB5xoeC2txaV/i23+XquBsZIHUlTTdtqpu/uE5zzD2jzVvE+Vf
         WzCR1/U7ZsjhW8WtBnrtoJiP70wvf0AuxhL3i9qedEDUVGMWVGw4N9gRiiUDXYjS3++/
         4flXzd2anBcOIY2h7liTEQb2eNCop6Ymvn29azgWeIx4F8b7viSUyVrZ89YRgpSM35pU
         b4j5EA/AO4GanUxm7eAIIVGMfAWHXxpxTav64KglJnpoMOA3ALHlJpHHmpacUrTkl1po
         wY19mQYdyX7TiiTOKtCqM21IGN5fvYkzdlcnPb8kdOD4eD7PBvqDYiq3siRnzbUhf64t
         eENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=v6Fmj83hx1h9EOaSFrL3lfhYXbz4XGnMveaMkf6jjPQ=;
        b=llBqKpvHIL7Fug6Rhlnyve7q7efAF6i78Gvi+YqWWunnE6WTML2ToqA6DOjDSQc9jY
         9ygOt2Sbw2fC5VayrSs5SiPLvMcgfLseBxfwgLtulW0mh742nK5zN4O69Rl+SsF4F8Cx
         m33wcUoce7SZUriSP/H8KMHS8kmA2kLv2t9ABH99tn9OhcsqQ0Rv5BhHc48PJjWIzcTa
         L4MTImzzFZUBSiW9p0bfJRzBhdSlPeEcNmJS5RmelVxC+r8FlgBg36ttd07gSgGJNLMU
         CIdh7l7lS3EqHJDNr7MqAUlUwcbC9FALqxYri42bI67aR7FcN5ftlXDHfE63FV9Uj+iV
         WkhA==
X-Gm-Message-State: ACrzQf3qEUYvZnY/J2w44EeGVlxqRNM7CW9WtihsCDMHt7nK0EKM2Ig/
        UCQo+k8BgFf4cLrWsymcwY5LnQ==
X-Google-Smtp-Source: AMsMyM7b7VV/V1SL9IvuRs1rPa+v63PClIaBQ47XAmsdBXtP5r3aIFHV7tonD0iqESAjbN0/c5bXig==
X-Received: by 2002:a17:907:628f:b0:72f:58fc:3815 with SMTP id nd15-20020a170907628f00b0072f58fc3815mr16179909ejc.719.1663665387996;
        Tue, 20 Sep 2022 02:16:27 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u9-20020aa7d0c9000000b0043ba7df7a42sm912888edo.26.2022.09.20.02.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 02:16:27 -0700 (PDT)
Message-ID: <78bd0e54-4ee3-bd3c-2154-9eb8b9a70497@blackwall.org>
Date:   Tue, 20 Sep 2022 12:16:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC net-next 0/5] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, aroulin@nvidia.com,
        sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2022 23:17, Sevinj Aghayeva wrote:
> When bridge binding is enabled for a vlan interface, it is expected
> that the link state of the vlan interface will track the subset of the
> ports that are also members of the corresponding vlan, rather than
> that of all ports.
> 
> Currently, this feature works as expected when a vlan interface is
> created with bridge binding enabled:
> 
>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>         bridge_binding on
> 
> However, the feature does not work when a vlan interface is created
> with bridge binding disabled, and then enabled later:
> 
>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>         bridge_binding off
>   ip link set vlan10 type vlan bridge_binding on
> 
> After these two commands, the link state of the vlan interface
> continues to track that of all ports, which is inconsistent and
> confusing to users. This series fixes this bug and introduces two
> tests for the valid behavior.
> 
> Sevinj Aghayeva (5):
>   net: core: export call_netdevice_notifiers_info
>   net: core: introduce a new notifier for link-type-specific changes
>   net: 8021q: notify bridge module of bridge-binding flag change
>   net: bridge: handle link-type-specific changes in the bridge module
>   selftests: net: tests for bridge binding behavior
> 
>  include/linux/if_vlan.h                       |   4 +
>  include/linux/netdevice.h                     |   3 +
>  include/linux/notifier_info.h                 |  21 +++
>  net/8021q/vlan.h                              |   2 +-
>  net/8021q/vlan_dev.c                          |  20 ++-
>  net/bridge/br.c                               |   5 +
>  net/bridge/br_private.h                       |   7 +
>  net/bridge/br_vlan.c                          |  18 +++
>  net/core/dev.c                                |   7 +-
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>  11 files changed, 223 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/notifier_info.h
>  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> 

The set looks good to me, the bridge and vlan direct dependency is gone and
the new notification type is used for passing link type specific info.

If the others are ok with it I think you can send it as non-RFC, but I'd give it
a few more days at least. :)

Thanks,
 Nik

