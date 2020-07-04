Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943F2214912
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 00:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGDWxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 18:53:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:49026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgGDWxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 18:53:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E533AAD11;
        Sat,  4 Jul 2020 22:53:04 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 74135604BB; Sun,  5 Jul 2020 00:53:04 +0200 (CEST)
Date:   Sun, 5 Jul 2020 00:53:04 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, govind.varadar@gmail.com
Subject: Re: [PATCH ethtool 2/2] man: add man page for ETHTOOL_GTUNABLE and
 ETHTOOL_STUNABLE
Message-ID: <20200704225304.4zlysnijbefkjy7k@lion.mk-sys.cz>
References: <20200608175255.3353-1-gvaradar@cisco.com>
 <20200608175255.3353-2-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608175255.3353-2-gvaradar@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 10:52:55AM -0700, Govindarajulu Varadarajan wrote:
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
>  ethtool.8.in | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/ethtool.8.in b/ethtool.8.in
> index 4c5b6c5..da0564e 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -390,6 +390,18 @@ ethtool \- query or control network driver and hardware settings
>  .RB [ fast-link-down ]
>  .RB [ energy-detect-power-down ]
>  .HP
> +.B ethtool \-b|\-\-get\-tunable
> +.I devname
> +.RB [ rx-copybreak ]
> +.RB [ tx-copybreak ]
> +.RB [ pfc-prevention-tout ]
> +.HP
> +.B ethtool \-B|\-\-set\-tunable
> +.I devname
> +.BN rx\-copybreak
> +.BN tx\-copybreak
> +.BN pfc\-prevention\-tout
> +.HP
>  .B ethtool \-\-reset
>  .I devname
>  .BN flags

Please add also detailed description like we have for PHY tunables.

Michal

> -- 
> 2.27.0
> 
