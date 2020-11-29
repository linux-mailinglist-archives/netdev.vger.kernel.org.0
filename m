Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9312C7B58
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgK2VQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgK2VQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 16:16:33 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8698FC0613D2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:15:53 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id f5so9432392ilj.9
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 13:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Fa8gQLX4dGJGce7a+u4pwmf5Fr+zChMR4eyBDSsglaU=;
        b=lIHGi/eBrmqDYaRauBPIF+sJ3gwdAmTpoRZ8dDZnBrYnMEp5w618+HOe/Kg+H1vj1r
         FjetC1h/USELsIT571HZY9tOm7k2CA2iBYHkG1UQncTwdsknVpazFCwFukcPumT0aWK1
         5VIVcaC/u5Kp1BDzg2xohFkGlZv/UHiH7I3OomfqzAA1ZkBJ/JELvHLTBAkdC1fMc78R
         pVWFGtbEEdk5pGVY8FswEW17PiVDiG23FSUwjywz/r3Y5RvyuQUQo9M4PEna/crIktbp
         u4hcq6B24X1AXOhCeKPWnudDaFySp5pcqhf7cEt6ielFQXkTStlzFfGUhD4J3rjIrZty
         n+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fa8gQLX4dGJGce7a+u4pwmf5Fr+zChMR4eyBDSsglaU=;
        b=J1IUPrwvSZX5xOfCATdtX5hiyGC+vxpdVLmxVfeOaptjI1GW5/nUGtaxc/myYys9Cb
         YgoQXWBcCA/MFnutGOqdwfQ77yQZ+kjEuSpGH6vsHFEKA3VGhvI91CS9T7gDkbEP34ld
         t3US2Jmk76umuhbF601YxRRQg7MWHfrvcplrF1BMgldAAa7i5BKbDeTw6RhvVKH8WyeG
         CkseGBmQlkVURCXHO5YQEB1c0QtKRKNqh8c4SK27RHxmN5TTNwl6u9xezsqZJf+5Zmvd
         Q3abIS1Srjy4Vb2IsxRLKCfWMb3F67DsN+tfqeYXSPFaB0/pvTCu8U8tuFeVGdHjJ1cf
         Kn/Q==
X-Gm-Message-State: AOAM531p37dT9c1MKk1IU0HajV5wgGWwFq1tYhfyIb34eNcyLXle7GHQ
        mdTk0Bx++ooWWqqUNFLQUZMj2fQIu0U=
X-Google-Smtp-Source: ABdhPJwt1LCvSiCM1fVpCQR4ObsKPxoLxyKMEc96C7EUMxTCiHP0wVgxSHfrCZ5axW6j27zfQGrfew==
X-Received: by 2002:a92:aacd:: with SMTP id p74mr15912360ill.273.1606684552903;
        Sun, 29 Nov 2020 13:15:52 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id q11sm3217380iop.41.2020.11.29.13.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 13:15:52 -0800 (PST)
Subject: Re: [PATCH iproute2-net 2/3] devlink: Add pr_out_dev() helper
 function
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-3-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f44cc093-2199-7e94-561a-a9450511293a@gmail.com>
Date:   Sun, 29 Nov 2020 14:15:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606389296-3906-3-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 4:14 AM, Moshe Shemesh wrote:
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index a9ba0072..bd588869 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -2974,17 +2974,11 @@ static int cmd_dev_param(struct dl *dl)
>  	pr_err("Command \"%s\" not found\n", dl_argv(dl));
>  	return -ENOENT;
>  }
> -static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
> +
> +static void pr_out_dev(struct dl *dl, struct nlattr **tb)

why 'pr_out_dev'? there is no 'dev' argument.

>  {
> -	struct dl *dl = data;
> -	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
> -	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>  	uint8_t reload_failed = 0;
>  
> -	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
> -	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
> -		return MNL_CB_ERROR;
> -
>  	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
>  		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
>  
