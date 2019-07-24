Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D3672730
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 07:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfGXFJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 01:09:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfGXFJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 01:09:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 55F4F60D0C; Wed, 24 Jul 2019 05:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563944989;
        bh=lLKO+gfsyxVLLXKWJzogBecneZk7iRc3LuTD2MbeGyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fjUsEq3Rr8zi4Ghhc0jyTpsUyKkz6WgzImRgeHBERTU+XpFOgUm3rN5rUFXNn/70l
         KJTDh7Qq7VFv7qszGAsg5ZBI8QGL1i30yBBw2l82cz+ksamglnhagV0cbb/vRTgT/2
         VwJ7QqL7POiImSPD/v8UOHnp3N7bb+qurxO2ZiLo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 9E1B960256;
        Wed, 24 Jul 2019 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563944982;
        bh=lLKO+gfsyxVLLXKWJzogBecneZk7iRc3LuTD2MbeGyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iv0fXWiyGC9fPCBBvvLInWED2Tdk2Xpa9aLdZfGnHZsfVkljntyMU5o9gp0E9n9Yl
         VGcb2CC6B2O6lBWzQbpmUTy+s7a8MgygUz4dJ6vejVHmcppyFgV5HI0YOWIQfun45z
         xyYD9+jXgr3cmvn22JxqEPaIDsKYqC3kwiDCQC4c=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 24 Jul 2019 13:09:42 +0800
From:   xiaofeis@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH] qca8k: enable port flow control
In-Reply-To: <20190719131306.GA24930@lunn.ch>
References: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
 <20190719131306.GA24930@lunn.ch>
Message-ID: <7613ffc99b6f9039a7ac56284b5a6329@codeaurora.org>
X-Sender: xiaofeis@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

Thanks for your comments. I have sent a new patch based on net-next 
tree.

Thanks
Xiaofeis

On 2019-07-19 21:13, Andrew Lunn wrote:
> On Fri, Jul 19, 2019 at 10:53:11AM +0800, xiaofeis wrote:
>> Set phy device advertising to enable MAC flow control.
>> 
>> Change-Id: Ibf0f554b072fc73136ec9f7ffb90c20b25a4faae
>> Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
> 
> Hi Xiaofei
> 
> What tree is this patch against? I don't think it is net-next. It
> actually looks to be an old tree. Please rebase to David Millers
> net-next. Patches to that tree are closed at the moment, due to the
> merge window. You can post an RFC, or wait until it opens again.
> 
> Thanks
> 	Andrew
