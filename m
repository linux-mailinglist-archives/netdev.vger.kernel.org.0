Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CD930FE9A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhBDUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240286AbhBDUiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903E264F43;
        Thu,  4 Feb 2021 20:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612471063;
        bh=v+1OuSVjEGOKMGttfg6Q3d7E32F2brb8yV+v5j7eC6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mwiX716Oq2Aa9vZ3Wl0azlFtDn/sZNkLi+YxNtG0z0URzVgLxffbaW482Y9V0UR76
         /CE75OGA7cozP9BE7DM6FZf5JF8X8ZyZSC0hCt5QzTIDmMRpV3F9CPlVoIUuRShMPT
         EoHslKTzAPie6y/GhFyJCihEACDwempAqVmjKUimdLpUfO/5FnKm4yZu1K5e1d/Hu5
         KNlSBJGTlldVCpjSZLfEpNZXODjJkPtanyRTX51vDULgzmSdxssySi06Q9QcXhYJWW
         2fLv1EG+vJz8JTJTQkxLKwmH/OTDWhAhu30UvQtlip/ROOLVDpkXvBZ5PaE3ln++SG
         29wboYmjCkLmQ==
Date:   Thu, 4 Feb 2021 12:37:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Dan Williams <dcbw@redhat.com>,
        "Carl =?UTF-8?B?WWlu?=(=?UTF-8?B?5q635byg5oiQ?= )" 
        <carl.yin@quectel.com>, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        Naveen Kumar <naveen.kumar@quectel.com>
Subject: Re: [PATCH net-next v3 0/5] Add MBIM over MHI support
Message-ID: <20210204123741.720d120a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi_m8F83yWwamj7Os2pctYmDMRKbwKEi7CpQoH5CCSJMLg@mail.gmail.com>
References: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
        <CAMZdPi_m8F83yWwamj7Os2pctYmDMRKbwKEi7CpQoH5CCSJMLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 19:21:23 +0100 Loic Poulain wrote:
> On Thu, 4 Feb 2021 at 19:09, Loic Poulain <loic.poulain@linaro.org> wrote:
> >
> > This patch adds MBIM decoding/encoding support to mhi-net, using
> > mhi-net rx and tx_fixup 'proto' callbacks introduced in the series.  
> 
> This series has been rebased on top of the recently submitted:
>     [PATCH net-next v5 1/2] net: mhi-net: Add re-aggregation of
> fragmented packets
> Since I assumed it would be merged first, but let me know if it's not fine.

We can leave this as is for review, but patchwork does not understand
dependencies, so this couldn't get build-checked:

https://patchwork.kernel.org/project/netdevbpf/list/?series=428171&state=*

You'll need to repost once the other set is merged. In the future
best to send the dependent series as [RFC net-next] to make it clear 
you're aware repost will be needed.
