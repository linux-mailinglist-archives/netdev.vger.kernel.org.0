Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241896E627
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfGSNOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 09:14:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfGSNOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 09:14:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ELhTdL3WmzK3aXZTF6VShd8Zo/NSLXkmg6fzRt2MMRE=; b=SF2xqfHum1n143Nri8FL8zWg/o
        oSu39DuLbz5xiE8GlOnjONenznCmTn4Ri5r/BWoMvLGch3CRVOj+ZXGNZy/2AJEiqFfXrVcJVsPbM
        v2p6OUJIR/veCEWvWOJMCh3q4pZCerTOJ3xVe+mgV4yFauPyKmaj/mQ0oCuyeaviZY9g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoSiZ-0006aH-NL; Fri, 19 Jul 2019 15:14:35 +0200
Date:   Fri, 19 Jul 2019 15:14:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     xiaofeis <xiaofeis@codeaurora.org>, davem@davemloft.net,
        vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        xiazha@codeaurora.org
Subject: Re: [PATCH] qca8k: enable port flow control
Message-ID: <20190719131435.GB24930@lunn.ch>
References: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
 <20190719093135.GA22605@centauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719093135.GA22605@centauri>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Question for DSA maintainers: shouldn't this be implemented in the
> dsa_switch_ops phylink_validate callback, like it's done for other
> dsa drivers?

Hi Niklas

qca8K is still using phylib, not phylink. So the validate callback
cannot be used.

       Andrew
