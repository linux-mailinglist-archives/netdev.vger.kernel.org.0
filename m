Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7B16EAF8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfGSTRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:17:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35814 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfGSTRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:17:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id y4so33277924wrm.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 12:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=01NunnF5DspAyT9FSHO7UygQuDLQFC+bQL7CGkoYxZk=;
        b=2QdQW5c0XoddczKPHNSRi4xH505DxLbN2LbIbC839FO7plDg6I2IN06cdX5MwhSG1W
         bxgDi5iW0wVeGiKSxSRbjDg5pn8fDpBnIvnF2Aa0dhyQRQoJpSahHyf0p8sJGksPLBAk
         bJuFQ04YyU9IfJV2AZKyvuFb+qg8Q7VjFpC3DMuNBczz0SE3HD1/a+OZXUxXKpJf04XT
         kRssNpH7YUo7IEmRiH5kAE8tJdCzAktUPC9zSsw5R5kILMTMuAcUcT5am2quQ6n4kzDj
         TpIFxXJ20q3N+MUJT+E7LKa35RuEJqv5zMD+sQHMpGjw+C1zXaWx3g5h/WFf0gHnon32
         thLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=01NunnF5DspAyT9FSHO7UygQuDLQFC+bQL7CGkoYxZk=;
        b=eXMdpWnNiqDTWH3bYn/OFNoZgXvUwLAuYBydZQxMPKswHe0I2tOEIotQbhGr6u+zD2
         YG7w6xgRxNxFZ3PSkEKr/JZZQP5UTzGPKfidEj95F/Z5f2uVZCF36MzNo/y5Ab0bOhiu
         dOt+QYIr637t60Bj7x/y1AqE2CV9WbmAsjl9DBrQIHF1ILZfyn+N6VuoGeqZEu2wUYGD
         YtO14pm4/NaSw/lAg+3sRsV4qhm9GnEh9CJDysgugtDySsnOD/OQABv6+ZJUjjiHEHzQ
         uEsDDQc54SsZIVOKlsK/QsFg/tllvjbMWAdlQvpUnXyzcKKAWxglfYr+EJ+JCL/6qW6q
         uNyg==
X-Gm-Message-State: APjAAAUD5QAch/3xZZQaGVQ8Nr1DkwD2oXzVtBSfpwicpAUP7IJvuCcg
        GU+NlDc9T4yvZiherx1p7CA=
X-Google-Smtp-Source: APXvYqz4om/pExG0eocKzHfcZ+Ol6Y00mI6qCeR1RnfVARjSlVB5QXw2OZwV6gK3rbmGraJvXOPnYw==
X-Received: by 2002:adf:d4c6:: with SMTP id w6mr58833688wrk.98.1563563861755;
        Fri, 19 Jul 2019 12:17:41 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id g2sm28418791wmh.0.2019.07.19.12.17.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 12:17:41 -0700 (PDT)
Date:   Fri, 19 Jul 2019 21:17:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 2/7] net: introduce name_node struct to be
 used in hashlist
Message-ID: <20190719191740.GF2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-3-jiri@resnulli.us>
 <20190719092936.60c2d925@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719092936.60c2d925@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 19, 2019 at 06:29:36PM CEST, stephen@networkplumber.org wrote:
>On Fri, 19 Jul 2019 13:00:24 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/linux/netdevice.h | 10 +++-
>>  net/core/dev.c            | 96 +++++++++++++++++++++++++++++++--------
>>  2 files changed, 86 insertions(+), 20 deletions(-)
>> 
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 88292953aa6f..74f99f127b0e 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -918,6 +918,12 @@ struct dev_ifalias {
>>  struct devlink;
>>  struct tlsdev_ops;
>>  
>> +struct netdev_name_node {
>> +	struct hlist_node hlist;
>> +	struct net_device *dev;
>> +	char *name
>
>You probably can make this const char *

I'll try.

>
>Do you want to add __rcu to this list?

Which list?

