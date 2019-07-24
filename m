Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF27360E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfGXRui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:50:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfGXRui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 13:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1XCEXIqLf148keL4Hr1VukzRLv+wzJaQD/9Ntubifzo=; b=31EgmcbDLTKs8y+uiQyO1GN1LB
        7lTDSLj47qhKE9Ij/XnqVX/Bhwd/Aq9g49WMAZ2LEe9d7BD2x4SaOQ6lS7OFQrBKEKwWv+a9lXkMU
        JE9aPC0kpCvbJDnUbENoxpUamfPwozLvueLK26kLCRsVr6RPAGf9ees1OmmT0m7khkOA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqLPL-0001N3-VT; Wed, 24 Jul 2019 19:50:31 +0200
Date:   Wed, 24 Jul 2019 19:50:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     xiaofeis <xiaofeis@codeaurora.org>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v2] net: dsa: qca8k: enable port flow control
Message-ID: <20190724175031.GA28488@lunn.ch>
References: <1563944576-62844-1-git-send-email-xiaofeis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563944576-62844-1-git-send-email-xiaofeis@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 01:02:56PM +0800, xiaofeis wrote:
> Set phy device advertising to enable MAC flow control.

Hi Xiaofeis

It seems like you are still using the wrong, and old tree. Please
rebase on net-next/master.

       Thanks
              Andrew
