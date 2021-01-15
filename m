Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892A2F8142
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAOQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbhAOQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:52:55 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0521C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:52:14 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g1so9602094edu.4
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ShUyJ+NfDqQt8YVaK53UzHmaZCjwQuw6T2uidk+cvrw=;
        b=bbmRVWJ9sm6HHN1rML9bkj5W+Mcfs/hLajQn1tStCWUXxTTHtfYEasFQqItS13HwOA
         HleNTNlIf2yq6sAz91XsCgfI2H6481bYjnYVZPeadvxPkGhJuRzbBBLFPnZaUunsYQqw
         LOW7V6i8d/IxQp/fW+KBibsArM85voiSSu1Uosod3YJGm/EApIqW9yw5FRxzVlWtDmt4
         KEBNDUvkqJqLPW9Toz0EqqaDdTHWvRGC/+kFbTlT1FQ567c18DIHTm9P+7QHXfXJCM4N
         Vqbhu5bWb+H9FB527dcuzl/U4EvLCHtuRHPLGzrymeTsm/g7T8E1gPKjymqyv9oZ85j3
         cYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ShUyJ+NfDqQt8YVaK53UzHmaZCjwQuw6T2uidk+cvrw=;
        b=GEVtH6kPcnZ2/RyYDt6pBGXvwBwcolMGdNPlIlnvz+N3BamcefHPvj6LLWXQp/pcaq
         w4J3NGl28tVNOxC0b2+P5wEP5v/yyMMKNyGyOZSmBR0hGJjnr6rIw4pn15ZCER9ScxJf
         1R5bHuU8iRJ+BpAxA5WsKRUW8bo5YsYkMkvSVwiZkZ0WZ9qlP4FMW78FQXZ3dBM1hTTr
         G0Bj/oSRKA2Dp7UjazP3jI+VF3MonjHHF2xz6XQA1g5cR4s1QbvI8lqhsR9Ub/8v1FhC
         EhWVMRDVGiexnFzQ+lx8HhnWoz9U6IKX1uxsFrhlVuFI/0PmU8+Mtej/UGaXOhcHX96u
         4Q2g==
X-Gm-Message-State: AOAM532IF5bZnm1p1HuWmetJl4vALEtxy1v25Lh5QNOozLeClE5Axmkg
        UnqSTsrmu30cCBE1K37/no5+WA==
X-Google-Smtp-Source: ABdhPJwVRtkGasnOGaOUtVnzzUHa/BQ3O1/YRA9ECa720Iv0cfB3VL+MTS90WPiFzlka5BMQC90mdw==
X-Received: by 2002:a50:bf4a:: with SMTP id g10mr10047667edk.201.1610729532823;
        Fri, 15 Jan 2021 08:52:12 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t12sm4254179edy.49.2021.01.15.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:52:12 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:52:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 03/10] devlink: implement line card active
 state
Message-ID: <20210115165211.GP3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-4-jiri@resnulli.us>
 <20210115160608.GD2064789@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115160608.GD2064789@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 05:06:08PM CET, idosch@idosch.org wrote:
>On Wed, Jan 13, 2021 at 01:12:15PM +0100, Jiri Pirko wrote:
>> +/**
>> + *	devlink_linecard_deactivate - Set linecard deactive
>
>Set linecard as inactive

Okay.

>
>> + *
>> + *	@devlink_linecard: devlink linecard
>> + */
>> +void devlink_linecard_deactivate(struct devlink_linecard *linecard)
>> +{
>> +	mutex_lock(&linecard->devlink->lock);
>> +	WARN_ON(linecard->state != DEVLINK_LINECARD_STATE_ACTIVE);
>> +	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
>> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +	mutex_unlock(&linecard->devlink->lock);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
>> +
>> +/**
>> + *	devlink_linecard_is_active - Check if active
>> + *
>> + *	@devlink_linecard: devlink linecard
>> + */
>> +bool devlink_linecard_is_active(struct devlink_linecard *linecard)
>> +{
>> +	bool active;
>> +
>> +	mutex_lock(&linecard->devlink->lock);
>> +	active = linecard->state == DEVLINK_LINECARD_STATE_ACTIVE;
>> +	mutex_unlock(&linecard->devlink->lock);
>> +	return active;
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_linecard_is_active);
>> +
>>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>>  			u32 size, u16 ingress_pools_count,
>>  			u16 egress_pools_count, u16 ingress_tc_count,
>> -- 
>> 2.26.2
>> 
