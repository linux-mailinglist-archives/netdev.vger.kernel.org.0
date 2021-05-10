Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B87379813
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhEJUBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 16:01:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhEJUBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 16:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vk0QJzc0L0mFIpupBcUMolNk0a4OzVF6hyuLmd1U86o=; b=d9PMxNwGJtCZrhccNt69fvPqbF
        LapaqCE+flaGq/Z6OtlZHXdr+4niwSkL9szMrF7JaRT012JKLrZ1jEOgEiQMfXpw+z7X+XFsSwia/
        Ge993AXL6+EurZd2mNKUnA7KAcTpZ9/a26rlJGqa/haVCaxYt57th4ywS95KmIULwym8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgC4H-003d2E-Jt; Mon, 10 May 2021 21:59:53 +0200
Date:   Mon, 10 May 2021 21:59:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <YJmQufHgq6WlRz4Q@lunn.ch>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510135656.3960-1-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 09:56:56PM +0800, Zhen Lei wrote:
> The statement of the last "if (adv_lpa & LPA_10HALF)" branch is the same
> as the "else" branch. Delete it to simplify code.
> 
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Hi Zhen

Could you teach your bot to check lore.kernel.org and see if the same
patch has been submitted before? If it has, there is probably a reason
why it was rejected. You need to check if that reason it still true.

    Andrew
