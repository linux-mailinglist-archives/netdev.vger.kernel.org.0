Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DAD2BA01
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfE0SVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:21:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38915 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfE0SVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:21:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id f1so12679156lfl.6
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cIQmYr9qDMcXw/frZVuWSs4Z6gJsQGJv00LJLaCloGU=;
        b=I08TnzUsf6VHmv0MXTkDHbfoBRdecoRH0TuiyGZxWw8T/dKfvmFxurJh24q+r49R1I
         uuBsAjEvsYuQVzOoOb3D/N7u7nOScU/WuvpJOoKOonbzLXeyUjVDwST+keiuS7+9Ep+c
         9q3wN8GM8AMakM+zDHACUii5tQCDFhYO/FT9ju/fCN7i2H2AXkr/xmaXk4OsfwRXGrx9
         SMfN0Yl8/YCWP4xc2fnnlx3W1HgrN9Etv+qHvLuC+kjaskSvPZkoZ+JxuICxIvBb8k8o
         s8FkfDAJ9B0HfHyZKf90/w/4Gk6FSEjX1O+4luIDGxWIbdEi5/l2iakNB0XR0tj79Qs2
         50dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=cIQmYr9qDMcXw/frZVuWSs4Z6gJsQGJv00LJLaCloGU=;
        b=G6q63Nk/F/b/RWrs0BHa+shmkFiUpKKgquLI05w2KOiuddnp0OTB2NTl1V9kkDbjsO
         ht4rdX9tkaAA+s/oqxFKfn4KpbDfGsSiSBN80c/FlZ+wh9M2VDqb2eW15+nDFaOSKl7Q
         zli6dFxP5LVQT+3CY6q9CBgVwSKhvHT+eGc6Tbl3trfCW4syrqi2D0sWZY8005xAnlsW
         PkA89SFYJmD4uE1DF5dzRbtrAv053TBBtHZ87k1noctNcrENiK5//a2eHGbjQMhxbqUN
         lqeYUg1FhOzAdFVdc+/IVAVPXBCuEdP7IgHCl4QvFv4Jqy+bIfJPdH6GeyttMYfjO4qa
         Ky+Q==
X-Gm-Message-State: APjAAAUaNJoe5n4D+ZP+11r+lnw5z5Pu99lTKfGRmQ4f4plpNWCgVwG1
        f6kKqD5HlxfUeUWfqT153fgMgA==
X-Google-Smtp-Source: APXvYqxdLRxNn6fN/7LXcm+ASzyV4brjzSwTtHmi8VWTNZ8pZTlZxyv2h5jnYIU7M47O202GgHej3Q==
X-Received: by 2002:ac2:5595:: with SMTP id v21mr6577390lfg.54.1558981278784;
        Mon, 27 May 2019 11:21:18 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id w20sm2451515ljd.39.2019.05.27.11.21.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 11:21:17 -0700 (PDT)
Date:   Mon, 27 May 2019 21:21:15 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190527182114.GB4246@khorivan>
Mail-Followup-To: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
 <20190524110511.GA27885@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190524110511.GA27885@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 02:05:11PM +0300, Ilias Apalodimas wrote:
>On Thu, May 23, 2019 at 09:20:35PM +0300, Ivan Khoronzhuk wrote:
>> Add XDP support based on rx page_pool allocator, one frame per page.
>> Page pool allocator is used with assumption that only one rx_handler
>> is running simultaneously. DMA map/unmap is reused from page pool
>> despite there is no need to map whole page.
>>
>> Due to specific of cpsw, the same TX/RX handler can be used by 2
>> network devices, so special fields in buffer are added to identify
>> an interface the frame is destined to. Thus XDP works for both
>> interfaces, that allows to test xdp redirect between two interfaces
>> easily.
>>
>> XDP prog is common for all channels till appropriate changes are added
>> in XDP infrastructure.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  drivers/net/ethernet/ti/Kconfig        |   1 +
>>  drivers/net/ethernet/ti/cpsw.c         | 555 ++++++++++++++++++++++---
>>  drivers/net/ethernet/ti/cpsw_ethtool.c |  53 +++
>>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>>  4 files changed, 554 insertions(+), 62 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>> index bd05a977ee7e..3cb8c5214835 100644
>> --- a/drivers/net/ethernet/ti/Kconfig
>> +++ b/drivers/net/ethernet/ti/Kconfig
>> @@ -50,6 +50,7 @@ config TI_CPSW
>>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>>  	select TI_DAVINCI_MDIO
>>  	select MFD_SYSCON
>> +	select PAGE_POOL
>>  	select REGMAP
>>  	---help---
>>  	  This driver supports TI's CPSW Ethernet Switch.
>> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
>> index 87a600aeee4a..274e6b64ea9e 100644
>> --- a/drivers/net/ethernet/ti/cpsw.c
>> +++ b/drivers/net/ethernet/ti/cpsw.c
>> @@ -31,6 +31,10 @@
>>  #include <linux/if_vlan.h>
>>  #include <linux/kmemleak.h>
>>  #include <linux/sys_soc.h>
>> +#include <net/page_pool.h>
>> +#include <linux/bpf.h>
>> +#include <linux/bpf_trace.h>
>> +#include <linux/filter.h>
>>
>>  #include <linux/pinctrl/consumer.h>

[...]

>> +			start_free = 1;
>> +			continue;
>> +		}
>> +
>> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
>> +		 * so put it to the ring to be consumed later when fast cash is
>s/cash/cache
>
>> +		 * empty. If ring is full then free page by recycling as above.
>> +		 */
>> +		ret = ptr_ring_produce(&pool->ring, page);
>> +		if (ret) {
>> +			page_pool_recycle_direct(pool, page);
>> +			continue;
>> +		}
>Although this should be fine since this part won't be called during the driver
>init, i think i'd prefer unmapping the buffer and let the network stack free it,
>instead of pushing it for recycling. The occurence should be pretty low, so
>allocating a buffer every once in a while shouldn't have a noticeable
>performance impact
>

Ok, I will leave previous version from RFC.

-- 
Regards,
Ivan Khoronzhuk
