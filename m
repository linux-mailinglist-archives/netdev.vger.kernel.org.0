Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE01270AC0
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 06:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgISEtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 00:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISEtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 00:49:18 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF913C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 21:49:18 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id u25so7396693otq.6
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 21:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AsN9li4XUEyV4uBg408WUTZWVzmW2SdHCWJAYz5ibzQ=;
        b=GTlRygKAi51iyeitnbgLRYFvEwlZhN2iph3eHdRzAVXznkvso2Q/uLybjzQmVlhBH/
         bZ8A2s7Lqt6b/I9auI72trFOVmzyzOmxB13qewo4QLaeBuO7ssygtXNz3lHsfbwWAQ73
         ukzsmLCjWn4ajwX7T9AUpksKJKPUcpOVOsx1oEH1Ie0bIHCZXOOYHsJC++/aSJbaaiBr
         P8q+KUUf15pqG2z+jIxNAZJ0M27FsgVoR4O9fwqiXLvTlRzT986Az18XsPJ9d1tjVbFK
         yn8L1PmkM6O30ohZ8Ycyrc9cA6e7XAWPqDJtY7Mi/1O2n9Ctpl835kHfjf+IXkKlk7mL
         fCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AsN9li4XUEyV4uBg408WUTZWVzmW2SdHCWJAYz5ibzQ=;
        b=KCBNMUfPxcboRUu4xFRK5Oh2+dDfj6FLDJ/9RHLinFxiJMGMBPKdye8p4SQKy2fmy2
         BU4JetJmCoiBOgMR6wX+loMRqiR8Uypy6SXpYYkT3mYeDLsuOWTYK2WNGFttsaloCmgv
         K3ysYnKs48K3vfwrvPAfQzTbHcG5j/LKrv6M4UhKVJ0hRUCK0pY+hqhsD7DM2+OUpJOq
         dfZc1gKgBEslux9VUO0eF7W6JAJTwvXL5cVWsT+9JAy1pvo7UythD4vOSUd4C69leuwH
         /ipPfxaxaJqcFJVyrDZh5nesIq+5F2a+knznagOYXTjNCexvKBvydHTn6CdLSr9SgqQP
         Kj8w==
X-Gm-Message-State: AOAM532VrNAyp4JyaiKp5hqPsTJvEVgY6y+QEXkVervVS7bsUjYQzGq7
        aLhGjNIguBTNjHCob8g6lJw=
X-Google-Smtp-Source: ABdhPJxFe8ifCINoJTKOuN19bM9OQBc7VmtlTmTurJZ9+JEeClcB9YE/FGDmao7S5RotOx1r2SdF/Q==
X-Received: by 2002:a05:6830:168f:: with SMTP id k15mr7775348otr.64.1600490958091;
        Fri, 18 Sep 2020 21:49:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:fc15:41f5:881c:229a])
        by smtp.googlemail.com with ESMTPSA id u2sm4929108oot.39.2020.09.18.21.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 21:49:17 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
 <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <f89dca1d-4517-bf4a-b3f0-4c3a076dd2ab@gmail.com>
 <BY5PR12MB432298572152955D2ACAA2A3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a55536d-3b79-c009-98e9-95f76c9aa88c@gmail.com>
Date:   Fri, 18 Sep 2020 22:49:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB432298572152955D2ACAA2A3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 10:13 AM, Parav Pandit wrote:
>> You keep adding patches that extend the template based names. Those are
>> going to cause odd EINVAL failures (the absolute worst kind of configuration
>> failure) with no way for a user to understand why the command is failing, and
>> you need to handle that. Returning an extack message back to the user is
>> preferred.
> Sure, make sense.
> I will run one short series after this one, to return extack in below code flow and other where extack return is possible.
> In sysfs flow it is irrelevant anyway.

yes, sysfs is a different problem.

> rtnl_getlink()
>   rtnl_phys_port_name_fill()
>      dev_get_phys_port_name()
>        ndo_phys_port_name()
> 
> is that ok?

sure. The overflow is not going to happen today with 1-10 SFs; but you
are pushing ever close to the limit hence the push.


> This series is not really making phys_port_name any worse except that sfnum field width is bit larger than vfnum.
> 
> Now coming back to phys_port_name not fitting in 15 characters which can trigger -EINVAL error is very slim in most sane cases.
> Let's take an example.
> A controller in valid range of 0 to 16,
> PF in range of 0 to 7,
> VF in range of 0 to 255,
> SF in range of 0 to 65536,
> 
> Will generate VF phys_port_name=c16pf7vf255 (11 chars + 1 null)
> SF phys_port name = c16pf7sf65535 (13 chars + 1 null)
> So yes, eth dev name won't fit in but phys_port_name failure is almost nil.
> 

You lost me on that last sentence. Per your example for SF, adding 'eni'
or 'eth' as a prefix (which you commonly use in examples and which are
common prefixes) to that name and you overflow the IFNAMESZ limit.


(understand about the systemd integration and appreciate the forward
thinking about that).
