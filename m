Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7FE84473
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfHGG1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:27:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39296 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfHGG1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:27:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so36935963wrt.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 23:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=czeL7gzsUMRzo/Jt+STyFtHUuF19U8IeZiP5WR2awkI=;
        b=f/l8SMfjT0VdI9v2e+CljN8/a1R0vrCZT+Vr9OaZPYFKzxc51gj/O/3vQkYNIyBHAT
         6ighreT8WD29pfO49DeaxjTV7BGuyKpOe3vR+aNZPzvHbGB7g1Q1Q4aev+NJ2PmXyfrc
         qLpbEJpVL64KjZjYZttPF7pYWgjQkoAP2u0ovmNGBz1GDSyP2bLWwYtc1wOWDH0blU87
         D8tLGZGmZ6vvG9P0b11uQ2zeVE7yLqjHqDDZSdh/h2+rNhv3C7CZUz9MqPyU0LrosXlj
         PiYYN0XoOj41JByz/uELt9Osn0x60ozguskWMQndCo72zzyRo7v7ObxWftpVT1R4aIW/
         ZwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=czeL7gzsUMRzo/Jt+STyFtHUuF19U8IeZiP5WR2awkI=;
        b=epWOtMwZoF8LvFwNPMrPuBEth7aG++5pcVhDDX/6EsZG40z0Iu59aOuSuMfXxn8l0E
         EyeSfM1dhFw/41+pQSj+l3t0w+412iYECuPrKCEHFZudV/0GmAZke5945pXXorxWIrgN
         Ioq5FXodbZytVGLXGl78Oa8dYnlyTjF7UeNPatx6Cx+PWgCv6vYi5FH5o56oNKcPD9Ez
         KyAYPvivQIBPhL6auS1o8UQqNywClWidqhVARNA0jmW0+AZqklp82vGOnG5YPgpMXh7+
         m/G1R/FI5nXm5ycw5M50oiSVBrNZmFgM9DVr/K4o/f/Z3cDVKSt/ax7/UCBtK+nqGr/T
         eQZA==
X-Gm-Message-State: APjAAAXtmYBR4VOykiAnF/JZnxSZ2xWf8M87J2xwVxw3nBFFRsjMqJ7l
        vyLulWPrJCbCeNENreAPQhR6Bg==
X-Google-Smtp-Source: APXvYqyoneUoQY91P68UoSszA4cKuHMfF5eSTEAEzKgl3I5/9TK0fi4baUECakc95vMN2ZwsVjz1bQ==
X-Received: by 2002:a5d:5183:: with SMTP id k3mr4380787wrv.270.1565159233466;
        Tue, 06 Aug 2019 23:27:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e19sm125181195wra.71.2019.08.06.23.27.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 23:27:12 -0700 (PDT)
Date:   Wed, 7 Aug 2019 08:27:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190807062712.GE2332@nanopsycho.orion>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190806153214.25203a68@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806153214.25203a68@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 07, 2019 at 12:32:14AM CEST, jakub.kicinski@netronome.com wrote:
>On Tue,  6 Aug 2019 12:15:17 -0700, David Ahern wrote:
>> From: David Ahern <dsahern@gmail.com>
>> 
>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>> tracked fib entries and rules per network namespace. Restore that behavior.
>> 
>> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>
>Thanks.
>
>Let's see what Jiri says, but to me this patch seems to indeed restore
>the original per-namespace accounting when the more natural way forward
>may perhaps be to make nsim only count the fib entries where

I think that:
1) netdevsim is a glorified dummy device for testing kernel api, not for
   configuring per-namespace resource limitation.
2) If the conclusion os to use devlink instead of cgroups for resourse
   limitations, it should be done in a separate code, not in netdevsim.

I would definitelly want to wait what is the result of discussion around 2)
first. But one way or another netdevsim code should not do this, I would
like to cutout the fib limitations from it instead, just to expose the
setup resource limits through debugfs like the rest of the configuration
of netdevsim.


>
>	fib_info->net == devlink_net(devlink)
>
>> -void nsim_fib_destroy(struct nsim_fib_data *data)
>> +int nsim_fib_init(void)
>>  {
>> -	unregister_fib_notifier(&data->fib_nb);
>> -	kfree(data);
>> +	int err;
>> +
>> +	err = register_pernet_subsys(&nsim_fib_net_ops);
>> +	if (err < 0) {
>> +		pr_err("Failed to register pernet subsystem\n");
>> +		goto err_out;
>> +	}
>> +
>> +	err = register_fib_notifier(&nsim_fib_nb, nsim_fib_dump_inconsistent);
>> +	if (err < 0) {
>> +		pr_err("Failed to register fib notifier\n");
>
>		unregister_pernet_subsys(&nsim_fib_net_ops);
>?
>
>> +		goto err_out;
>> +	}
>> +
>> +err_out:
>> +	return err;
>>  }
