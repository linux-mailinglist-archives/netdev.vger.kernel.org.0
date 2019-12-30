Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09D712D28D
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 18:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfL3RWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 12:22:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43638 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbfL3RWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 12:22:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LvLtlNVIraZ0K0BvAC5sz2iObsMdXa39MW+pknncAe8=; b=iSv7ysfdrw1VwJYAGLPPJNd9NM
        KGau6p3kXLxDpdxTm2WplWp0/sl76MT0ivU7mdQUYlrjNbuWITalxN7VLliyisHVL8+sbLagNdeAf
        UtYhMZd4l4+AJ0mq4Tx4L7TW6YbSLc1BMQlSgwA5uu+0sqrbrScaRXphYxfNFPyAhWKw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ilyk5-0004Ct-AJ; Mon, 30 Dec 2019 18:22:09 +0100
Date:   Mon, 30 Dec 2019 18:22:09 +0100
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
Subject: Re: [PATCH RFC net-next 06/19] net: dsa: tag_gswip: fix typo in tag
 name
Message-ID: <20191230172209.GE13569@lunn.ch>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-7-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230143028.27313-7-alobakin@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 05:30:14PM +0300, Alexander Lobakin wrote:
> "gwsip" -> "gswip".
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
