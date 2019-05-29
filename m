Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B972E553
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2Tat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:30:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44484 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfE2Tat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:30:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id w13so2544429wru.11
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hqz2BJYzklaCL8ORspdQT+GmUS+8RmbmfmEFZTyCC84=;
        b=YbRlXecrtbCtUdKZcnqJg2Oxoo9rpPB1UF+J3QAdEBkgO45TuOGE7x5pTO3Db1l0Ps
         OFahPq4gbNlSd6N25fAHGJStKAp7x6Go9RJ8enSDiY1F8iQBcfrRNtbm9yBXy1b9xF90
         qSaIC6B3Go78CPEIO7zVhRDFgrnEUm/YQHn2GNajRb2KZs+wXGSZ3vECyodJbOcj33rg
         QcBnlbbEvolhci1s2LSq6ADfH28y2nuyf75jleiC3W6z2B51zX3Jrv/FE7oL2xGlXely
         KJ8EQh8kR7ZvR7zG4k32ZO2//TKqu7SvZAGz7XoXc4Y6TZSrtot8eoR4qS81YLWelmw1
         WMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hqz2BJYzklaCL8ORspdQT+GmUS+8RmbmfmEFZTyCC84=;
        b=tvMy9MgOFNl3yhlkuSTqmIIqvSkF66xSd7n9u+J4mLUqJ3rq92VbXwELDwGe3XnhjH
         2TXNjI5XDEjyDXQn7MzPlORhCVAQOyziHl3O31E3DJQzefyTFnq22ZbUqD6V7fa0oTWv
         F/WYR2RFYhY/0g6fcF260VLnATI0ZzXkGGqvxMYo7t4plqQO5+8FqiYeXCZYwTrOnHTB
         OENhUZ26bZAoTpemaT0e+1zRobzAPcUXSCIjWdwGwNzNyAQOs/BQM7HzWtjPgW6lA44q
         E1tYwFrhe7oN3yEJE7+I6NjpxGO81wtfgxbRF17+HYNunf42HoPDkDi8Nf1HzMn/NokT
         MNJA==
X-Gm-Message-State: APjAAAXoUiTakEKETNDL0QTwL6geKtVSueQwMRkCW5MwgWiIj66U3cQV
        JLYuvkEY2194NEPTibuzhAiC0A==
X-Google-Smtp-Source: APXvYqxdi3DhB3YtOwy5FHdMhpEjKALzT0jwWvNXrQGmfOjjI1ZOI/sGtjc/tFHccESQZuAPrloLoQ==
X-Received: by 2002:adf:feca:: with SMTP id q10mr6906614wrs.308.1559158247320;
        Wed, 29 May 2019 12:30:47 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id 205sm175907wmd.43.2019.05.29.12.30.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 12:30:46 -0700 (PDT)
Date:   Wed, 29 May 2019 21:30:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v2 7/7] netdevsim: implement fake flash updating
 with notifications
Message-ID: <20190529193045.GA4214@nanopsycho>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-8-jiri@resnulli.us>
 <20190528130115.5062c085@cakuba.netronome.com>
 <20190529080016.GD2252@nanopsycho>
 <20190529094754.49a15c20@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529094754.49a15c20@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 29, 2019 at 06:47:54PM CEST, jakub.kicinski@netronome.com wrote:
>On Wed, 29 May 2019 10:00:16 +0200, Jiri Pirko wrote:
>> Tue, May 28, 2019 at 10:01:15PM CEST, jakub.kicinski@netronome.com wrote:
>> >On Tue, 28 May 2019 13:48:46 +0200, Jiri Pirko wrote:  
>> >> From: Jiri Pirko <jiri@mellanox.com>
>> >> 
>> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> >> ---
>> >> v1->v2:
>> >> - added debugfs toggle to enable/disable flash status notifications  
>> >
>> >Could you please add a selftest making use of netdevsim code?  
>> 
>> How do you imagine the selftest should look like. What should it test
>> exactly?
>
>Well you're adding notifications, probably that the notifications
>arrive correctly?  Plus that devlink doesn't hung when there are no
>notifications.  It doesn't have to be a super advanced test, just
>exercising the code paths in the kernel is fine.
>
>In principle netdevsim is for testing and you add no tests, its not
>the first time you're doing this.

:/
Will add tests and send v3. Monday. Thanks!


>
>> >Sorry, I must have liked the feature so much first time I missed this :)
>> >  
>> >> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> >> index b509b941d5ca..c5c417a3c0ce 100644
>> >> --- a/drivers/net/netdevsim/dev.c
>> >> +++ b/drivers/net/netdevsim/dev.c
>> >> @@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
>> >>  	return 0;
>> >>  }
>> >>  
>> >> +#define NSIM_DEV_FLASH_SIZE 500000
>> >> +#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
>> >> +#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
>> >> +
>> >> +static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
>> >> +				 const char *component,
>> >> +				 struct netlink_ext_ack *extack)
>> >> +{
>> >> +	struct nsim_dev *nsim_dev = devlink_priv(devlink);
>> >> +	int i;
>> >> +
>> >> +	if (nsim_dev->fw_update_status) {
>> >> +		devlink_flash_update_begin_notify(devlink);
>> >> +		devlink_flash_update_status_notify(devlink,
>> >> +						   "Preparing to flash",
>> >> +						   component, 0, 0);
>> >> +	}
>> >> +
>> >> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
>> >> +		if (nsim_dev->fw_update_status)
>> >> +			devlink_flash_update_status_notify(devlink, "Flashing",
>> >> +							   component,
>> >> +							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
>> >> +							   NSIM_DEV_FLASH_SIZE);
>> >> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);  
>> >
>> >In automated testing it may be a little annoying if this takes > 5sec  
>> 
>> I wanted to emulate real device. I can make this 5 sec if you want, no
>> problem.
>
>Is my maths off?  The loop is 5 sec now:
>
> 500000 / 1000 * 10 ms = 5000 ms = 5 sec?

Ah, yes. Originally I had this 20 sec. Pardon me.
