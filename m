Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B834228C69B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgJMBFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgJMBFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:05:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78508C0613D0;
        Mon, 12 Oct 2020 18:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3/UMvVj1iHurYlGTpET+HgFtFX6/vZ3O3wVdx9j3nWA=; b=u94y0GqYiqP9faYdqaxObjAgwO
        SM4gwA9EdKonSkFRQEfeNDGxRts7FTWDkzDaKXx9p1GP3VCVVb+wHyXVDykSeLv4mYNPRa+Vd1aqT
        ionUIht+s1cw7eDUdqBo3d8PftiGU6Gw3vzk9lBqmalVPTJU6QS1Ii1cQhqJGyv3U0WoSsCzd55bR
        SrI9SdFEqb7furHGOrU6ByBlKjBV3KQyGck+WgWr5zPJZuXcV2wxfFucixEpOgwV9E1aOMR/WpgPL
        7PF7YN+lPKqpu+5PI18UdSV/vaDBybbadQeO6IAEV66oyhBF2at4UBt03hoA35SZgHq+dOjymefuS
        wbQqEAcQ==;
Received: from [2601:1c0:6280:3f0::507c]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kS8kd-0001Q2-0Y; Tue, 13 Oct 2020 01:05:15 +0000
Subject: Re: [PATCH v2 2/6] ASoC: SOF: Introduce descriptors for SOF client
To:     Dave Ertman <david.m.ertman@intel.com>, alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org, linux-rdma@vger.kernel.org,
        jgg@nvidia.com, dledford@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-3-david.m.ertman@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <076a0c53-0738-270e-845f-0ac968a4ea78@infradead.org>
Date:   Mon, 12 Oct 2020 18:05:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005182446.977325-3-david.m.ertman@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/20 11:24 AM, Dave Ertman wrote:
> diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
> index 4dda4b62509f..cea7efedafef 100644
> --- a/sound/soc/sof/Kconfig
> +++ b/sound/soc/sof/Kconfig
> @@ -50,6 +50,24 @@ config SND_SOC_SOF_DEBUG_PROBES
>  	  Say Y if you want to enable probes.
>  	  If unsure, select "N".
>  
> +config SND_SOC_SOF_CLIENT
> +	tristate
> +	select ANCILLARY_BUS
> +	help
> +	  This option is not user-selectable but automagically handled by
> +	  'select' statements at a higher level
> +
> +config SND_SOC_SOF_CLIENT_SUPPORT
> +	bool "SOF enable clients"

Tell users what "SOF" means.

> +	depends on SND_SOC_SOF
> +	help
> +	  This adds support for ancillary client devices to separate out the debug
> +	  functionality for IPC tests, probes etc. into separate devices. This
> +	  option would also allow adding client devices based on DSP FW

spell out firmware

> +	  capabilities and ACPI/OF device information.
> +	  Say Y if you want to enable clients with SOF.
> +	  If unsure select "N".
> +


-- 
~Randy

