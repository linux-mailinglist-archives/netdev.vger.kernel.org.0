Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3206C4180A3
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 10:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhIYI6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 04:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231625AbhIYI6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 04:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A3F6103B;
        Sat, 25 Sep 2021 08:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632560218;
        bh=7XQFbVcfXOzoTAyNW3J0/NRGYfrMDB9ojTMiYSvXm04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ru1pfYlScKHcW8eEszJO5jusybgMYSLrxtcYJipwfTXaDxVZPPQN8iJjqeaCrRX7n
         buQtmp5XwhpNcsmMghNfsdcZja+dQEVxfdjN7Ehe9PPPwISxjGn4+va/iKDUIc0w0W
         7n4lU6BHH9sy8Hs4xMAVliwLtypQoNaZnkGBynAL1elGo3ZfzcVmZptiSz6bI5Y1XY
         0jExyAKNcE7c1EmQgHEM0FcFNCNIA8gLTjRzgN1IhrBj765/hU12BPJuVAsFHzQy4m
         uSMjZm4C4laW7Ttngq+cOm5cqwq755v5C8Iuv9EdMaAGzyPgKYj+KkPY7sLDSgB7Ko
         fVqmIQ7g61lYg==
Date:   Sat, 25 Sep 2021 11:56:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, alobakin@pm.me, anirudh.venkataramanan@intel.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, irusskikh@marvell.com,
        intel-wired-lan@lists.osuosl.org, jejb@linux.ibm.com,
        jhasan@marvell.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, michael.chan@broadcom.com,
        michal.kalderon@marvell.com, netdev@vger.kernel.org,
        sathya.perla@broadcom.com, skashyap@marvell.com,
        anthony.l.nguyen@intel.com, vasundhara-v.volam@broadcom.com
Subject: Re: [PATCH net-next 0/6] Batch of devlink related fixes
Message-ID: <YU7kVo2MHe7Bq1Or@unreal>
References: <cover.1632420430.git.leonro@nvidia.com>
 <20210924.141426.1767931642845359040.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924.141426.1767931642845359040.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 02:14:26PM +0100, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Thu, 23 Sep 2021 21:12:47 +0300
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Hi,
> > 
> > I'm asking to apply this batch of devlink fixes to net-next and not to
> > net, because most if not all fixes are for old code or/and can be considered
> > as cleanup.
> > 
> > It will cancel the need to deal with merge conflicts for my next devlink series :).
> 
> ok, but just this one time.

Thanks

> 
> I much rather this kind of stuff goes to net and we deal with the merge
> conflicts that arise.

I'll do.

> 
> Thsnks!
