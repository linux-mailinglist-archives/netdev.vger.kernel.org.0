Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490AA3091D5
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhA3EZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhA3DyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:54:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1382E64DE1;
        Sat, 30 Jan 2021 03:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611978185;
        bh=qzCNFiTq8DIekJW5FCO6FZm/KDjaFQtSH/g8t1Lfke8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XerFZvzRMhV5SuRTKaaP5WdVnLYKKOuoStvOfuJwQmlUIocyRKxcOrHWXv40D7LHC
         esmH1xp/NWhStIw9g6bc0fOAHuJz+/UQpElLwcbAEBYLNNYqC21JMDseX/jAcVAgnb
         i3TypKTGLImjOhDY5SeG9h/VJWL64JVk3bTOYgRUNbyEE94nFzWx2ELD4ZO3oN0Utp
         zZkBNMuWOxWR746/L4Wc0dMEgtM3DHoedcPJqXbYV4J/emgrx1bD7+8XLDVH7v2Suy
         mD88Y1XEpIO7fF9KGyykm/3ZyAtAXazmgcoMHKEXCMUSE91J+DDfNaMVR9hss519d5
         k3TRWdmLxYhNA==
Date:   Fri, 29 Jan 2021 19:43:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        David Miller <davem@davemloft.net>
Subject: Re: pull-request: mhi-net changes for net-next
Message-ID: <20210129194304.6a1987c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi_xQYooy9cDdf1Snen3A4OUbDt-6JScSuhWh5obv0E9iA@mail.gmail.com>
References: <CAMZdPi_xQYooy9cDdf1Snen3A4OUbDt-6JScSuhWh5obv0E9iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 15:19:12 +0100 Loic Poulain wrote:
> Hi Jakub,
> 
> As requested, here is the pull-request based on mhi-net-immutable +
> mhi-net patches.

Pulled, thanks!
