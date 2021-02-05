Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11131045C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhBEFK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:10:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhBEFKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:10:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D8BC64F4A;
        Fri,  5 Feb 2021 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612501813;
        bh=9c5QO5b6ZJnUlq5QqDrwRxOY/jSz1/k/4DWGc5PsGhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NLvKyjM6mGshB0Ok38qEdnAlcgfKWyCsOkEBBS7kyGd+cN23b5dxtPMH7KsudxWjS
         JQv5c6Px+xhtK5fvLMcQZNBjrBSTnxftr3LM7kh6G5f+QXkfqGYYTE9MZzRM79a5V5
         Mt/YMImWeCZqaTLQ3Tfv1e4X3WcFDhMMGXsrcw67a3X2OWZ9QCi2LRochx+869uT5S
         zWjJimWyoGaq5KkLwThoJZER8d9kRKJroKd0FcTyO4/Vqg5BpnWtTGiCYQPdAKx/9g
         yIyONLOch2VM+Bs/yehzLTy4yChN1RdqiIIHCxR89THgAjyY9go3zMYlQjcrtyqkfR
         tOLA6RJBf2YxQ==
Date:   Thu, 4 Feb 2021 21:10:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: marvell: prestera: disable events
 interrupt while handling
Message-ID: <20210204211012.48b044a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203165458.28717-3-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 18:54:53 +0200 Vadym Kochan wrote:
> There are change in firmware which requires that receiver will
> disable event interrupts before handling them and enable them
> after finish with handling. Events still may come into the queue
> but without receiver interruption.

Sounds like you should do a major version bump for this.

Old driver will not work correctly with new FW.
