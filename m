Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8030BA056
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfIVDHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:07:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40480 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfIVDHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:07:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so5970498pgj.7
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+hqtxIPOF+sZTV83QO8Kx8GfXMOFqFAUA+8V0ZE+ANg=;
        b=PnxsGTDplcToYRHyOkbs7IReY50O0iFBh50FWIfgtGYFlX3h1/1GwJvwb31v/YSjbq
         L5q4X0jVPfEfZtz5YgmePdWf2L5dKEZewSTNrH1rcE4wL/wF4WxwDh9lINZqLJOU9nOW
         PV67ZVl5AokgCmzu6JZTfRKLIfSzrQm2fs6UAiweCvvZvBvFqghogOV/+EiwPJyv713d
         E04dW4DMzi2hzAh7XTAWD7QJSMJdu8sMi57XO8EHnrxfUKqPGX2au03up6gTUiM1xZlP
         EzXX3qUnta4jQ5/nDXheTTOcehl8cV0QIBckQL2JlvvfkpTb17qPjIAJ+XeT0UZ4DNrF
         wLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+hqtxIPOF+sZTV83QO8Kx8GfXMOFqFAUA+8V0ZE+ANg=;
        b=qLDF5GzjP1Y4f3vzIN8rspiZBurtUm4TyB4VJdW8zqqRzqa8OO2vHdBPFqmAnqtrPv
         aSpqIYHkimuqoopTOVDJUisdGBEg0yzy4tShVTAn32zY70MQ4CJIQodK7ciDPjS2HQuG
         DeXdluobTFYN7HU2vrlsTuDurd0wLO0b9wmf+ShkJDHS6hb1c8f58muGgYDhRVxo5qxV
         puCwq3Sqlb6QuTtr4hbqguDEJedZvj1lnEK6yqk/Eia/Mc61DScm8mfn37vsgQ+1vRLM
         XHpgsbZ9rgK0TTRtt0d2fi2xIhtXNV64agsRMtCchyxbOBQGotrNuDXL1E7VfOJVGETf
         uYVw==
X-Gm-Message-State: APjAAAUwFH/wnRaXO5JVm2kWQTFAJEmIlmSsKdutW9WfFyKPXEwQdSN2
        0ghqO0FGybWxRmZ7a3v26O/zxg==
X-Google-Smtp-Source: APXvYqx/D1qo8iYkkLBA9WBqzVmvZ7s4hPuIRi3UELaObvTRIfbYaVT/1L8MrpqY7PNd85MaIjz5VQ==
X-Received: by 2002:a65:6081:: with SMTP id t1mr21324171pgu.95.1569121664868;
        Sat, 21 Sep 2019 20:07:44 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id t125sm10316640pfc.80.2019.09.21.20.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 20:07:44 -0700 (PDT)
Date:   Sat, 21 Sep 2019 20:07:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <netanel@amazon.com>, <saeedb@amazon.com>, <zorik@amazon.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>
Subject: Re: [PATCH net] net: ena: Add dependency for ENA_ETHERNET
Message-ID: <20190921200741.1c3289e8@cakuba.netronome.com>
In-Reply-To: <20190920084405.140750-1-maowenan@huawei.com>
References: <20190920084405.140750-1-maowenan@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 16:44:05 +0800, Mao Wenan wrote:
> If CONFIG_ENA_ETHERNET=y and CONFIG_DIMLIB=n,
> below erros can be found:
> drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_dim_work':
> ena_netdev.c:(.text+0x21cc): undefined reference to `net_dim_get_rx_moderation'
> ena_netdev.c:(.text+0x21cc): relocation truncated to
> fit: R_AARCH64_CALL26 against undefined symbol `net_dim_get_rx_moderation'
> drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_io_poll':
> ena_netdev.c:(.text+0x7bd4): undefined reference to `net_dim'
> ena_netdev.c:(.text+0x7bd4): relocation truncated to fit:
> R_AARCH64_CALL26 against undefined symbol `net_dim'
> 
> After commit 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive
> interrupt moderation"), it introduces dim algorithm, which configured by CONFIG_DIMLIB.
> 
> Fixes: 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive interrupt moderation")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Thank you Mao, shortly after you posted your patch Uwe proposed to make
DIMLIB a hidden symbol:

https://lore.kernel.org/netdev/a85be675-ce56-f7ba-29e9-b749073aab6c@kleine-koenig.org/T/#t

That patch will likely be applied soon, could you please rework your
patch to use the "select" keyword instead of "depends". That's what
other users do.

> diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
> index 69ca99d..fe46df4 100644
> --- a/drivers/net/ethernet/amazon/Kconfig
> +++ b/drivers/net/ethernet/amazon/Kconfig
> @@ -18,7 +18,7 @@ if NET_VENDOR_AMAZON
>  
>  config ENA_ETHERNET
>  	tristate "Elastic Network Adapter (ENA) support"
> -	depends on PCI_MSI && !CPU_BIG_ENDIAN
> +	depends on PCI_MSI && !CPU_BIG_ENDIAN && DIMLIB
>  	---help---
>  	  This driver supports Elastic Network Adapter (ENA)"
>  

