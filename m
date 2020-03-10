Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC817F44B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:03:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44638 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJKD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:03:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id l18so4919358wru.11
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 03:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w0i3ZA8yYLfus2sazNviIPht9iUsan49CCwI1hgTEeU=;
        b=XbaSddJCe4UfI48BDrRYyLcJwFNUGrjXWTsOsPrhswOFIM/mBRuRmkckgnHeJX6VjD
         0xfDJ4aLlbYHhHbp+X7nKdzaeqmuvyKIh8R4VZFwMsXyfkdZUl83R+uwC7iWMKJFMJD3
         cnlVL/4mIu0ZCm6DCBFbf6MzWqTdVkw8BZJkcK+y1vl9kdjqU+o04uObIxtp7biAXX9k
         /MaRZsNinoCzz+rRZJ2HkteKRHGQIMsYtEoJw2z6sB6HjfBEruG+EXWQ2v7KY0ecFxr/
         5COhEzn1O/w5hda+95/WYdy0CFJL+vYb+ZEM3SpPaOJVNiyN/tI1zTyAjEMA1pKvufW3
         +vgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w0i3ZA8yYLfus2sazNviIPht9iUsan49CCwI1hgTEeU=;
        b=txk6GJkaotg5eu+GpL9BzmxV9fEezxygzNQFmrFwCf2kg/zs1JycasdqFGYADvsBHg
         QRO7sBeCOakwYX2V78dwLmjgnco3iStvFiwFI1/AHvSeQUpZslru/RpvCh1A9fxJA8hD
         +sUW4NH+zl60OlJhvGABxNMzwfY8nZObPLkSR0mGkL61BAH7Y+2077sAnODVHBi8CkSy
         ELXyA7KzIDIjgdFMGUAMSeXXsb0nWiQXZfN5b2OUUcJP29BKf+6yurZy1aGHuPNOJGAD
         5+d9aqRnz3/WXnIf9+Srl3DRJDjyeYqT9VMkXX7T9wN0+9bQXDqMhcH9edNwUbjbYBJp
         +/7g==
X-Gm-Message-State: ANhLgQ19AM5L4Ttknogc/dps+XqogQf0ofwf0FA/0V3MDMbn+1fJKDHJ
        DjsJZGesgtq3i7kt+KLgZSaIcg==
X-Google-Smtp-Source: ADFU+vtXtuidCYPbnIdH8xphNpdZjoXXE8Nj+dc+/6ZtDzPl+nzQz0VRFHkjHH/0QJJcRsmh3Zor/A==
X-Received: by 2002:a05:6000:12c6:: with SMTP id l6mr27906395wrx.217.1583834634364;
        Tue, 10 Mar 2020 03:03:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id k2sm34642940wrn.57.2020.03.10.03.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 03:03:53 -0700 (PDT)
Date:   Tue, 10 Mar 2020 11:03:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
Message-ID: <20200310100352.GA2211@nanopsycho>
References: <20200309174447.6352-1-jiri@resnulli.us>
 <20200309183325.yw2c4swbwv7xqlm2@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309183325.yw2c4swbwv7xqlm2@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 07:33:25PM CET, pablo@netfilter.org wrote:
>On Mon, Mar 09, 2020 at 06:44:47PM +0100, Jiri Pirko wrote:
>> Instead of manually iterating over entries, use flow_action_for_each
>> helper. Move the helper and wrap it to fit to 80 cols on the way.
>> 
>> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
>> ---
>>  include/net/flow_offload.h | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 64807aa03cee..7b7bd9215156 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -256,6 +256,11 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
>>  	return action->num_entries == 1;
>>  }
>>  
>> +#define flow_action_for_each(__i, __act, __actions)			\
>> +        for (__i = 0, __act = &(__actions)->entries[0];			\
>> +	     __i < (__actions)->num_entries;				\
>> +	     __act = &(__actions)->entries[++__i])
>> +
>>  static inline bool
>>  flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>>  				       struct netlink_ext_ack *extack)
>> @@ -267,7 +272,7 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>>  	if (flow_offload_has_one_action(action))
>>  		return true;
>>  
>> -	for (i = 0; i < action->num_entries; i++) {
>> +	flow_action_for_each(i, action_entry, action) {
>>  		action_entry = &action->entries[i];
>                ^^^
>
>action_entry is set twice, right? One from flow_action_for_each() and
>again here. You can probably remove this line too.

Correct. Will send v2

