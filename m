Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7381DA0F6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgESTYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:24:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF59C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:24:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s69so106478pjb.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=481jJeyXaoRAJoR7uKEVrBmi6B97KiyVLVF9TF6+jqg=;
        b=fxkvz6sCj3xc2xESMvj5XP4jU3Gwq3pVKSELbqNTV2FqEDbUEvGihz734/gEucUVvA
         d7hTs72+0ctSY4oA7oH1BCfUhpcRkkx8Q42toreNMf5uqVGoMAHvcpGeOtce2ChY/13X
         SFIeIVyS4WHQvDEeU1YM1U6EnSBjOqNw2fwsl3ACq8cNBlV6/gqKCIn5r4yAnRtzzt5w
         vKg8HoGZcde2C59KOvavLBT3OcfcqiABApYbUXask+stvkTJAba8BKq/Fsmm1vHmEKq+
         6mJbUFtZNkePYm4pG71On4kK0Lq6DGH6KSoFBZwvc+2S1DzpVLWlmVtYQym1/wAyUl9Y
         VIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=481jJeyXaoRAJoR7uKEVrBmi6B97KiyVLVF9TF6+jqg=;
        b=Avy7FtkgjS3Av/pZPvof6jujJ2Ti7NlA3wbYjhs8maiLUiGf8tCQTg3sHiZ3rwn7RE
         UiTb6dxsd3vddk2fl/jQ6dqUV5j//9sl4CTJKof3XphqspgGmmwfP1KZu+rLUAC+kgBn
         KccZTcMSZm2bf5NQQYrxSlrlWIGzYdLdVvN/+ZciM600HUDZvkGp9aRH28l939l7PTCP
         1SRBSg7TcrOPSjCCazdNDztWbv6GK9WQcRUGmBLQ1bBJMNqxHNRvZsvoKguswkCKGzmg
         wf0Z1GQJISfYoNgM8u+4roDnxnLiqon1xJNOjZzf4YqGrpicoNouY7CMquXZa27KKbbw
         ymjA==
X-Gm-Message-State: AOAM531v0Pyhcr/vrVTR//MPgxAmv/kxtPbsXQNm39Olun9yLhRHAMfX
        JlWdTw5HkarwTVBF86TzxiVCzQ==
X-Google-Smtp-Source: ABdhPJwMVw3667hRv6pWEcjInFOlyhCwhXNet5lLnh+lSbHDagcO+F7vLVgVcEQz2eCE8vvTSxocwA==
X-Received: by 2002:a17:90a:d3ca:: with SMTP id d10mr1084701pjw.42.1589916251823;
        Tue, 19 May 2020 12:24:11 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id f11sm234059pfa.32.2020.05.19.12.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 12:24:11 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] devlink: Add a new devlink port width
 attribute and pass to netlink
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, drivers@pensando.io,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-3-idosch@idosch.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <82d5a049-293d-b7ed-615e-e11abc81f4dd@pensando.io>
Date:   Tue, 19 May 2020 12:24:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519134032.1006765-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 6:40 AM, Ido Schimmel wrote:
> From: Danielle Ratson <danieller@mellanox.com>
>
> Add a new devlink port attribute that indicates the port's width.
> Drivers are expected to set it via devlink_port_attrs_set(), before
> registering the port.
>
> The attribute is not passed to user space in case the width is invalid
> (0).
>
> Signed-off-by: Danielle Ratson <danieller@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---

[...]

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index 273c889faaad..a21a10307ecc 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -82,7 +82,7 @@ int ionic_devlink_register(struct ionic *ionic)
>   		return 0;
>   
>   	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
> -			       0, false, 0, NULL, 0);
> +			       0, false, 0, 0, NULL, 0);
>   	err = devlink_port_register(dl, &ionic->dl_port, 0);
>   	if (err)
>   		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
for ionic
Acked-by: Shannon Nelson <snelson@pensando.io>

[...]

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 7b76e5fffc10..9887fba60a7a 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -526,6 +526,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
>   
>   	if (!attrs->set)
>   		return 0;
> +	if (attrs->width) {
> +		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_WIDTH, attrs->width))
> +			return -EMSGSIZE;
> +	}
>   	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
>   		return -EMSGSIZE;
>   	switch (devlink_port->attrs.flavour) {
> @@ -7408,6 +7412,7 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
>    *	@split: indicates if this is split port
>    *	@split_subport_number: if the port is split, this is the number
>    *	                       of subport.
> + *	@width: width of the port. 0 value is not passed to netlink.

A little more explanation here would help - basically something like
     @width: number of ways the port can be split.  0 value is not 
passed to netlink.

Is this always going to be an even number, or a power-of-2?  If so, 
perhaps that should be noted here.


Thanks,
sln


