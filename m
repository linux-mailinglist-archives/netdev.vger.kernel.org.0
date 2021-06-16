Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE083AA2B6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFPR7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhFPR7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 13:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC0E6128B;
        Wed, 16 Jun 2021 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623866252;
        bh=ffG0Ms+KA6DQXVcD7fAmE0fsgjBiuRFHb1cdgSZFc24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cqL2/BTQQzrqQGNW00eft3SnbAaONsVyz7nugZ9P5fTGuPZ/cG3F7MGAzNXFFXxpj
         5myZCd2nYYSAqNXzM4jXJsCEpOqimFc+ynjbSmBGNJ1kUGgOjyaHoeeizAqRvYVtzg
         bxRoqhOfRdm7Gwz7aYscdIPLERgjfhtD8hqjviCb6BW9c/kKI97iRZymoedQyAucTP
         dN79pl1ovhNPJJLr5crMO/y+VCKdS8rKspA24lPJ0/lmRorqn13CD38GvOgwXnTBeB
         62oTpGCSErz4k+XL3koiDgc6RIsPqMFa+2yNDdGA0H/yn6UdNE0zyOvD2zPpFxvkqa
         MpCg/UJnMMoMw==
Date:   Wed, 16 Jun 2021 10:57:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sgoutham@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: ethtool: Support setting ntuple rule
 count
Message-ID: <20210616105731.05f1c98c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1623847882-16744-2-git-send-email-sgoutham@marvell.com>
References: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
        <1623847882-16744-2-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Jun 2021 18:21:21 +0530 sgoutham@marvell.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Some NICs share resources like packet filters across
> multiple interfaces they support. From HW point of view
> it is possible to use all filters for a single interface.
> Currently ethtool doesn't support modifying filter count so
> that user can allocate more filters to a interface and less
> to others. This patch adds ETHTOOL_SRXCLSRLCNT ioctl command
> for modifying filter count.
> 
> example command:
> ./ethtool -U eth0 rule-count 256

man devlink-resource ?
