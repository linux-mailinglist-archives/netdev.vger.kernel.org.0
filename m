Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6C37518
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfFFNY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:24:27 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44351 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbfFFNY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:24:26 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so127178lfm.11
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6VvTa7jh68L3DqECLfvU6eht3kypptvrGe0C/l1sSc4=;
        b=uiDCHxunpTNbqoX1mCPCc8NRtAIhuavvzV1/rBDjSRtFp905kfqhuGjHe/rUedN9K5
         0xBIrMo7AGUF0PmrIHJo9fuIvNx1CFaQPXG/lo0aiW4PqJt8AiaHpM+UdhYEuT8A62qs
         DfSr/4TJlRgV9m47Wi0ybWIZhFhGA41W33F2ZSRxYZoUh8aQPxfUfv1JkThX8oSKVtw4
         w1ZIwOkswXwQ1Z5xzdPkFKz6ERgWcnllkrH7XvMztVaMfXC1EcLcte6rgJiFyCThf5EB
         7DM2MW85VFs1QkeVBxZWMjaxjxBt3AOsclZlzBR35bbQ4pwglzLe5yEVnuo94NsghcNq
         2A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=6VvTa7jh68L3DqECLfvU6eht3kypptvrGe0C/l1sSc4=;
        b=q1xCPCD498zwwbph9ipZxNJa4ckXOmGYEaiLHzrbh+x0vZEVAfaF8k9+BdPiRaqbDS
         quPg44zdTvejm5hCA5H28xr8tz5/ZgOlENjs6ANRad5C6lZcFsUm3sph5k+Q28ZeDSwC
         Ngb2U5oa/UF05s/RU+faH7IbMIbzNoq1d7JRq3HChVVQFqsSvuLKWAHRFyZ9cHw7x1CM
         rJHCgf4/JTTWwq/0l6A7FLgyyFsWss1aQwlMZgv/5TWQqpzU9m8o9sF9SIS0SmmAy434
         +UQhbK05oxcBfuDgEi6+igIGYAPgL3ZWCgTidw5LTpy/ANySingpzUeXZR1sC/6cOQJE
         fz4g==
X-Gm-Message-State: APjAAAUaOUlfHGSEV//g+vTcU1yjDybHhnyw1qhfpGwLGs1m/9gjN9XL
        1Gbs1zm0YBXB6iwygREQDv6+hg==
X-Google-Smtp-Source: APXvYqzpJq7TzVxEfvmb01lE+tYNlzx0SO/56Qk6uSDDEMENTbe/6nYs+ELEhHe89+3LJcMFQ+tfBA==
X-Received: by 2002:ac2:569c:: with SMTP id 28mr10407708lfr.147.1559827464872;
        Thu, 06 Jun 2019 06:24:24 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id w1sm394155ljm.81.2019.06.06.06.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 06:24:24 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:24:22 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, grygorii.strashko@ti.com,
        hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP support
Message-ID: <20190606132420.GA12429@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, grygorii.strashko@ti.com,
        hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
 <20190605.121450.2198491088032558315.davem@davemloft.net>
 <20190606100850.72a48a43@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190606100850.72a48a43@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:08:50AM +0200, Jesper Dangaard Brouer wrote:
>On Wed, 05 Jun 2019 12:14:50 -0700 (PDT)
>David Miller <davem@davemloft.net> wrote:
>
>> From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> Date: Wed,  5 Jun 2019 16:20:02 +0300
>>
>> > This patchset adds XDP support for TI cpsw driver and base it on
>> > page_pool allocator. It was verified on af_xdp socket drop,
>> > af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.
>>
>> Jesper et al., please give this a good once over.
>
>The issue with merging this, is that I recently discovered two bug with
>page_pool API, when using DMA-mappings, which result in missing
>DMA-unmap's.  These bugs are not "exposed" yet, but will get exposed
>now with this drivers.
>
>The two bugs are:
>
>#1: in-flight packet-pages can still be on remote drivers TX queue,
>while XDP RX driver manage to unregister the page_pool (waiting 1 RCU
>period is not enough).
>
>#2: this patchset also introduce page_pool_unmap_page(), which is
>called before an XDP frame travel into networks stack (as no callback
>exist, yet).  But the CPUMAP redirect *also* needs to call this, else we
>"leak"/miss DMA-unmap.
>
>I do have a working prototype, that fixes these two bugs.  I guess, I'm
>under pressure to send this to the list soon...

In particular "cpsw" case no dma unmap issue and if no changes in page_pool
API then no changes to the driver required. page_pool_unmap_page() is
used here for consistency reasons with attention that it can be
inherited/reused by other SoCs for what it can be relevant.

One potential change as you mentioned is with dropping page_pool_destroy() that,
now, can look like:

@@ -571,7 +571,6 @@ static void cpsw_destroy_rx_pool(struct cpsw_priv *priv, int ch)
                return;
 
        xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
-       page_pool_destroy(priv->page_pool[ch]);
        priv->page_pool[ch] = NULL;
 }

From what I know there is ongoing change for adding switchdev to cpsw that can
change a lot and can require more work to rebase / test this patchset, so I want
to believe it can be merged before this.

-- 
Regards,
Ivan Khoronzhuk
