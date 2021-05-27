Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5688D392B85
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhE0KOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhE0KOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:14:18 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05D7C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:12:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f6-20020a1c1f060000b0290175ca89f698so2232282wmf.5
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IcRcMzC0Z0Mv+9TuXapugfGv6UnvJdn7GFcyk9ZJVuc=;
        b=PI1j4LaoqJLnq9mjgu6DNOFmuuAbCL0zMCBotDp8+s+8ksS7uUulMET+gBshQHRW12
         8balFGCrg4K2GVpqnsT23j6OxZATacXk+jfhd4tWtQ18UgIXsf7mpUpLs/vbMcTgBy+q
         ki2szND1QGQOm06Xc5RF08iezrb4Xs525GoQgzbm+BqTJWya6AN2ceF/XTk3gx6/rLrQ
         kh4DB0riF73KRWUSmLa8Re6tFJLHcqIBYWTSySgWKPPZpRTOcUj1SGNvUdjpo5nW6S/z
         5/qq2BYD8iyBYmIQ0+FrAQWxP+zf0YWcUo+xnFhT1OY0xiRCWwEgp7c4q6GFtErXbLn4
         cp2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IcRcMzC0Z0Mv+9TuXapugfGv6UnvJdn7GFcyk9ZJVuc=;
        b=IlwA98zqHBftbxPoZUwS5EOOpEtwBE5ANHDeJK0dtsWe5lZfP1OzKgIDw/ZWIpWO08
         CWANsDq4QiTKvoBCrWPTUooYktjvQCwQLgiOlR1SyTTDu/IvJ8rCz98+IlFCJeFj3TG0
         8jCy9NhQjWBOgl5ko5gzNlz+IgBJGgIGocda7MlHwG4OAIfCA5eA5qAw6J4MkYhi5KT1
         KgDaI+Cy7pxfyqQq90aVp99BjopwJOLLFhuacLXWZki1IfDPniT8JrQoBxgfM2Ai1ChM
         hyGQunr1l+59iu03aDnXcAY7K4Tow9I5EUiI7SPCWM92IzILhwosR5XslhWn5W5w4dnv
         nsRQ==
X-Gm-Message-State: AOAM5327db5WGzLKZa0nTlDt6WmcfIsz/y5OQ7KYHhNzG/13lGn+KNZ+
        Ipei/oBEMy8zfAO7a294x16jdQ==
X-Google-Smtp-Source: ABdhPJzfg1hdO9zVVAiCTKiKa/xo+T8FkHfmLYWsl3PCfS39wKlRTKwH4j0ZR6NVn7XJyEjOSkKPRQ==
X-Received: by 2002:a1c:32c6:: with SMTP id y189mr1294591wmy.54.1622110363409;
        Thu, 27 May 2021 03:12:43 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id i1sm2454282wrp.51.2021.05.27.03.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 03:12:42 -0700 (PDT)
Date:   Thu, 27 May 2021 12:12:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com
Subject: Re: [patch net-next] devlink: append split port number to the port
 name
Message-ID: <YK9wmLUT22Gbc87V@nanopsycho>
References: <20210526103508.760849-1-jiri@resnulli.us>
 <20210526170556.31336a06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526170556.31336a06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 27, 2021 at 02:05:56AM CEST, kuba@kernel.org wrote:
>On Wed, 26 May 2021 12:35:08 +0200 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Instead of doing sprintf twice in case the port is split or not, append
>> the split port suffix in case the port is split.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 06b2b1941dce..c7754c293010 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -8632,12 +8632,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>  	switch (attrs->flavour) {
>>  	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
>>  	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
>> -		if (!attrs->split)
>> -			n = snprintf(name, len, "p%u", attrs->phys.port_number);
>> -		else
>> -			n = snprintf(name, len, "p%us%u",
>> -				     attrs->phys.port_number,
>> -				     attrs->phys.split_subport_number);
>> +		n = snprintf(name, len, "p%u", attrs->phys.port_number);
>
>snprintf() can return n > len, you need to check for this before
>passing len - n as an unsigned argument below.

Correct, will send v2. Thanks!

>
>> +		if (attrs->split)
>> +			n += snprintf(name + n, len - n, "s%u",
>> +				      attrs->phys.split_subport_number);
>>  		break;
>>  	case DEVLINK_PORT_FLAVOUR_CPU:
>>  	case DEVLINK_PORT_FLAVOUR_DSA:
>
