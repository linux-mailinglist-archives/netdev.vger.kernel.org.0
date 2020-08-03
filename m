Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910F723B146
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgHCXy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgHCXy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:54:29 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FB7C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:54:29 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id d14so36862820qke.13
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y+C637p46dMrpoubBLpEHDY9asdPwWe9YmjxERDIFis=;
        b=QBN9M9XAEqyY80FDAhUzVL31+nj/Y3oqhHZdcVBbmUzccOTVKFjpvtrVgDdUqLtlZy
         I4HnmFTVLwLpK5pvUzIx9gsqKU1TJr2JcWt6XDRbgywtFHywNXoset/KWsnI4ZKnUQW5
         7H12wU8ZgmyS7P6geKEfcJhvNUSfAfBviMd0AYusMmsfGita9TKzbrW9KnStwALTEgCd
         UAzQJI1Yh++TciKbYSw56JjOAtX2/fe8j51/Tc5Nfq4KqSlcLgLUQTkuhIf9TFF/WU3j
         hn5fNyvZIFe00H4L6o95DShrrONODMTjQ1ibctr+WvLjx6TO1GMX0MrPDSfGhp2Ubhaj
         LqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y+C637p46dMrpoubBLpEHDY9asdPwWe9YmjxERDIFis=;
        b=LQsq65wJQqRPNC1zRjXZsVEpSGhycDZcx309zPF5nn7303Lai7E0mKfgb1yhatA13R
         FsXakNRcm4R1tCY9EDWfCBdCbX+Eumaf84zcpSj2SuDMJb7ahNW4SwZiJNEwiSOeDd4z
         gpetryT+GBFc7G4leGCCikB5wyaCWyVTUaMZc7Xf10OPZhnTKVK8RdttkeIGKBDJaBCs
         Sd/GggFPsJikFZlihY5HOV9Ib37WO2TovcACF3EwiZYdEw2DUkRkMaSCRYnmoPe+6Rtf
         Nq0ilWvLuYDaiCNxzXuyd5UrIQpsvWyMp18drluHlOLcRFuVA8r7QOkFy4fhqaLHXzWS
         EnFg==
X-Gm-Message-State: AOAM533f7VALU1ZjeEdUU2RmFejvSV7xmu4onHcR3T+GZtdQeEEjuieK
        MdD2m7qormmQ9wapcAXZrb0=
X-Google-Smtp-Source: ABdhPJzfehZ2wCt0xyer9mVboYAwR8tNF3bIBTmIIiQAmPKJhH8dblSLxD5aOc4RAw0Z0N3sSjgSLw==
X-Received: by 2002:a05:620a:150f:: with SMTP id i15mr18787655qkk.152.1596498868578;
        Mon, 03 Aug 2020 16:54:28 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id g184sm18344841qkd.51.2020.08.03.16.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:54:28 -0700 (PDT)
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
 <a7a03137-b3f8-de21-2a05-95f019d63309@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b22c5b28-71f4-d9c1-f619-783f601dd653@gmail.com>
Date:   Mon, 3 Aug 2020 17:54:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <a7a03137-b3f8-de21-2a05-95f019d63309@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 5:30 PM, Jacob Keller wrote:
> 
> Slightly unrelated: but the recent change to using a bitfield32 results
> in a "GENMASK is undefined".. I'm not sure what the proper way to fix
> this is, since we'd like to still use GENMASK to define the supported
> bitfields. I guess we need to pull in more headers? Or define something
> in include/utils.h?
> 

I see that include/linux/bits.h has been pulled into the tools directory
for perf and power tools (ie., works fine in userspace).

iproute2 is GPL so should be good from a licensing perspective to copy
into iproute2. Stephen: any objections?
