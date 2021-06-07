Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3B39DEF6
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhFGOnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGOnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:43:16 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC53C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 07:41:18 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id d21so18248387oic.11
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 07:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DSnfLz3U0TVzQx9+l9kiDcAFeuAuf4SBuw6nQ1Ks7Oc=;
        b=fkEfAbNZSGz/Yv3oJgISuFL8293zBM8FmhqsnerxeSgs168O7wb7aPgzzaR9hseqmg
         b2yzkzr7LW4+4lMz9JWlGAUWpUW+Z4EODuY+Oj5hk6Cvq81JKoatYgLqidyojwg3HRFI
         5HYXTqmplHqIiX03Y/rW8JcuEwDdwEu8U04ZrGROAYOEoln3cFLv05wgQ3jlzVGpcE9A
         wHas5ADct99wNNs2E6LwxbhcjayZi/SfAfKJmLhCTj53SE0WCD5AHbMJEQNeT+73HdEg
         fH0eqlY2BjlGzUfhjkFgZLKSNPVOtYFL7E3j81F35/+pS9GQ3DEulesxoVFoU2slMRZG
         PQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DSnfLz3U0TVzQx9+l9kiDcAFeuAuf4SBuw6nQ1Ks7Oc=;
        b=aVchlCPxrB9FE0jLWuSY6PzR6nCCORJABy3CVum9kIgtZbtDN2S8qnyWjH9JTjBLlx
         8Z+OK/XfQrgiM8dUmbNacZBQU4Sr07os60h7zIJzm6FLejCYJviAFEnViGyU1YINaKJ2
         Xl3jFmngP+ay+W+kIxNVK+d55BdMtWOefS3hkwPX9d9DIjVKYPmriU0KzZMPR7p59NRJ
         JMgUQDSOTgzGoCDB5CiT57bdLcBb799M5sdqsRI4/sQU1cOuPAVPV1z3ZkyCW5zZiCzS
         Ut7bpnN0ONvo1e0TzKDHlSESxLSXzMy+7FlvPaQBDqKV7fPp30wsEiyXusFsA74gFUed
         Bdeg==
X-Gm-Message-State: AOAM532GK9cC7/FuhwDeVnijNEjTPD10EXoe9ZCpAn/nO+u8GloYJHKF
        tkG2P9K4nHPMyc2jpnXEY/Q=
X-Google-Smtp-Source: ABdhPJyWj6kuPOzvGOpMQp30/CmaLi3ni9029zy/HPmcdzz97HSqU58so2QQC8g82OWYAq6U7fmzdA==
X-Received: by 2002:a54:448a:: with SMTP id v10mr11859596oiv.133.1623076877502;
        Mon, 07 Jun 2021 07:41:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id c11sm921253oot.25.2021.06.07.07.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 07:41:17 -0700 (PDT)
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
 <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
Date:   Mon, 7 Jun 2021 08:41:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 5:43 AM, Parav Pandit wrote:
> Hi David,
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Monday, June 7, 2021 8:31 AM
>>
>> On 6/3/21 5:19 AM, Parav Pandit wrote:
>>> @@ -3795,7 +3806,7 @@ static void cmd_port_help(void)
>>>  	pr_err("       devlink port param set DEV/PORT_INDEX name
>> PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>>>  	pr_err("       devlink port param show [DEV/PORT_INDEX name
>> PARAMETER]\n");
>>>  	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter
>> REPORTER_NAME ]\n");
>>> -	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR
>> pfnum PFNUM [ sfnum SFNUM ]\n");
>>> +	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR
>> pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>>>  	pr_err("       devlink port del DEV/PORT_INDEX\n");
>>>  }
>>>
>>> @@ -4324,7 +4335,7 @@ static int __cmd_health_show(struct dl *dl, bool
>>> show_device, bool show_port);
>>>
>>>  static void cmd_port_add_help(void)
>>>  {
>>> -	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour
>> FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
>>> +	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour
>> FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>>
>> This line and the one above need to be wrapped. This addition puts it well
>> into the 90s.
>>
> It’s a print message.
> I was following coding style of [1] that says "However, never break user-visible strings such as printk messages because that breaks the ability to grep for them.".
> Recent code of dcb_ets.c has similar long string in print. So I didn't wrap it.

I missed that when reviewing the dcb command then.

> Should we warp it?
> 
> [1] https://www.kernel.org/doc/html/latest/process/coding-style.html#breaking-long-lines-and-strings
> 

[1] is referring to messages from kernel code, and I agree with that
style. This is help message from iproute2. I tend to keep my terminal
widths between 80 and 90 columns, so the long help lines from commands
are not very friendly causing me to resize the terminal.
