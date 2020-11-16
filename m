Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D072B54B3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgKPXA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgKPXA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:00:56 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9E5C0613CF;
        Mon, 16 Nov 2020 15:00:56 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so26755876ejb.7;
        Mon, 16 Nov 2020 15:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q1oNa+SDvS8rNlOFpMcD/JWhI9Mb+yXMudWdOfTVJtg=;
        b=UodquA9Jt/2gII7GaU8AlnmKZb13xKoqOA8734Fs+qd4BKf/P0S/FJwCTLBN5Y56V/
         jf1AcqnQ0kTeDmU1k2/KepFPpDmxuwnStO3/NVq2QGPigNelIhjgdJDw1uZ+s9lfXw8w
         8BDCGkNpn5kfF1wi7nc0UbKbZWAWpeJ4PORKPJMTrZRm3WWTUSMZNPyzCnBcYXrqEbcG
         qIsKvnRc7GO/GFq9h8uErEeP4IRjr6yF/Mab7770RN7BQeCrvddbqEAlK/WME3Yns1Wf
         olIuqvrtiiEhRoLk3feSzgKt+f1dI7m/gh8GHntvetdUYYS7UsqRVviNHELi6Owt+LEZ
         r9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q1oNa+SDvS8rNlOFpMcD/JWhI9Mb+yXMudWdOfTVJtg=;
        b=UAIMMqVSkgkJVIrhbF/X1HjNGgdacrd1YUMkOwZeDsb4OOdlIFkkPeOMePnK7rF6Cq
         Ocoxwgpd52ju05v8Ed6Ldo7fti0o0ad7xJHJ29Z3VCMebJ7+9QNgTCqDG0fIz7S2kkH2
         i/VpI1ud5pD/zROC8HrcQu+Hn+EZdmzXNey9oakrLb2FwTLnDO2ygT8QL0/t5qsv16te
         TR34hgy89wDuiYgDRHR+vwnET+t7H2mU4w7/Xoq7MBxI+KNykDqUlZCRi7VUBjjR1s1+
         gOkkfqKegWDQ9Nq6mU+AHdKXWa/2PgtN5if2gQTGKJR9xUu3ccfjIFE0TmtS3WoLA17K
         BD6g==
X-Gm-Message-State: AOAM533t1V2DfqjS4Wn62LrJXnlqtaQUtTiWn3jHmjlOseTY63DobuyG
        SRSYkY1Us+Xn28MRhfkYi4n0IxAhCjQ=
X-Google-Smtp-Source: ABdhPJzOt57Bd/bq43g7ujtQDWOL1EJeGUeQ/2YjH4ds0rj/1pOuf5MoqHuGcNt79rsOAxkV9gFe7w==
X-Received: by 2002:a17:906:46d5:: with SMTP id k21mr16974710ejs.495.1605567655118;
        Mon, 16 Nov 2020 15:00:55 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d19sm11285984eds.31.2020.11.16.15.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:00:54 -0800 (PST)
Date:   Tue, 17 Nov 2020 01:00:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116230053.ddub7p6lvvszz7ic@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
 <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116222146.znetv5u2q2q2vk2j@skbuf>
 <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 02:35:44PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 00:21:46 +0200 Vladimir Oltean wrote:
> > On Mon, Nov 16, 2020 at 01:34:53PM -0800, Jakub Kicinski wrote:
> > > You must expose relevant statistics via the normal get_stats64 NDO
> > > before you start dumping free form stuff in ethtool -S.
> >
> > Completely agree on the point, Jakub, but to be honest we don't give him
> > that possibility within the DSA framework today, see .ndo_get_stats64 in
> > net/dsa/slave.c which returns the generic dev_get_tstats64 implementation,
> > and not something that hooks into the hardware counters, or into the
> > driver at all, for that matter.
>
> Simple matter of coding, right? I don't see a problem.
>
> Also I only mentioned .ndo_get_stats64, but now we also have stats in
> ethtool->get_pause_stats.

Yes, sure we can do that. The pause stats and packet counter ops would
need to be exposed to the drivers by DSA first, though. Not sure if this
is something you expect Oleksij to do or if we could pick that up separately
afterwards.

> > But it's good that you raise the point, I was thinking too that we
> > should do better in terms of keeping the software counters in sync with
> > the hardware. But what would be a good reference for keeping statistics
> > on an offloaded interface? Is it ok to just populate the netdev counters
> > based on the hardware statistics?
>
> IIRC the stats on the interface should be a sum of forwarded in software
> and in hardware. Which in practice means interface HW stats are okay,
> given eventually both forwarding types end up in the HW interface
> (/MAC block).

A sum? Wouldn't that count the packets sent/received by the stack twice?
