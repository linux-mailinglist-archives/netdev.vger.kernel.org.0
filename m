Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72558EEC5
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiHJOun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiHJOum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:50:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA615E306
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:50:38 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e13so19355387edj.12
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=r4FpLYfUs7tX4DLeiy0sj/1t8j21OoA6g793iTCGiF8=;
        b=MuyQbiTUTET9fzrBqJrVL6Ql0nSXUtWfMkTeV0mBDzSdpEipm6LSkDAk2TRRbHhcFY
         wVXtGIvSLp1zX+ayyhX9X9Vs+G2gYlKwvu7a0380tbAKcuP1OMT0qzWuHj78nZ6s+5MV
         t7/FErcC+guIKzh+XsumAfNKFOBs5o98HzCcm86P6Pb7sPlqjHuwEAFyORUJ/mWGU2Q4
         tMlLXdYAJp+1RoMLB7y3vb09dzb4EQ8j1WhNkiMxxY35xsjpbBAxJEJn1GI8y/2KAxrJ
         1lmT/LXOZ1+yOgsNG4F02V5uDcBUPxy4GJFG4mXV4sXABfGskmeZY1ccjVG3XET/SiJP
         TJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=r4FpLYfUs7tX4DLeiy0sj/1t8j21OoA6g793iTCGiF8=;
        b=cDvs8eZda7RqkgNYtTDPREMBrfgVTin6oc4EjT6+SHYlKRPdfWHyeFAboZaYtOYRkU
         gPz4S/9JwaaK+p7+0HjlOAwPrG3xmcpUOf2xwOzSNArHANLks61Sdrg9XIxd9oaYWGLn
         UeBiOLthl6RB+TNylxCwyKyZCvewMPVrHqLXHi+pj3sHaDi0/9MPPS9AbxDThNFr31hn
         D8GX/4SmfOvQMDDOuzMj+bRimgHKcItFZz7PG32JEZrlypa05nrFMOMkR2ErjYM+YlUT
         Cg8ThJoazlD6IvbgTwvPYoxNBqDZslS4XjWWzFHbzZD5oy5NyA4jUJW1wodAm+XVWCK/
         0fPA==
X-Gm-Message-State: ACgBeo3aPOtOBCYvg93uvN5d97b+tuFUsZbbJ2ZQyeMH2cQ0/mOcUH4v
        WNiWg3rT+k4HiHLXWUogVlR5Dw==
X-Google-Smtp-Source: AA6agR56aM67PHK/+ONTl8BroEWue4HRkKqPBqbKMvQMV90VH3pqrryFs0RWIE536XgLpzL4WCoa1A==
X-Received: by 2002:a05:6402:43c4:b0:43b:c5eb:c9dd with SMTP id p4-20020a05640243c400b0043bc5ebc9ddmr26620352edc.402.1660143036615;
        Wed, 10 Aug 2022 07:50:36 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id x7-20020a170906440700b00730cc173c6asm2369268ejo.43.2022.08.10.07.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:50:36 -0700 (PDT)
Message-ID: <49f933c3-7430-a133-9add-ed76c395023b@blackwall.org>
Date:   Wed, 10 Aug 2022 17:50:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Cc:     netdev@vger.kernel.org, aroulin@nvidia.com, sbrivio@redhat.com,
        roopa@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
 <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org>
 <CAMWRUK45nbZS3PeSLR1X=Ko6oavrjKj2AWeh2F1wckMPrz_dEg@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAMWRUK45nbZS3PeSLR1X=Ko6oavrjKj2AWeh2F1wckMPrz_dEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2022 17:42, Sevinj Aghayeva wrote:
> 
> 
> On Wed, Aug 10, 2022 at 4:54 AM Nikolay Aleksandrov <razor@blackwall.org <mailto:razor@blackwall.org>> wrote:
> 
>     On 10/08/2022 06:11, Sevinj Aghayeva wrote:
>     > When bridge binding is enabled for a vlan interface, it is expected
>     > that the link state of the vlan interface will track the subset of the
>     > ports that are also members of the corresponding vlan, rather than
>     > that of all ports.
>     >
>     > Currently, this feature works as expected when a vlan interface is
>     > created with bridge binding enabled:
>     >
>     >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>     >         bridge_binding on
>     >
>     > However, the feature does not work when a vlan interface is created
>     > with bridge binding disabled, and then enabled later:
>     >
>     >   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>     >         bridge_binding off
>     >   ip link set vlan10 type vlan bridge_binding on
>     >
>     > After these two commands, the link state of the vlan interface
>     > continues to track that of all ports, which is inconsistent and
>     > confusing to users. This series fixes this bug and introduces two
>     > tests for the valid behavior.
>     >
>     > Sevinj Aghayeva (3):
>     >   net: core: export call_netdevice_notifiers_info
>     >   net: 8021q: fix bridge binding behavior for vlan interfaces
>     >   selftests: net: tests for bridge binding behavior
>     >
>     >  include/linux/netdevice.h                     |   2 +
>     >  net/8021q/vlan.h                              |   2 +-
>     >  net/8021q/vlan_dev.c                          |  25 ++-
>     >  net/core/dev.c                                |   7 +-
>     >  tools/testing/selftests/net/Makefile          |   1 +
>     >  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>     >  6 files changed, 172 insertions(+), 8 deletions(-)
>     >  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
>     >
> 
>     Hi,
>     NETDEV_CHANGE event is already propagated when the vlan changes flags,
> 
> 
> I'm not sure if NETDEV_CHANGE is actually propagated when the vlan changes flags. The two functions in the bridge module that handle NETDEV_CHANGE are br_vlan_port_event  and br_vlan_bridge_event. I've installed probes for both, and when I'm changing flags using "sudo ip link set vlan10 type vlan bridge_binding on", I don't see any of those functions getting called, although I do see vlan_dev_change_flags getting called. I think there may be a bug in core/dev.c:__dev_notify_flags.

are both vlan and bridge interfaces up?
what exactly are you probing for?

I can see the NETDEV_CHANGE event go through when changing the loose binding.




