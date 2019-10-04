Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF5CCB467
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 08:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbfJDGUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 02:20:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33784 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbfJDGUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 02:20:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so5588662wrs.0
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 23:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BjF41KjGwXjgey5sXEdKsTLFj1fsCQ3TB0+JiS0QwnA=;
        b=epCNTfmuIN33hIbgLvoUV61Iwj3TnVv/663wvQdVygR19tZ6AKzr3Qt0hayFggJLEB
         xA80uO/4XYusRckUm+8vZY+sPscuhWrFYJeGVM+0MWF/IE+uM1Z1P3eiIqBHXcjIW7NE
         4qL3OfMVcJzzdasG2lrfkDK3CJjd11hovPknzDM9g0WlPszZZNnkZOfFSQA9kMnUrz4G
         ljR29DG30v7OHwfWqB0p9WDByWTAiGu+ZXqxuecQg313tu5967PESjzNM5hWrrB5H7om
         ezJVWqdXmq0lFI3EhKap0Ns8dWzIztiJv0jCxQx+Az9AsS+a21e7kHOEJzrB8bMGjXTT
         pZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BjF41KjGwXjgey5sXEdKsTLFj1fsCQ3TB0+JiS0QwnA=;
        b=QbeiEbK4nn6E2nO0Wh+DOuPebM+vHNwmGUOJ+wjAakaBxomEyFG5RvKC8yK9Uw0KNK
         jP1HGNjfKb45speJ/s3Uvq17vQ+OSlzL7bIXK5TmdscmPcJYuL6+UIZ0AeQtgm+eYOv/
         a3gB+4oH2FcCyEoyeBy6CvPj7UReT8IMTWmwolvCHEW2ZBTdIiFLaqFa+oP0Y05N4UMk
         vwrGhbIj+z25QhxM5aThrQnnQ7SKbENqNU+b8wZaZ5r6YEF+p2Hk+lTISKxJic86YZUn
         cXYakcdKbMKRP+LY/+0vYF9J8zcyApypaWyYq7ZBJ8B5ANeIEHueNlJr1oRbnmgrX6Vv
         DQsg==
X-Gm-Message-State: APjAAAVihtYaJUhDvz+M0r0LEfaLNSEhA0BpMW2MZVM6J17IHyTK/v/l
        k8Oj65w4aFo3cRH4E6e9Z4aucQ==
X-Google-Smtp-Source: APXvYqzAiLmL++h5ZmfJA8VDnWUVHsIEGB4SasFZcmHA+vqLSp3LE6Bb1f/Rjs6eEcmi8G2Rd8BKUA==
X-Received: by 2002:a05:6000:b:: with SMTP id h11mr10045337wrx.270.1570170002282;
        Thu, 03 Oct 2019 23:20:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h125sm8698644wmf.31.2019.10.03.23.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 23:20:01 -0700 (PDT)
Date:   Fri, 4 Oct 2019 08:20:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 12/15] netdevsim: register port netdevices
 into net of device
Message-ID: <20191004062001.GB2264@nanopsycho>
References: <20191003094940.9797-1-jiri@resnulli.us>
 <20191003094940.9797-13-jiri@resnulli.us>
 <20191003162121.0bfd2576@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003162121.0bfd2576@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 04, 2019 at 01:21:21AM CEST, jakub.kicinski@netronome.com wrote:
>On Thu,  3 Oct 2019 11:49:37 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Register newly created port netdevice into net namespace
>> that the parent device belongs to.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
>> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
>> index 0740940f41b1..2908e0a0d6e1 100644
>> --- a/drivers/net/netdevsim/netdev.c
>> +++ b/drivers/net/netdevsim/netdev.c
>> @@ -290,6 +290,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
>>  	if (!dev)
>>  		return ERR_PTR(-ENOMEM);
>>  
>> +	dev_net_set(dev, nsim_dev_net(nsim_dev));
>>  	ns = netdev_priv(dev);
>>  	ns->netdev = dev;
>>  	ns->nsim_dev = nsim_dev;
>> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> index 702d951fe160..198ca31cec94 100644
>> --- a/drivers/net/netdevsim/netdevsim.h
>> +++ b/drivers/net/netdevsim/netdevsim.h
>> @@ -164,6 +164,11 @@ struct nsim_dev {
>>  	struct devlink_region *dummy_region;
>>  };
>>  
>> +static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
>> +{
>> +	return devlink_net(priv_to_devlink(nsim_dev));
>> +}
>
>Slight overkill to have a single-use helper for this? ;)

I wanted the code to be nice, also it is aligned with what mlxsw is
doing.


>
>>  int nsim_dev_init(void);
>>  void nsim_dev_exit(void);
>>  int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
>
