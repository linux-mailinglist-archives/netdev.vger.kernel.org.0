Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25D187B77
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 09:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgCQIpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 04:45:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:36616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgCQIpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 04:45:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B6DB8AC62;
        Tue, 17 Mar 2020 08:45:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3F03AE00A9; Tue, 17 Mar 2020 09:45:45 +0100 (CET)
Date:   Tue, 17 Mar 2020 09:45:45 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, jaswinder.singh@linaro.org,
        ilias.apalodimas@linaro.org, Jose.Abreu@synopsys.com,
        andy@greyhouse.net, grygorii.strashko@ti.com, andrew@lunn.ch,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH net-next 9/9] net: ethtool: require drivers to set
 supported_coalesce_params
Message-ID: <20200317084545.GF10043@unicorn.suse.cz>
References: <20200316204712.3098382-1-kuba@kernel.org>
 <20200316204712.3098382-10-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316204712.3098382-10-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 01:47:12PM -0700, Jakub Kicinski wrote:
> Now that all in-tree drivers have been updated we can
> make the supported_coalesce_params mandatory.
> 
> To save debugging time in case some driver was missed
> (or is out of tree) add a warning when netdev is registered
> with set_coalesce but without supported_coalesce_params.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

