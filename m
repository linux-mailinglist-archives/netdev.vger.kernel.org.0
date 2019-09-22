Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9261BABE5
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfIVWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:17:34 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:39549 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbfIVWRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:17:34 -0400
Received: by mail-io1-f51.google.com with SMTP id a1so28919608ioc.6
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IgZ9XeW2NzRfDSs/DE41/WaThp53wgdpK7nER3D3upA=;
        b=KFEvTu3YLTl1oYDsSF+m2DaPj1IvQ8zIrWk8h0cz6QBT5pYvk/lt4+ktCgRDx0lSSj
         eRf9grv6XOvB0jpKR81DxVmvYwtIsB0/lgUopIBkqjUQMS+fl1eDmN4H46CdrCO9xfxq
         O/VRi6f43F9Vxdlt8K+ytPKL0r38vyu5m1H544wf2JdvAITbCdV4bRB2Kz3CpLuSNJni
         R0L5SF5pqadHSiPW1G4NEMN7b+JtLGESct+HIgxLuZCsXakq7nWgpcKv8eijN8MP6agU
         H1kuT2Cg1fZ874odsQ5O+S8SgnZiCSsIyHRbEeAL4boDoGcaWlQrmvigQxpGEMwfnKNC
         tEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IgZ9XeW2NzRfDSs/DE41/WaThp53wgdpK7nER3D3upA=;
        b=LewcNiz/5DZQCa8aIfPSzZYbic5ilhjC18VN3ijoOsEEWewtlBBi4mMYotH4WftXzu
         hoF7bKe3/j8rgXcgp9YFZkjeuSr01Q4MQv8C+eFPpk0pb4dqh3JrkNqMfP76NI2PYa/o
         ORNXt1dgYcGsfEP2RXSL5bbcPPyJDRDKGiGxOFFeZpG+112s+oRaCGRdAjFYB4O2RA59
         G6ig8wb1ttSoL6SLN5sh+SzRmwnOeAjsYCXPIiEcAPfHOgS96ExdZvFzbp2MdyNOj/63
         KVgfK+u8WuHIo7Pl6tSOVGZfbiSNa5+3vaZtyqSS8T0PauUDm5jGZEf2XfFWzT06W5V/
         MoQg==
X-Gm-Message-State: APjAAAW/qAchh5EO7lfDYIwEzMYnzFj1gwiVfkY0XnyrnyWQ8421gCmp
        Y/Awb/n+oql8w2fBfrHhFvtQOicg8Lg=
X-Google-Smtp-Source: APXvYqxSxtckCvjmZkbMGyBV1p62Vd/PqTqSZCCKnqf4G4M3IiIu7mp0mvvsCfYquMI6IimX/1lskw==
X-Received: by 2002:a63:e05:: with SMTP id d5mr17701236pgl.230.1569188839680;
        Sun, 22 Sep 2019 14:47:19 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h4sm9432614pfg.159.2019.09.22.14.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 14:47:19 -0700 (PDT)
Date:   Sun, 22 Sep 2019 14:47:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Message-ID: <20190922144715.37f71fbf@cakuba.netronome.com>
In-Reply-To: <1569153104-17875-1-git-send-email-paulb@mellanox.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
        <1569153104-17875-1-git-send-email-paulb@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Sep 2019 14:51:44 +0300, Paul Blakey wrote:
> The skb extension is currently used for miss path of software offloading OvS rules with recirculation to tc.
> However, we are also preparing patches to support the hardware side of things.
> 
> After the userspace OvS patches to support connection tracking, we'll have two users for
> tc multi chain rules, one from those actually using tc and those translated from OvS rules.
> 
> With both of these use cases, there is similar issue of 'miss', from hardware to tc and tc to OvS and the skb
> extension will serve to recover from both.
> 
> Consider, for example, the following multi chain tc rules:
> 
> tc filter add dev1 ... chain 0 flower dst_mac aa:bb:cc:dd:ee:ff action pedit munge ex set mac dst 02:a0:98:4e:8f:d1 pipe action goto chain 1
> tc filter add dev1 ... chain 1 flower ip_dst 1.1.1.1 action mirred egress redirect dev2
> tc filter add dev1 ... chain 1 flower ip_dst 2.2.2.2 action mirred egress redirect dev2
> 
> It's possible we offload the first two rules, but fail to offload the third rule, because of some hardware failure (e.g unsupported match or action).
> If a packet with (dst_mac=aa:bb:cc:dd:ee:ff) and (dst ip=2.2.2.2) arrives,
> we execute the goto chain 1 in hardware (and the pedit), and continue in chain 1, where we miss.
> 
> Currently we re-start the processing in tc from chain 0, even though we already did part of the processing in hardware.
> The match on the dst_mac will fail as we already modified it, and we won't execute the third rule action.
> In addition, if we did manage to execute any software tc rules, the packet will be counted twice.
> 
> We'll re-use this extension to solve this issue that currently exists by letting drivers tell tc on which chain to start the classification.
> 
> Regarding the config, we suggest changing the default to N and letting users decide to enable it, see attached patch.

Partial offloads are very hard. Could we possibly take a page out of
routing offload's book and do a all or nothing offload in presence of
multiple chains?

> ------------------------------------------------------------
> 
> Subject: [PATCH net-next] net/sched: Set default of CONFIG_NET_TC_SKB_EXT to N
> 
> This a new feature, it is prefered that it defaults to N.
> 
> Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> ---
>  net/sched/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index b3faafe..4bb10b7 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -966,7 +966,6 @@ config NET_IFE_SKBTCINDEX
>  config NET_TC_SKB_EXT
>  	bool "TC recirculation support"
>  	depends on NET_CLS_ACT
> -	default y if NET_CLS_ACT
>  	select SKB_EXTENSIONS
>  
>  	help

 - Linus suggested we hide this option from user and autoselect if
   possible.
 - As Daniel said all distros will enable this.
 - If correctness is really our concern, giving users an option to
   select whether they want something to behave correctly seems like
   a hack of lowest kind. Perhaps it's time to add a CONFIG for TC
   offload in general? That's a meaningful set of functionality.
