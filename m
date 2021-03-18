Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B22340FBB
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhCRVU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:20:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhCRVTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:19:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lN03b-00BkSP-Sk; Thu, 18 Mar 2021 22:19:51 +0100
Date:   Thu, 18 Mar 2021 22:19:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 4/5] dpaa2-switch: fit the function declaration
 on the same line
Message-ID: <YFPD9y75BZl/gF9u@lunn.ch>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
 <20210316145512.2152374-5-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316145512.2152374-5-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io,
> -			 u32 cmd_flags,
> -			 u16 token,
> -			 u16 if_id,
> +int dpsw_if_set_link_cfg(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 if_id,
>  			 struct dpsw_link_cfg *cfg)

Hi Ioana

It looks like this one might violate the 80 character limit? The limit
has been increased in Linux in general, but netdev maintainers would
like to keep the old 80 limit where possible.

     Andrew

