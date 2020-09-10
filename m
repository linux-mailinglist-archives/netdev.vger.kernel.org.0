Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BBF264824
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgIJOlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbgIJOiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:38:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFA920720;
        Thu, 10 Sep 2020 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599748698;
        bh=JbgjupPeBobdX+RA0Q5oUvoOpxJ2wqLdbQXjHhadBew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cUYLvW19PG8FMgDDIQKbcSo0vBPlBo6cCGFC2K6ZSIeCELoRcm5+2PgM8D2S4ATfI
         6lkEwZo6vT5RwGDc9nkwOKyE9z+S/f1llGvhRJ+kahcstRFhxou80RJ1zge5sDZ4+S
         jb9EU/9eNAJduypPXnNNWtpHVEa4WiShSLVxJw94=
Date:   Thu, 10 Sep 2020 07:38:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 2/9] net: devlink: region: Pass the region
 ops to the snapshot function
Message-ID: <20200910073816.5b089bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909235827.3335881-3-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
        <20200909235827.3335881-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 01:58:20 +0200 Andrew Lunn wrote:
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index 111d6bfe4222..eb189d2070ae 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -413,6 +413,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
>   * error code on failure.
>   */
>  static int ice_devlink_nvm_snapshot(struct devlink *devlink,
> +				    const struct devlink_region_ops *ops,
>  				    struct netlink_ext_ack *extack, u8 **data)
>  {
>  	struct ice_pf *pf = devlink_priv(devlink);
> @@ -468,6 +469,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
>   */
>  static int
>  ice_devlink_devcaps_snapshot(struct devlink *devlink,
> +			     const struct devlink_region_ops *ops,
>  			     struct netlink_ext_ack *extack, u8 **data)
>  {
>  	struct ice_pf *pf = devlink_priv(devlink);


drivers/net/ethernet/intel/ice/ice_devlink.c:418: warning: Function parameter or member 'ops' not described in 'ice_devlink_nvm_snapshot'
drivers/net/ethernet/intel/ice/ice_devlink.c:474: warning: Function parameter or member 'ops' not described in 'ice_devlink_devcaps_snapshot'
