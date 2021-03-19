Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B883342156
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhCSPzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhCSPzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 11:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64F376195B;
        Fri, 19 Mar 2021 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616169336;
        bh=+h2PVOl4z0hCd+XkNnkdPmhhicy6FuQnHON44EZsQPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDtAshkPcs8TfBv7THIsu4OlvFB1vz+W1ENIiHnaTbIGWvsj/37wBzwBMPRSpzFrp
         jdqDf5DwhkDVHlUM/0MTagyoZVibbpGiKzqcIubL23ET4IL9I5Bqc3VtigRSsmHsr9
         y+PvAzNOvtg3CqYAXZRtZEjJ8FcioSySTrdEKkSUswnXakOnBhDcSmRcXY/ezQNYCu
         4UYHw2Kmez4S2lnchhsEo4mWZc1n+ZHKLaXpXYfdyBd4vOZlLJmbA1yBPimXInCyOD
         IxF2dTL0IGSov5oGSawB7W/Ld5BhFB71jUmgOk5N2YmrGpZJnfA8kAK0ZXIJ0y55hF
         IImoNxO8uC10w==
Date:   Fri, 19 Mar 2021 17:55:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <YFTJdL1yDId+iae4@unreal>
References: <20210319082939.77495e55@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210319082939.77495e55@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 08:29:39AM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net tree got a conflict in:
>=20
>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c
>=20
> between commit:
>=20
>   6417f03132a6 ("module: remove never implemented MODULE_SUPPORTED_DEVICE=
")
>=20
> from Linus' tree and commit:
>=20
>   59ec7b89ed3e ("can: peak_usb: add forgotten supported devices")
>=20
> from the net tree.
>=20
> I fixed it up (I just removed the new MODULE_SUPPORTED_DEVICE() lines)
> and can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.

Thanks Stephen, the code should be deleted and commit 59ec7b89ed3e needs
to be reverted.

>=20
> --=20
> Cheers,
> Stephen Rothwell


