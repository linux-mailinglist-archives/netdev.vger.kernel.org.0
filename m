Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4912416863
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 01:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243555AbhIWXRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 19:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236363AbhIWXRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 19:17:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56AA660E05;
        Thu, 23 Sep 2021 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632438973;
        bh=/ffRospjLf6815nzAX4J5r7pcOyGGKeM5iEwxXNbnZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bVYYU2E4Ra2vKENV7uGbE5hTrseofLy5junHt7TELSxNeYh04XVq8eliin1OQDntW
         rnIHqOkMYOCVQ4lDd7zcyIjVNlCElnsDxAf0PMxkHsC3sDQXDv1Dm75JKUk9jDD2r4
         8sBW2vPWJkr1w0potE2PF1dcoiULy/awynRFT+5odYCliCseTMn7RQLsqTPsksuAAv
         bYs8tqMffWKpg5NjeK4SVpfC99hUz4pB6eMQ9zvCut+RGfs90jnoQueEWNhefxsFI+
         RmsDirQugKJfOip4CgihOzpRxjdNlEAHoe5WMFTEztsZydp0nnjyXoEvqkxCE1GHj8
         tAqh+94otEF3Q==
Date:   Fri, 24 Sep 2021 02:16:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <YU0KubuG03l8isms@unreal>
References: <cover.1632420430.git.leonro@nvidia.com>
 <20210923155547.248ab1aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210923155547.248ab1aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 03:55:47PM -0700, Jakub Kicinski wrote:
> On Thu, 23 Sep 2021 21:12:47 +0300 Leon Romanovsky wrote:
> > I'm asking to apply this batch of devlink fixes to net-next and not to
> > net, because most if not all fixes are for old code or/and can be considered
> > as cleanup.
> > 
> > It will cancel the need to deal with merge conflicts for my next devlink series :).
> 
> Not sure how Dave will feel about adding fixes to net-next,
> we do merge the trees weekly after all.

My almost ready submission queue is:
➜  kernel git:(m/devlink) git l
693c1a9ac5b3 (HEAD -> m/devlink) devlink: Delete reload enable/disable interface
6d39354f8b44 net/mlx5: Register separate reload devlink ops for multiport device
1ac4e8811fd5 devlink: Allow set specific ops callbacks dynamically
de1849d3b348 devlink: Allow modification of devlink ops
7439a45dce72 net: dsa: Move devlink registration to be last devlink command
7dd23a327395 staging: qlge: Move devlink registration to be last devlink command
77f074c98b0d ptp: ocp: Move devlink registration to be last devlink command
fb3f4d40ad49 net: wwan: iosm: Move devlink_register to be last devlink command
87e95ee9275b netdevsim: Move devlink registration to be last devlink command
4173205af399 net: ethernet: ti: Move devlink registration to be last devlink command
bc633a0759f6 qed: Move devlink registration to be last devlink command
ead4e2027164 ionic: Move devlink registration to be last devlink command
bc5272ccc378 nfp: Move delink_register to be last command
a6521bf133d9 net: mscc: ocelot: delay devlink registration to the end
e0ca9a29cc20 mlxsw: core: Register devlink instance last
681ac1457516 net/mlx5: Accept devlink user input after driver initialization complete
9b1a2f4abaef net/mlx4: Move devlink_register to be the last initialization command
a3b2d9a95a51 net/prestera: Split devlink and traps registrations to separate routines
bbdf4842432f octeontx2: Move devlink registration to be last devlink command
5297e23f19e9 ice: Open devlink when device is ready
18af77a99cea net: hinic: Open device for the user access when it is ready
91a03cdc92e2 dpaa2-eth: Register devlink instance at the end of probe
dd5af984e53c liquidio: Overcome missing device lock protection in init/remove flows
efea109ba32e bnxt_en: Register devlink instance at the end devlink configuration
6a2b139bcf01 devlink: Notify users when objects are accessible

+ a couple of patches that removes "published" field from devlink parameters
and fix of old devlink bug where parameters were netlink notifications
were sent twice.

So it will be very helpful to keep this series in net-next.

> 
> Otherwise the patches look fine.

Thanks

