Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976EB6E624
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfGSNNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 09:13:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfGSNNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 09:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s0bNYtfnvp6ujyuHyrWaSnZf4UjcEcz5X0mRmNRFOiU=; b=ryTQSqL25BFk61jRxRzcWjOHyj
        7CyVURKUDrR8XVz0iWz8DNVHHe8MLbciHd2a/lwC8JtMD7au/d0jgZ58U7o4pf9uImlwYZKhkY/rV
        4eiwlNuV0uotnPCxK34ayEe+4Q7SsbNvlexlPVCdQFiWVqKJixSs6XmwZL+nrObwxROk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoSh8-0006ZG-BM; Fri, 19 Jul 2019 15:13:06 +0200
Date:   Fri, 19 Jul 2019 15:13:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     xiaofeis <xiaofeis@codeaurora.org>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH] qca8k: enable port flow control
Message-ID: <20190719131306.GA24930@lunn.ch>
References: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 10:53:11AM +0800, xiaofeis wrote:
> Set phy device advertising to enable MAC flow control.
> 
> Change-Id: Ibf0f554b072fc73136ec9f7ffb90c20b25a4faae
> Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>

Hi Xiaofei

What tree is this patch against? I don't think it is net-next. It
actually looks to be an old tree. Please rebase to David Millers
net-next. Patches to that tree are closed at the moment, due to the
merge window. You can post an RFC, or wait until it opens again.

Thanks
	Andrew
