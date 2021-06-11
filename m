Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2504C3A39D7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhFKCn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:43:29 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:39564 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhFKCn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:43:28 -0400
Received: by mail-ot1-f42.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so1746799otu.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jUFxb829kZNY6qXhnW+ceq6eAYh4muY8u/n6OywWO5k=;
        b=e92QUNt5CPJVRobCZw8OKcQD337dpqTQ7hCTVCKxCfxr6KXmA7RVrffKiSygemosD5
         Q3EDbytdSdTfn0OoMNX1SEEKLCGWppHLyidjRA9wuAPzoUsCe5DzIotSp/j/hxsmwoq/
         dnbrOWgD2y68+ZchDwWWvfouy1J+nd5+BQKMpx5vHwdF4nw6lCBxbEiBRxFKqHEXBl++
         DtMXAw1y2OlvTahIcWZeJFp14UMiXhbAMcxRNQ2sYZnn1V1+1xcjXh/aZnL+JXno+w5e
         /QfYODcqiC9XkSwrCWHii2gEygqXTJwpgyrTixucEN6v3sFPLRn8uLfIaZePYc/Gygn5
         /v6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jUFxb829kZNY6qXhnW+ceq6eAYh4muY8u/n6OywWO5k=;
        b=h315fGw017uPbI+pE2fuM/qJiwXBy79m2HTcgnPpAsdAgRSO12J9mTnuTMDiiZb89g
         mzEneUZiNGj2wxBySIs+TIKF2NAx0AYevz+d44XVONLatmyJg3T2GKIZAOTwUcLCRgRz
         fqK+STQRzG8HXAb8HHm3IOrc+5lNsY1t4B9qEgDNDr5SU1DbYhcsBzVzuEQUuWUBeYTz
         XiHMO8a9kY0jB1M5dFTUesnI16MZbeckNWqYXgtRarCX9ZaHSVWWra7bI4+rYPvPhUIl
         9vEtgqZY9CzvRB4UPRyTcJ5Yt+dibHkA+VN+Q0+kek+6706YGh9tURJzBO9lFelKMcy0
         BaOg==
X-Gm-Message-State: AOAM532gqVpGmYdU7hTofyYMX1Oa+ngpOxUWaPEUrZco4pevfRFkj4hi
        RZntZYxzZs4OpTatnurO9o31hfMt8LI=
X-Google-Smtp-Source: ABdhPJxuHJTmr1GxwWUcWheIXNCf3m8mJAo1j0i65kYI/3qiFoAZyRplqftcbDaB/Cl4LldSCf30Mg==
X-Received: by 2002:a05:6830:270a:: with SMTP id j10mr1158093otu.26.1623379216903;
        Thu, 10 Jun 2021 19:40:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id u1sm884215ooo.18.2021.06.10.19.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:40:16 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] devlink: Add optional controller user
 input
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210607192406.14884-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a673776a-7bc9-2253-d6ea-68474c56bd49@gmail.com>
Date:   Thu, 10 Jun 2021 20:40:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607192406.14884-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 1:24 PM, Parav Pandit wrote:
> A user optionally provides the external controller number when user
> wants to create devlink port for the external controller.
> 
> An example on eswitch system:
> $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> 
> $ devlink port show
> pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
> pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00
> 
> $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
> pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
> changelog:
> v1->v2: (addresssed comments from David)
>  - split the command help output and man page to multiple lines to make it readable
> ---
>  devlink/devlink.c       | 21 ++++++++++++++++++---
>  man/man8/devlink-port.8 | 21 +++++++++++++++++++++
>  2 files changed, 39 insertions(+), 3 deletions(-)
> 

applied to iproute2-next, but ...

> @@ -3795,7 +3806,9 @@ static void cmd_port_help(void)
>  	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>  	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
>  	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
> -	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
> +	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM\n"
> +	       "                      [ sfnum SFNUM ]\n"
> +	       "                      [ controller CNUM ]\n");


I put both of those lines on 1 since they fit within 80. Same below.


