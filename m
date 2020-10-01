Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79E2808EF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgJAU7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387403AbgJAU7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 16:59:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40F9320759;
        Thu,  1 Oct 2020 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601585989;
        bh=BZkqb31JAKeBijs0bB7WzM9KawJTBStBfkmOGpGZ1wQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T2Am/amX5jZDX41wg8Y04Y4utz9uQgXCEqMUF0Vcorl8Fqdj229DZTjO/6J7NvUU4
         p7ZLz0sMRCU9RNIlnE3gX5mxfbk02ekdF8xrfd/hiI3toMRDS9HUNsnbLl2mAmv4+Q
         jTWT69FDVBB3EOmC+Oey3Z6H9PhHS5TeW25PnAAA=
Date:   Thu, 1 Oct 2020 13:59:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/16] devlink: Add reload action option to
 devlink reload command
Message-ID: <20201001135947.08cd9480@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-3-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:05 +0300 Moshe Shemesh wrote:
> Add devlink reload action to allow the user to request a specific reload
> action. The action parameter is optional, if not specified then devlink
> driver re-init action is used (backward compatible).
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities. Therefore, the devlink
> reload command returns the actions which were actually performed.
> Reload actions supported are:
> driver_reinit: driver entities re-initialization, applying devlink-param
>                and devlink-resource values.
> fw_activate: firmware activate.
> 
> command examples:
> $devlink dev reload pci/0000:82:00.0 action driver_reinit
> reload_actions_performed:
>   driver_reinit
> 
> $devlink dev reload pci/0000:82:00.0 action fw_activate
> reload_actions_performed:
>   driver_reinit fw_activate
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
