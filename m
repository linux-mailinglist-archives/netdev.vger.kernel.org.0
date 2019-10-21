Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33245DF116
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfJUPRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:17:46 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:40335 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfJUPRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:17:46 -0400
Received: by mail-il1-f196.google.com with SMTP id d83so3863632ilk.7
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 08:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bvOQv6TKKJAffihvh5aqc9jmGCD7PMu53QgDmyiXZ5o=;
        b=DCE14uBW2/5aYPNJh0VG6ID+3wf3mC7e73qRZbFoRjO2Ei95dNThY3/rvNM98Mm7O/
         6CYmyhGTc3n/E2kxQ0ZuXkKifeR/x1Z9qTrGHDWk7Zt/zs/KGlQtxxZX/gsa5SZmYD7u
         SsNJcUY5xqXhWTZRqORlARdvyBEaet3vg5XX3fsgh+ZAGFITZF7aIEzsu8Q9l4ZNWRFF
         a9gD+/14hcArsUX198a5F++4ixl1FUoOdXHP7gdO0uDrAm20UuzUYwAQkNDc0T516RXN
         FQ1Rf9KebBAaq20KxpM0YO4/VPRbXLLEdLFzbIDwM5p5D/CV7Dnshesb/vWC4H2ixcG/
         ztCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvOQv6TKKJAffihvh5aqc9jmGCD7PMu53QgDmyiXZ5o=;
        b=S0P8I6RJ3DfmjzxJvGECnzElC/rIDDJcqFrCJ2bLxHl8Tt9CLA8uBgi6I8Kd7Bc0zt
         7B9804J2AXgeqeSlK1ZOpn6igSS3nXh78sIo92pfg7aAlImEAHbd62+UOK2pN5mMCPsP
         k8JLS3ZVQJ4eDP/Ej/OwpVWTkdByQrwIrYvv2LdqSYOM+6S/E3s4sUyJV4nVGxlVMOoF
         52y/BgThZ5t7qa8BJZfXjsbVKbn8sX0+qVbZqu6SS3JudgM5r0xPefZZKPsZdGPlMWGz
         8AWn/kGjJ2qyKr/G3da1E+GljuR4F39oNcTKo+Tg89dC4ayZLJamNHifsOPXwNearEqq
         lrcQ==
X-Gm-Message-State: APjAAAVVV1Kx5LVBAGZc7hFqMOzCK3H3pVqD0yWLeIYm7pnET6ED65LM
        zU0Y2oHT942+LElCD92dm/U=
X-Google-Smtp-Source: APXvYqyEZk7NGqW1/vhj/wm1NqUb7zsZe1V41tkl0PS/TyEJAbS1JmDHckdfxdN2BzBhvkhde5oyHw==
X-Received: by 2002:a92:5b98:: with SMTP id c24mr25039884ilg.158.1571671065861;
        Mon, 21 Oct 2019 08:17:45 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:7597:dfa8:dfb:f346])
        by smtp.googlemail.com with ESMTPSA id u124sm4830830ioe.63.2019.10.21.08.17.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:17:44 -0700 (PDT)
Subject: Re: [patch net-next v3 2/3] devlink: replace spaces in dpipe field
 names
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43e9c782-a5a0-0ee4-8bb3-db610884ce96@gmail.com>
Date:   Mon, 21 Oct 2019 09:17:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021142613.26657-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 8:26 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> To be aligned with upcoming formatting restrictions, replace spaces
> in dpipe filed names to underscores.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v2->v3:
> - new patch
> ---
>  net/core/devlink.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 97e9a2246929..45b6a9a964f6 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -33,7 +33,7 @@
>  
>  static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
>  	{
> -		.name = "destination mac",
> +		.name = "destination_mac",
>  		.id = DEVLINK_DPIPE_FIELD_ETHERNET_DST_MAC,
>  		.bitwidth = 48,
>  	},
> @@ -50,7 +50,7 @@ EXPORT_SYMBOL(devlink_dpipe_header_ethernet);
>  
>  static struct devlink_dpipe_field devlink_dpipe_fields_ipv4[] = {
>  	{
> -		.name = "destination ip",
> +		.name = "destination_ip",
>  		.id = DEVLINK_DPIPE_FIELD_IPV4_DST_IP,
>  		.bitwidth = 32,
>  	},
> @@ -67,7 +67,7 @@ EXPORT_SYMBOL(devlink_dpipe_header_ipv4);
>  
>  static struct devlink_dpipe_field devlink_dpipe_fields_ipv6[] = {
>  	{
> -		.name = "destination ip",
> +		.name = "destination_ip",
>  		.id = DEVLINK_DPIPE_FIELD_IPV6_DST_IP,
>  		.bitwidth = 128,
>  	},
> 

These are all exposed to userspace, so changing this format breaks
existing users
