Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9D227FB60
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgJAITZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 04:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730862AbgJAITZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:19:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877ADC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 01:19:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o5so4558935wrn.13
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 01:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aITCYqxNnSwPgx6KqXTuhuIl3KXLFHswvG0zkyiyE2E=;
        b=KKQKKGQb2AAOWNCrEnqOpsuxAkFCTERAg6DWUaKLJ+wg3X+4/zImR5KCILsPxYg0kQ
         cd61OeEPMNRKLZu0S5xD1uqWDccYOpnL00gg3f7HCtqkFQ+2zSIOL0paQnEERgiNfZMa
         eokkyaLr+Gmv2xYhssfis88zJGB8iy0j0EREyJN/HROYgioLp4YK2EW2kg6jf5AzTEow
         wVpYf0nILv2XprQqQ8xvTcPlOyA/j5Cku40nLHHmF/QsvFdiHx+k+0aOy6NHH83/GuQJ
         KZSe6ghqL9qC51i5Qc2UWmu8dPgXGS2VSjzBcq8c2NitWGP+HubkpjoGPFDMz9DKLUmL
         t+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aITCYqxNnSwPgx6KqXTuhuIl3KXLFHswvG0zkyiyE2E=;
        b=CqhieVbN5qmUTeSURVmWh8TlyYQi1MEXBwqdh2drrvZ5rHg7rFtDoAg8/zg28f3IQM
         /1GQpN8WxWeG30fteZIbVdVNRRUr3jZ5dKQLJic3IC/KqQAuizk3PJ1a1qO/GR9TZxCi
         DMnnlbyV0zT2Jtqn3JgmQ/7Xmu2MfvvBIqM++gtfWDwSjPI1zLb28Z5rA1NrM5UmbnX2
         6E6Q8SWnhZZHJKLkDaxHelhbQNRkhsgIWk+EF1s6Ooc6HUftpwNZ9OKjsxGtY0Chi/3T
         OKJ+63AYdY6JF4PdzWsxir6yZ7EfWY6rPnCWNzlDuCcAFiCgpcmwq3ed3f8T/kZs4if5
         4Fpg==
X-Gm-Message-State: AOAM530d4jh6jrXhA5d2EGz0I3lcbHBP2KPEkCpSbYSILw4m6kmjZDPp
        8lPykDrJOqTL47vA1SFlucf3833m9L8=
X-Google-Smtp-Source: ABdhPJz6lV1flJ4bOVllN+B5QSrOpzFvqEWAAxyYmSSBL+UZLCFfUZoNW5IbbOHgzywBTJWvkq6gqA==
X-Received: by 2002:a05:6000:7:: with SMTP id h7mr7863928wrx.16.1601540361713;
        Thu, 01 Oct 2020 01:19:21 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.50.42])
        by smtp.gmail.com with ESMTPSA id w2sm7490138wrs.15.2020.10.01.01.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 01:19:20 -0700 (PDT)
Subject: Re: [PATCH net 01/12] ipvlan: add get_link_net
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
References: <cover.1600770261.git.sd@queasysnail.net>
 <b920e279472824d78949401e3bc837713d1f54ea.1600770261.git.sd@queasysnail.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b3a6433e-35c4-603b-5939-eaebc27a21c9@gmail.com>
Date:   Thu, 1 Oct 2020 10:19:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b920e279472824d78949401e3bc837713d1f54ea.1600770261.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/20 9:59 AM, Sabrina Dubroca wrote:
> Currently, ipvlan devices don't advertise a link-netnsid. We can get
> it from the lower device, like macvlan does.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index 5bca94c99006..a81bb68a5713 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -678,6 +678,14 @@ void ipvlan_link_setup(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(ipvlan_link_setup);
>  
> +static struct net *ipvlan_get_link_net(const struct net_device *dev)
> +{
> +	struct ipvl_dev *ipvlan = netdev_priv(dev);
> +	struct net_device *phy_dev = ipvlan->phy_dev;
> +
> +	return dev_net(phy_dev);
> +}
> +
>  static const struct nla_policy ipvlan_nl_policy[IFLA_IPVLAN_MAX + 1] =
>  {
>  	[IFLA_IPVLAN_MODE] = { .type = NLA_U16 },
> @@ -691,6 +699,7 @@ static struct rtnl_link_ops ipvlan_link_ops = {
>  	.setup		= ipvlan_link_setup,
>  	.newlink	= ipvlan_link_new,
>  	.dellink	= ipvlan_link_delete,
> +	.get_link_net	= ipvlan_get_link_net,
>  };
>  
>  int ipvlan_link_register(struct rtnl_link_ops *ops)
> 

This conflicts with a patch in net-next...

commit 0bad834ca7bf9999ed9841f2bf9f5f07fbe02136
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Fri Aug 21 17:47:32 2020 +0000

    ipvlan: advertise link netns via netlink

I think you should take it as is.
