Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBDD17A624
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgCENNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:13:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:43178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgCENNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 08:13:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 397B3AC8F;
        Thu,  5 Mar 2020 13:13:03 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7BEF2E037F; Thu,  5 Mar 2020 14:13:01 +0100 (CET)
Date:   Thu, 5 Mar 2020 14:13:01 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        andrew@lunn.ch, ecree@solarflare.com, thomas.lendacky@amd.com,
        benve@cisco.com, _govind@gmx.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next v3 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200305131301.GN4264@unicorn.suse.cz>
References: <20200305051542.991898-1-kuba@kernel.org>
 <20200305051542.991898-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305051542.991898-2-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 09:15:31PM -0800, Jakub Kicinski wrote:
> Linux supports 22 different interrupt coalescing parameters.
> No driver implements them all. Some drivers just ignore the
> ones they don't support, while others have to carry a long
> list of checks to reject unsupported settings.
> 
> To simplify the drivers add the ability to specify inside
> ethtool_ops which parameters are supported and let the core
> reject attempts to set any other one.
> 
> This commit makes the mechanism an opt-in, only drivers which
> set ethtool_opts->coalesce_types to a non-zero value will have
> the checks enforced.
> 
> The same mask is used for global and per queue settings.
> 
> v3: - move the (temporary) check if driver defines types
>       earlier (Michal)
>     - rename used_types -> nonzero_params, and
>       coalesce_types -> supported_coalesce_params (Alex)
>     - use EOPNOTSUPP instead of EINVAL (Andrew, Michal)
> 
> Leaving the long series of ifs for now, it seems nice to
> be able to grep for the field and flag names. This will
> probably have to be revisited once netlink support lands.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
