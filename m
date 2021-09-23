Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2813541683E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbhIWW5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243435AbhIWW5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 18:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C483661050;
        Thu, 23 Sep 2021 22:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632437749;
        bh=YCc8QSTAl6IqvIo5XZId9oapktBmGOuuYiyhrObvKr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0FKWhPPx405FMBvQEkBkZ5S8jz0qoj9QO0Veq976W50SOy0DPJmFqtgWzopnYH1K
         DvVA0sKKl/FkwFLRPrmt7jYOMTDHR/KMY0XP3Lfrj9mQ/neGK6PUtsq2iM3zV1hL2Q
         hJH3whaFxtWAUh2p/FSEHt9I2jFOqdAtbhDbCvh/taJI7cLAX+ZxQa9u1CX3DQ+EV2
         zkourkZILuuOIymxUVygEKIjkrL2My15u2XRHU4DEDoqY4eIA9JAVowOHkabeKZ5kG
         XJlB7rS+TBkDi1f+CijNXFMoOnWzCj7cJoXVVcmFkdCzY4aB9U2iWyyedG4CoORcI7
         buIdUvImxu/2w==
Date:   Thu, 23 Sep 2021 15:55:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 0/6] Batch of devlink related fixes
Message-ID: <20210923155547.248ab1aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 21:12:47 +0300 Leon Romanovsky wrote:
> I'm asking to apply this batch of devlink fixes to net-next and not to
> net, because most if not all fixes are for old code or/and can be considered
> as cleanup.
> 
> It will cancel the need to deal with merge conflicts for my next devlink series :).

Not sure how Dave will feel about adding fixes to net-next,
we do merge the trees weekly after all.

Otherwise the patches look fine.
