Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7BF12D26A
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfL3RM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 12:12:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfL3RM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 12:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vfY9gt1VRv4/X0oVQUAQ14aFmyEBR70glyliw4eTWK0=; b=d2J7Up1AkAeaSH9eb0aAVHuszH
        vVuZyl1oEPvFh07WOH0jpph/7axI31SQx5D6qQpvGN6FESaC5LNsXfKZJUpg10Pbavau56LX/m5w/
        tGnFsdwneHFtNBUo0Xg+8DJ1SfWhMXyrAv5l5MSxj8+xWX8nesma6B/JydCblnNvFGVw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ilyaW-00044T-Du; Mon, 30 Dec 2019 18:12:16 +0100
Date:   Mon, 30 Dec 2019 18:12:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 00/20] net: dsa: add GRO support
Message-ID: <20191230171216.GC13569@lunn.ch>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I mark this as RFC, and there are the key questions for maintainers,
> developers, users etc.:
> - Do we need GRO support for DSA at all?

> - Does this series bring any performance improvements on the
>   affected systems?

Hi Alexander

I think these are the two most important questions. Did you do any
performance testing for the hardware you have?

I personally don't have any of the switches you have made
modifications to, so i cannot test these patches. I might be able to
add GRO to DSA and EDSA, where i can do some performance testing.

    Andrew
