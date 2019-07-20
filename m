Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD06EE2C
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfGTHUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 03:20:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42364 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfGTHUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 03:20:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so19270881wrr.9
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 00:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ScW+0PcDu4KelPANIykOmM3CiVs5QuE4shI+yLJU0tk=;
        b=HP5zdP9QIKpxVGDC5jVGtCicu06lm0c+8gtJXsQ+kefgNg0jQNy1KXO9qIxM5M44yO
         +R9Kyz8LRL6NNeusTTI4Gkpc3OiSMFnufNx1uSkHSRxvfmTQ2mYbHuX5nolJTKgP7yeP
         QZu+QXkh+i5a8bKVD/w0JVjoOPL1K3HzEdPwNkXqC0NB2qGN+rQcj2aXXp7ircVTRwfx
         VpZzDIiz52Ozt+nixeTFxAilLLFdi4NhF5T5t02zWJd7JTVvW717FTfTanCszsfFp1J3
         SZUisNtp4ajYjehwG2kYk1G1vT4+d9TVV5GMUdHDXhp2LDJfDhOu5t5v2pv2UEYKh1kR
         B6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ScW+0PcDu4KelPANIykOmM3CiVs5QuE4shI+yLJU0tk=;
        b=j7n6KcxH9Ef8i7B1Ld/ldbFdvmWw+sWDfUkhLhEBZNteXu0sQw0uQZ3YE7T6gHDzts
         MfoUIpzG9CYLVzbITeRQ6dtePKPNdISFQ/8JtfUosTCTgcrI++Nen/LQkJSrsp9z+aWo
         YhxX1FMUfaABFr1RSOVzUf38H4BokAoaebf8bDWdzAyk71GXoh0RwlbpcKI1o+oMpq6i
         FC1SGgtvq7A8fgkKZUfdtZezLbndZiZZcH3CQZFIzRNBFiYpmXsa3fcWl0XWiiQUNTPw
         eBrzUuyl6qJ2FfA5bt0RwNkHWptYTl1j8tMScGZr3XIsaJ5ic//1JWMDN+0RqT3rkxjX
         BvDQ==
X-Gm-Message-State: APjAAAXGmHcApOrRw94EUxHtn0k3kKlDKqNuN9adYbo3ROkk99huXDTq
        YepBTSqwTZekdlPus+LEOzA=
X-Google-Smtp-Source: APXvYqxDj0jkoGstWSduMginsozA+jO+sE76zvCsuu9XMNN40MvUwOT4pdTIQFIwV/SIeZ4KNiw4zw==
X-Received: by 2002:adf:e941:: with SMTP id m1mr51902555wrn.279.1563607239010;
        Sat, 20 Jul 2019 00:20:39 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id o7sm28352185wmc.36.2019.07.20.00.20.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 20 Jul 2019 00:20:38 -0700 (PDT)
Date:   Sat, 20 Jul 2019 09:20:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190720072037.GI2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <20190719205849.11d17192@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719205849.11d17192@cakuba>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 20, 2019 at 05:58:49AM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 19 Jul 2019 13:00:25 +0200, Jiri Pirko wrote:
>> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name)
>> +{
>> +	struct netdev_name_node *name_node;
>> +	struct net *net = dev_net(dev);
>> +
>> +	name_node = netdev_name_node_lookup(net, name);
>> +	if (!name_node)
>> +		return -ENOENT;
>> +	__netdev_name_node_alt_destroy(name_node);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(netdev_name_node_alt_destroy);
>
>I was surprised to see the exports are they strictly necessary?

Well I call them from net/core/rtnetlink.c, so yes. Maybe I'm missing
your point...


>Just wondering..
>
>> @@ -8258,6 +8313,7 @@ static void rollback_registered_many(struct list_head *head)
>>  		dev_uc_flush(dev);
>>  		dev_mc_flush(dev);
>>  
>> +		netdev_name_node_alt_flush(dev);
>>  		netdev_name_node_free(dev->name_node);
>>  
>>  		if (dev->netdev_ops->ndo_uninit)
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 1ee6460f8275..7a2010b16e10 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1750,6 +1750,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>  	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
>>  	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
>>  	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
>> +	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
>> +				    .len = ALTIFNAMSIZ - 1 },
>
>Should we set:
>
>	.strict_start_type = IFLA_ALT_IFNAME_MOD

Probably yes. Will add it.


>
>?
>
>>  };
>>  
>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
