Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA990EB0CD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfJaNEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:04:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfJaNEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OeH6vIyyk4Gxy1e5htSMP+grEm42M0j+Rw6x0bSA5iY=; b=bf88pE2Qxq8l1tZf7ZHJhR0sCo
        kV6ZqvFg1GoxWqzjV832NsMMRXLr6h7yIu9AHoSDZwKHS1aLdOjjOn4DO5wewVbOJuNsmCfwqxh1T
        xR4s0/cnMfOjUE3Fauk+krZLpbRymoAyMaKHdFj6h2J5PM0ovBStkN2XM6if4Ld15L7c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iQA7i-0000PX-TH; Thu, 31 Oct 2019 14:04:22 +0100
Date:   Thu, 31 Oct 2019 14:04:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-sunxi@googlegroups.com, wens@csie.org,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191031130422.GJ10555@lunn.ch>
References: <20191030202117.GA29022@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030202117.GA29022@plaes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 08:21:17PM +0000, Priit Laes wrote:
> Heya!
> 
> I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> detection fails consistently with certain 1000Mbit partners (for example Huawei
> B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
> but the same hardware works properly with certain other link partners (100Mbit GL AR150
> for example).

Hi Pritt

What PHY is used? And what happens if you use the specific PHY driver,
not the generic PHY driver?

    Andrew
