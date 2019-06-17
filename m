Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450254779A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfFQB1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:27:15 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45736 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFQB1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 21:27:15 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so17584523ioc.12
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 18:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=13AwZqbotSg79vPxim68wvGgTKowboMyFl+YMc3GMFk=;
        b=JASj+7Xl70YwVOsXqTFj46lNOoC9OaIbex3ivV7gFo0t4o9SbxYBX4q28wlk3Uzot5
         BkiEmOuWH7M+ZnzVTrF2BgAy6KcZuWhEOZjdBu7hXXDzqFcEjPwY559bY8Ijch/0Qxs2
         a2XXlnq2bZGZTDGgPs5t8xvpGRPnYNchJtoY1moOL7xha7NDipf1aoYbCdgVBDhF412x
         uod/BBLHHYD+95J9jrCGqFBBwQCdWR1Hxdf2fSNvdu6jIbrEw7uWtiCyxFFwEyPSXu1s
         zX9XsVBMIRlghfqHUxrIFzSvjh9Tkn4BhRGUQnDNGeLz2+M+JfOl9rWnuC3guHlQyjXh
         t79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=13AwZqbotSg79vPxim68wvGgTKowboMyFl+YMc3GMFk=;
        b=LB7YJv4FbXr8V6hKepI4k2DdGZsEbfQGlXShH2JGjwEFJxr4aVrm6Br2PCrGl4omII
         C1CQrSyq2/0qwqneWOFpvkUk4+SPDVIiz4nWRtU1UY1g/WmVbC5commk9IwX50O8ZaSQ
         fmUEtwDqEYvulyMhQGV6MWQDOheB9W40FI1Nu/HXk6CZ8VfN81l85TQKcQ2CYYiu3BYA
         ebpsP6Q37lFPWzSPyhGRFdJn50Khi+P+Kv3u30/prgUti1zhjKWIObCGysieEmbxC4kA
         ZEzItcdmHSaXJT1uwSTcP/CxYttOAucuojJeT/15OqdPudaC639tWqxSc9R1j/K6kwnD
         wPrA==
X-Gm-Message-State: APjAAAXCJJyKqEhCKhF2Xv0w21AYtAZoYq3weEGzAEOEfDXB0vEwXbSo
        Rah123/gKD63YjVFL5hRS24=
X-Google-Smtp-Source: APXvYqxCHDE6nQSsJP0LHFXAbQEgQNBSRv4IekpYvBla0Y9WtkZnUSUNMe8rB756e5dgmaYjW1h3iw==
X-Received: by 2002:a6b:cf17:: with SMTP id o23mr22102591ioa.176.1560734834629;
        Sun, 16 Jun 2019 18:27:14 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:e47c:7f99:12d2:ca2e? ([2601:282:800:fd80:e47c:7f99:12d2:ca2e])
        by smtp.googlemail.com with ESMTPSA id u26sm12790172iol.1.2019.06.16.18.27.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 18:27:13 -0700 (PDT)
Subject: Re: [PATCH net-next 08/17] netdevsim: Adjust accounting for IPv6
 multipath notifications
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-9-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <25bb06eb-bd2a-de85-9903-19215703363a@gmail.com>
Date:   Sun, 16 Jun 2019 19:27:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-9-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
> index 83ba5113210d..6e5498ef3855 100644
> --- a/drivers/net/netdevsim/fib.c
> +++ b/drivers/net/netdevsim/fib.c
> @@ -137,19 +137,20 @@ static int nsim_fib_rule_event(struct nsim_fib_data *data,
>  }
>  
>  static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
> +			    unsigned int num_rt,
>  			    struct netlink_ext_ack *extack)
>  {
>  	int err = 0;
>  
>  	if (add) {
> -		if (entry->num < entry->max) {
> -			entry->num++;
> +		if (entry->num + num_rt < entry->max) {
> +			entry->num += num_rt;
>  		} else {
>  			err = -ENOSPC;
>  			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
>  		}
>  	} else {
> -		entry->num--;
> +		entry->num -= num_rt;
>  	}
>  
>  	return err;
> @@ -159,14 +160,20 @@ static int nsim_fib_event(struct nsim_fib_data *data,
>  			  struct fib_notifier_info *info, bool add)
>  {
>  	struct netlink_ext_ack *extack = info->extack;
> +	struct fib6_entry_notifier_info *fen6_info;
> +	unsigned int num_rt = 1;
>  	int err = 0;
>  
>  	switch (info->family) {
>  	case AF_INET:
> -		err = nsim_fib_account(&data->ipv4.fib, add, extack);
> +		err = nsim_fib_account(&data->ipv4.fib, add, num_rt, extack);
>  		break;
>  	case AF_INET6:
> -		err = nsim_fib_account(&data->ipv6.fib, add, extack);
> +		fen6_info = container_of(info, struct fib6_entry_notifier_info,
> +					 info);
> +		if (fen6_info->multipath_rt)
> +			num_rt = fen6_info->nsiblings + 1;
> +		err = nsim_fib_account(&data->ipv6.fib, add, num_rt, extack);

The intention of the original patch was to account for a multipath route
as 1 entry, not N where N is the number of paths.
