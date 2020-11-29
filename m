Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59702C7B5F
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgK2VXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK2VXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 16:23:46 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A67C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:23:00 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z5so9811137iob.11
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xVLBfte4bzmDJsIa9DrwgMM0SzcWaOB2uuTfusSzLjc=;
        b=dH3+Q4uh/QarYhB2jlL2MCOprcL5pxFoQtLwBdMINh87XvOuBniFsdgvF/UReJ1aHE
         dlU3haZj0jkhBmFVA4TL0zw2ezyA7+yvWHps8uBlV+gn8l7gMS4sgNTPcUUIeOWTTFdE
         Shm0TipDWU7W5SLgd4Tvo6RWkLWZiNcDro3FkUYBmEuEDS/+mRvHk7gULXNB8IoisrKV
         iFSjHSXChSfs00J8paTFX43tBVKiT6J5ZkAe6BBeVq8Dq5Qdu4GG7EpaxRjuxGOjWA8c
         wLW/rN3aXx15jL1zCUXxr/gWuKi431c1PXjIeo0cc12iaC6PyG+kvQYInqoXzec9qjY7
         lT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xVLBfte4bzmDJsIa9DrwgMM0SzcWaOB2uuTfusSzLjc=;
        b=jwo44mnuWHENdqcmBnRgiyOC2Fs/6vhQIdVMeNSSJXub+zWG4AVVf0BsMCTC7xnKnm
         duSf5ogex+kAX1nd1L9LN33vVAsYGNBwlOYfVAStTeG2aggBADMssgU1P7vCod0+5MkG
         vopduA8y3x5vhXsyKmWH2aCDGAGB1uiiQHyDoc5nuv4v50FDXeDK5trrLX4ZYXfVxKIu
         X4z16LmUAcEk9rGoIscxY0RrC5ufagpAyuPnt3C+BNqBnFY9Zc273bRZoZHe5h8QPJqw
         8XF6eC6UJwVRyLNaI9KiojjWz3+xZa1cSskrPn7LVDcxdbdwR6gi14LNxGU0EBcl4MM8
         DMeA==
X-Gm-Message-State: AOAM533boB1gbauy2L6o86jNbiyUmgaVbnNtsb/s5NfxV+iNtpKSqfVl
        qe5eQxERq7qD1KJv3C8EGaS4vgZM+zo=
X-Google-Smtp-Source: ABdhPJxNQRpatDQaFrdPmOxwMQ/QbMh73P/MqzpgmDwRUtR6HuxErptC3F0SxTA66HpSacoVDvf6Jw==
X-Received: by 2002:a6b:b44f:: with SMTP id d76mr12748940iof.87.1606684980110;
        Sun, 29 Nov 2020 13:23:00 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id n16sm8734594ilj.19.2020.11.29.13.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 13:22:59 -0800 (PST)
Subject: Re: [PATCH iproute2-net 3/3] devlink: Add reload stats to dev show
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-4-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <505ce6cb-be99-3972-a882-4baeeeece216@gmail.com>
Date:   Sun, 29 Nov 2020 14:22:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606389296-3906-4-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 4:14 AM, Moshe Shemesh wrote:
> @@ -2975,17 +2996,93 @@ static int cmd_dev_param(struct dl *dl)
>  	return -ENOENT;
>  }
>  
> -static void pr_out_dev(struct dl *dl, struct nlattr **tb)
> +static void pr_out_action_stats(struct dl *dl, struct nlattr *action_stats)
> +{
> +	struct nlattr *tb_stats_entry[DEVLINK_ATTR_MAX + 1] = {};
> +	struct nlattr *reload_stats_entry;
> +	enum devlink_reload_limit limit;
> +	uint32_t value;
> +	int err;
> +
> +	mnl_attr_for_each_nested(reload_stats_entry, action_stats) {
> +		err = mnl_attr_parse_nested(reload_stats_entry, attr_cb, tb_stats_entry);

wrap lines at 80 columns unless it is a print statement.

> +		if (err != MNL_CB_OK)
> +			return;
> +		if (!tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT] ||
> +		    !tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE])
> +			return;
> +
> +		check_indent_newline(dl);
> +		limit = mnl_attr_get_u8(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT]);
> +		value = mnl_attr_get_u32(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE]);

Use temp variables for the attributes to make the code readable.

> +		print_uint_name_value(reload_limit_name(limit), value);
> +	}
> +}
> +

that applies to all of the patches.

