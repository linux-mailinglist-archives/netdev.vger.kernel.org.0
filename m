Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD062B0993
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgKLQJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgKLQJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:09:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29BE520825;
        Thu, 12 Nov 2020 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605197394;
        bh=3xWQV1Y4Fl7w3nmhP4xu9ESqn4URx4CtAvwQC1xSdqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1DAkBKeITwlVlRMMu7hi27+8H7cM3qUMz3GxnvzKl7QD8y+WSO8gjGe5LxLUZqzot
         3BoTQbE13lUmSJhH1b2Ky517q/eco7+wlXPxoDQguOy9AtmWMlYyTUIMWymXFXdRFu
         4IYl+T2AgVb57BLwv1eSg6/73kwWBlSDqayoFFpY=
Date:   Thu, 12 Nov 2020 08:09:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net RESEND] devlink: Avoid overwriting port attributes
 of registered port
Message-ID: <20201112080952.6c156138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111034744.35554-1-parav@nvidia.com>
References: <20201110185258.30576-1-parav@nvidia.com>
        <20201111034744.35554-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 05:47:44 +0200 Parav Pandit wrote:
> Cited commit in fixes tag overwrites the port attributes for the
> registered port.
> 
> Avoid such error by checking registered flag before setting attributes.
> 
> Fixes: 71ad8d55f8e5 ("devlink: Replace devlink_port_attrs_set parameters with a struct")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Applied, thanks!
