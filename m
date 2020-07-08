Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B662A218D75
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgGHQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730349AbgGHQr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:47:56 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB9C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 09:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Vqpi7MhGB4lHFys5kR0OMVpNd2c1f+ZL9+rf8uqRYMg=; b=iqW0d2W7u78IC5gXohuQgsFkrn
        BsIoUXm7GMicsIjnIE+20wvV1rK9FfzoFjTDCeQRzO0lQmtiBbmZvb28Xe2FBxkzLShlYZESPIeuP
        aYwBgwq1jzyADfjkQ+7Txr7WlNfsjzdRVTdq4NcfLqW7HmSEUaNiRMQSwGHOcZoHmj1oPRt9VlXqm
        HfcPKFz/pZn9Ll+G8aLwF2ZZibVJMIgdeGUz4aDcz9Q/gEwjIBaCPEvzEN1WxRwKbl8r3wAV2FkSC
        eiCNPa8bGT2UDHtIojqKxo7nXIqk/K3dRrNvZvW/nPThOQDOgEk0CAGvjMdNA5yRD1izsUR04di9d
        CHXZ7Xug==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtDEf-0006Rq-GT; Wed, 08 Jul 2020 16:47:53 +0000
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d1ae905a-eea6-9f1a-33cb-524dd502ffe1@infradead.org>
Date:   Wed, 8 Jul 2020 09:47:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Minor fixes below:

On 7/8/20 9:38 AM, YU, Xiangning wrote:
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index a3b37d88800e..9a8adb6e0645 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -76,6 +76,18 @@ config NET_SCH_HTB
>  	  To compile this code as a module, choose M here: the
>  	  module will be called sch_htb.
>  
> +config NET_SCH_LTB
> +	tristate "Lockless Token Bucket (LTB)"
> +	help
> +	  Say Y here if you want to use the Lockless Token Buckets (LTB)
> +	  packet scheduling algorithm.
> +
> +	  LTB is very similar to HTB regarding its goals however is has

	                                           goals. However, it has a

> +	  different implementation and different algorithm.
> +
> +	  To compile this code as a module, choose M here: the
> +	  module will be called sch_ltb.
> +
>  config NET_SCH_HFSC
>  	tristate "Hierarchical Fair Service Curve (HFSC)"
>  	help


thanks.
-- 
~Randy

