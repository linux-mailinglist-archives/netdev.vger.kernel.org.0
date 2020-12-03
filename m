Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E2B2CE1F9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgLCWkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgLCWkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 17:40:32 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAA3C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 14:39:51 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id y24so3409754otk.3
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 14:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=knpDMyVvEkQOdA8TyLSQ54FW/ldAJSVYVieSsfZLH/Y=;
        b=OVLwqw9fvAdmWegn0nkMu+ovimEwIzzPCAeqB5oXqfz/UvbnKvGb4hGHPKNwiZRg3w
         QwtpsKgoJAvwiFg6v1W9Tqko0rD4xDYfV7dqb+E1brF3NpqKWuuPYKEWeA2la1ucaV7x
         7UFgOvrc0GlzxNMGK2Dzspinuf+ETtcc16dHWTKARDA6F3v9whxbWaOam05+ddcPkHK9
         VtfaTQXH7bg1oURZXsUthPNwTv8B33t53Cpk6SVwOrYEpD0J1wGK1oI/ClJDLyM+TXT1
         6pGIkPH06mHDaCJgXpS11kzn+HK4WDM5M26bWF6H3XKt4o1c97p5QXl2BK+j9dBVY/Pe
         C2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knpDMyVvEkQOdA8TyLSQ54FW/ldAJSVYVieSsfZLH/Y=;
        b=B26zHIbXC5BknKGlYfqpbaku+C1zam/2E22BnkymjrfnE8vw+a5dbpC7jHuiOSz6u2
         TG+jMFouvAwYcNb+TTGDIxwAq+qZMbCu6e5j2V3LCxpNdtTsUc3cWoOjegv6Aq4AIUYW
         AcVTbgOB6Oagt2aTji5r7j9YECWoFtUUObURONf/9JMswCe2cqxZkfUUeT/2cicPEWzo
         9oPl1TK4RY2FUZCSwLvMomaOFRhcQ+diT9cBhTXcq+EyocXQqQW7cCuq/7DOKPUFOQlQ
         wN2lOmQnstQ0g58fa1lB4wz8CqO58EqwER8Wy9dY6/DNiHfkQ/iyXB0/q+1Iot27ulv/
         lTnA==
X-Gm-Message-State: AOAM5309OmILNEWmnBqXvhK4soNiUkJbrzCR7TworSjpyB9LsqxN6G2U
        Q3/K0wy7laVFvOjWz0QBxT7f0Lz+IHI=
X-Google-Smtp-Source: ABdhPJw9/uD2LBfK5V99HhXz8+Kqo4JOQxnAg+8+ObuplOQ/gi0lKa2CKnmQmFn4AvENXz/6jAmSXA==
X-Received: by 2002:a9d:7081:: with SMTP id l1mr1275049otj.139.1607035191290;
        Thu, 03 Dec 2020 14:39:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id y18sm224848oou.15.2020.12.03.14.39.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 14:39:50 -0800 (PST)
Subject: Re: [PATCH iproute2-next] Only compile mnl_utils when HAVE_LIBMNL is
 defined
To:     Petr Machata <me@pmachata.org>, David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20201203041101.11116-1-dsahern@kernel.org>
 <87o8jamum5.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6c07397-9799-e9f4-23c7-e1954ee701b5@gmail.com>
Date:   Thu, 3 Dec 2020 15:39:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <87o8jamum5.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 2:45 PM, Petr Machata wrote:
> 
> David Ahern <dsahern@kernel.org> writes:
> 
>> diff --git a/lib/Makefile b/lib/Makefile
>> index e37585c6..603ea83e 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -13,7 +13,10 @@ UTILOBJ += bpf_libbpf.o
>>  endif
>>  endif
>>  
>> -NLOBJ=libgenl.o libnetlink.o mnl_utils.o
>> +NLOBJ=libgenl.o libnetlink.o
>> +ifeq ($(HAVE_LIBMNL),y)
> 
> This should test HAVE_MNL, not HAVE_LIBMNL.
> 

d'oh. thanks for catching that.
