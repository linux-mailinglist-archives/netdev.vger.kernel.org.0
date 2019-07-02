Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DF75D3F5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGBQLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:11:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfGBQLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 12:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I5YSfzoELUoJy815RwL+cE2lch9gcMn/eI+i68Ki7U8=; b=INzGXu16tC775CvJE21Br4Uaya
        AdwqIdvsE4BZptAGxzkzGA6Oph4GH2Nj8N8Vuh/93Vd/njjKEyZ+S2oPGL1HYpAa4tqhiOZZ0Uni4
        S9u8wH+cJvnYHNll2ttjKnYiSdSKofir6MtRHuJkeDf8C1LFv5xAGg1vq5JJ56DC8Nqs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hiLNV-00077k-MR; Tue, 02 Jul 2019 18:11:33 +0200
Date:   Tue, 2 Jul 2019 18:11:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkalderon@marvell.com,
        aelior@marvell.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Message-ID: <20190702161133.GP30468@lunn.ch>
References: <20190702152056.31728-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702152056.31728-1-skalluru@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 08:20:56AM -0700, Sudarsana Reddy Kalluru wrote:
> The patch adds devlink interfaces for drivers to publish/unpublish the
> devlink port parameters.

Hi Sudarsana

A good commit message says more about 'why' than 'what'. I can see the
'what' by reading the code. But the 'why' is often not so clear.

Why would i want to unpublish port parameters?

Thanks
	Andrew
