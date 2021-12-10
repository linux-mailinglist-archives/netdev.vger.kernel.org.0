Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A3446F9A3
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhLJDlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhLJDlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:41:32 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3CFC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 19:37:57 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id e3so26232499edu.4
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 19:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=0mLnFflG4Be9s185D3yK2MiXBMtK0V+8lgYUTJKkdyE=;
        b=IlEtfacYqBrJVYe4LvciMIXeclQisq79uKJsDUXgDQgikj8+xIRM4XOClw3ZNyHWB2
         9wrb6oiw0qWFUc6cRo5RjcfZwA2TT4dd6mZq2JlIKgQELokB/8X/wo1K5gaySS4lyMBf
         Y77LQmDNUFg03OE2uj8hPmCtc22cSO3i3GrLD2ultqdBsBx2L7CEUJQICBWwZJL+rZ7h
         D7kYjncB2LtUjr5bO5On3saeBspYOg6JbxLiV945IxrJCEAxCNXftMX/ii2Dy18+ZSP/
         0neQ429IszXpgd3IbEQGjDhRlSOyoS2RVhqYvPcS6ghG9A+OcnZuNVS/W8dTFpoTzoe9
         iQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=0mLnFflG4Be9s185D3yK2MiXBMtK0V+8lgYUTJKkdyE=;
        b=TLENVwngz6a5ICLTBGAOGW3yq2xJBchxXXXJqlms6WkTb1/XhhGOaGC78P3cKlsGjB
         TOPXXvlpQ6dKWbKd1v7rtqbHnM+leVdfqxs/v5yfOhZUfabAywYHWy2ui1Cs28TgWxvc
         NdfrO5bKwUY84QXaTdJxEENz65Y4MXH84YyGN2hHl3DQALVzwXuoFLNDk/2riciWgbWn
         wypBUA+w/XX3oczppCSAypZZx8rgrOcllclBDl/lvwflIoOKfR1EOwxt2Hs5t1Hgyc8N
         +pAh7XW0r0dzhmBTW3sx9jntqrmHPEaUWtguAx9Z5em/BqUr++HlGNx4mWyQWLVQsgg9
         XGfg==
X-Gm-Message-State: AOAM530o66uMwgdPBvDaVBNdj/aodBGr7KFC1NTGgi/hk4IyKYSKqNwU
        fJfw0w2wER/gLdSVvHURWjPSvWywDT0=
X-Google-Smtp-Source: ABdhPJxhgSpGz+NzCCYFA4QW1PcMQA5ilvZF/5kcpCHEYM4aMWJ041i33J/0m/SD5soZqMrkVvo18A==
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr34990437edw.73.1639107475852;
        Thu, 09 Dec 2021 19:37:55 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id jz4sm769978ejc.19.2021.12.09.19.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 19:37:55 -0800 (PST)
Message-ID: <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
X-Google-Original-Message-ID: <YbLLkNw+VC5gKQd5@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 04:37:52 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> This patch set is provided solely for review purposes (therefore not to
> be applied anywhere) and for Ansuel to test whether they resolve the
> slowdown reported here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> 
> The patches posted here are mainly to offer a consistent
> "master_state_change" chain of events to switches, without duplicates,
> and always starting with operational=true and ending with
> operational=false. This way, drivers should know when they can perform
> Ethernet-based register access, and need not care about more than that.
> 
> Changes in v2:
> - dropped some useless patches
> - also check master operstate.
> 
> Vladimir Oltean (4):
>   net: dsa: provide switch operations for tracking the master state
>   net: dsa: stop updating master MTU from master.c
>   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
>   net: dsa: replay master state events in
>     dsa_tree_{setup,teardown}_master
> 
>  include/net/dsa.h  | 11 +++++++
>  net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
>  net/dsa/dsa_priv.h | 13 ++++++++
>  net/dsa/master.c   | 29 ++---------------
>  net/dsa/slave.c    | 27 ++++++++++++++++
>  net/dsa/switch.c   | 15 +++++++++
>  6 files changed, 145 insertions(+), 30 deletions(-)
> 
> -- 
> 2.25.1
> 

Hi, I tested this v2 and I still have 2 ethernet mdio failing on init.
I don't think we have other way to track this. Am I wrong?

All works correctly with this and promisc_on_master.
If you have other test, feel free to send me other stuff to test.

(I'm starting to think the fail is caused by some delay that the switch
require to actually start accepting packet or from the reinit? But I'm
not sure... don't know if you notice something from the pcap)

-- 
	Ansuel
