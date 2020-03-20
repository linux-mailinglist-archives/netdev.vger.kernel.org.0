Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9356718CAFD
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgCTJ7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:59:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36825 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJ7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:59:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so640596wrs.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 02:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SiY9kDBs0z0Nf5mCC8x4/v3oQIlWffcoo0vCUWZ9XJE=;
        b=OMpxMtQeCEiun6T3I2vJJZtXZtc41T/G+fPrARuxuFZec7xeLVrMloFvOMrzkOL+25
         gDgPtSt+gVHdDy2oydOAr9ICMtUOTU0Tm4UqaOAyT8M9a2jjzqmT0bc1PjKw85dl0tBu
         C1dsdNcfTOg0MOBGdr1QjUm9oAyviBSqV/oAFQ2DSDP+U/b5PUwgrIMkbr0LZFXcyq4I
         m9VTh3pQ+e9SlfrkSDzuhHQkWz+RALenkHu3SYPUVxBji/xxnJwpKdIPIkK1h6TlcT39
         g6eNrZ7dahix4w1cJ9vV5qHVnyIWFHLDi/SjeS3ESJwejVfVeVuGqRSdJZEi3Lzife7U
         S0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SiY9kDBs0z0Nf5mCC8x4/v3oQIlWffcoo0vCUWZ9XJE=;
        b=YGKpsZzK2fvsY4z2ClYq4MfApEMQ5XOLdlGr3J3v67jQbBhMQSv7M/2hnn1H/78ZAG
         PRoWo9VIqE0XJAE9cjR+bBSXlwH7F3in+SY2nldRnzt8d78AYrR+UY1zxAPXPo1FTQcl
         qEXyEBZ7QvwK8TPGA9mIwoAJDF1gUj4hY4S73/uB4PwbgPut6q3npF8/I7HGnlnTPM4z
         g3MDPHqOWj2TSduKMW6pu/3N5NdNrndjj0oe6vBD6oRIL6C8sD89h6KdP6T3oEYo+4pr
         KnvFAVLkEG2WZbBA1DV7K2VzzwqMKcgFLKeoGG68CSPwLYZCfkcJsOYYTFu6C8JeWe5t
         5H0A==
X-Gm-Message-State: ANhLgQ32JcL/MjHNIWzg/KI/EsCbPL6iPe3j10U2goqQ+mvzG5TTVBkT
        RzN1VJvCbJwdfA90Ha5rcjn9+A==
X-Google-Smtp-Source: ADFU+vvea117yggrIKDrghp/sxYMHEZD0Kw7kb9SZND4GkraQp2eMkAvym16Eu07udF5076EEfA0PQ==
X-Received: by 2002:adf:ea4c:: with SMTP id j12mr9715892wrn.167.1584698375233;
        Fri, 20 Mar 2020 02:59:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s131sm7081010wmf.35.2020.03.20.02.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 02:59:34 -0700 (PDT)
Date:   Fri, 20 Mar 2020 10:59:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next v5] tc: m_action: introduce support for
 hw stats type
Message-ID: <20200320095934.GH11304@nanopsycho.orion>
References: <20200314092548.27793-1-jiri@resnulli.us>
 <ee32e79b-5db3-f6e0-cb89-f19b078ca3d5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee32e79b-5db3-f6e0-cb89-f19b078ca3d5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 20, 2020 at 12:56:08AM CET, dsahern@gmail.com wrote:
>On 3/14/20 3:25 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Introduce support for per-action hw stats type config.
>> 
>> This patch allows user to specify one of the following types of HW
>> stats for added action:
>> immediate - queried during dump time
>> delayed - polled from HW periodically or sent by HW in async manner
>> disabled - no stats needed
>> 
>> Note that if "hw_stats" option is not passed, user does not care about
>> the type, just expects any type of stats.
>> 
>> Examples:
>> $ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats disabled
>
>...
>
>> @@ -149,6 +150,59 @@ new_cmd(char **argv)
>>  		(matches(*argv, "add") == 0);
>>  }
>>  
>> +static const struct hw_stats_type_item {
>> +	const char *str;
>> +	__u8 type;
>> +} hw_stats_type_items[] = {
>> +	{ "immediate", TCA_ACT_HW_STATS_TYPE_IMMEDIATE },
>> +	{ "delayed", TCA_ACT_HW_STATS_TYPE_DELAYED },
>> +	{ "disabled", 0 }, /* no bit set */
>> +};
>> +
>> +static void print_hw_stats(const struct rtattr *arg)
>> +{
>> +	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
>> +	__u8 hw_stats_type;
>> +	int i;
>> +
>> +	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
>> +	print_string(PRINT_FP, NULL, "\t", NULL);
>> +	open_json_array(PRINT_ANY, "hw_stats");
>
>I still do not understand how the type can be multiple. The command line
>is an 'or' : immediate, delayed, or disabled. Further, the filter is

The cmd line is "or". The uapi is bitfield as requested by kernel
reviewers. I originally had that as "or" too.


>added to a specific device which has a single driver. Seems like at

Nope, may be multiple drivers if the block is shared.


>install / config time the user is explicitly stating a single type.


Basically using tc with this patch, you cannot achieve to have multiple
values in this output. However, in general. It could be.

Also, I wanted to have this as array because when I introduce the "used
hw stats" which would indicate which type is actually used (in case you
pass any for example), there might be multiple values, when offloaded to
multiple drivers.
