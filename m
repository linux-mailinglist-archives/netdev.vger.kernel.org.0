Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B69826F4C4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIRDiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRDiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:38:25 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108E7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:38:25 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o6so4151730ota.2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g7vg+ZlbVRSEqm3WJxuYOskw8Qpnl+FPE4pscI+vCdk=;
        b=FrwCB9m0agh98Engn5Ga9CHHNBR/3LRLcSUTJrzu4v+ZT5iY9hOUkUcF4ASItmiE3b
         SWWynC1gZHWYiP4HvFeDszVVSiyvArdY2rpVjMllJxE8wkh+gRZPjE3AAP6Wz0S8tqp8
         P0ZnQbXRaKG3GO50chn9NMlGfVwXpfcPlLD9gS7GEV9eRZvINQovPI9oG9Fd4MeRMKi4
         CYwwQkKtNdinLb/050v+EaXJBJU5cXdNpzraqrFfMCIBFcW5oyps6AHyPW99D0XHtbUo
         MBz9c0WpzvMTAai7bSZadrh9FdUoR0R0qLXHKTByBl9kR+cTjrfeaSSWg+TK06yYjnse
         tQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g7vg+ZlbVRSEqm3WJxuYOskw8Qpnl+FPE4pscI+vCdk=;
        b=pakYorMPqKccneTIvwMtzv+P7mGwulJ1rezhH7C75Ft9GnGH/ztwL86OTTI0oieI4J
         88FU8LYBdNGS5ihmTDq6MrtDDZ2XsFVN1Q5IbYoWMGYbbYJBCZBDQVzHUnKlV/xbYt6j
         Iur6Jb397Ha8qBgj2bCM7J2Iq/nFzJAMuQqnDNIn0bdT38IDSu0Cvb1NB/GAump7SltO
         Ps+q4TzE7cAJUFUHuXKccL1fMNk9q9hrIqUBZP/fF7/bQOnMRxrmh3znJ281uFEUy/PC
         9OAX0PB0PJTCGeX4uh8rlOdJbEeN2DXvNUhJVwFDXrwSTaS7qkftnCPITQKKL4XvUdp+
         9h6g==
X-Gm-Message-State: AOAM5331bbtPDqN8dYNDy1Nimg/QDwe0pNPR9bITVBcMb2/9qHMGG8u3
        EzrbGL52+Mj7r1qwQLq9qNzZ5HaHrr1iqQ==
X-Google-Smtp-Source: ABdhPJx+IO/o+E+w8eIkhkonwjzA6ot6VDiBj3HYKWreS+owi242fpzueXp9P8HH4hYF6Ner25b/ww==
X-Received: by 2002:a05:6830:1312:: with SMTP id p18mr22642162otq.316.1600400304525;
        Thu, 17 Sep 2020 20:38:24 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4476:8433:1e6d:dda0])
        by smtp.googlemail.com with ESMTPSA id g7sm1295187otl.59.2020.09.17.20.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 20:38:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
Date:   Thu, 17 Sep 2020 21:38:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 9:29 PM, Parav Pandit wrote:
>>> Examples:
>>>
>>> Create a PCI PF and PCI SF port.
>>> $ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0 $
>>> devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0 sfnum
>>> 44 $ devlink port show netdevsim/netdevsim10/11
>>> netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour pcisf
>> controller 0 pfnum 0 sfnum 44 external true splittable false
>>>   function:
>>>     hw_addr 00:00:00:00:00:00 state inactive
>>>
>>> $ devlink port function set netdevsim/netdevsim10/11 hw_addr
>>> 00:11:22:33:44:55 state active
>>>
>>> $ devlink port show netdevsim/netdevsim10/11 -jp {
>>>     "port": {
>>>         "netdevsim/netdevsim10/11": {
>>>             "type": "eth",
>>>             "netdev": "eni10npf0sf44",
>>
>> I could be missing something, but it does not seem like this patch creates the
>> netdevice for the subfunction.
>>
> The sf port created here is the eswitch port with a valid switch id similar to PF and physical port.
> So the netdev created is the representor netdevice.
> It is created uniformly for subfunction and pf port flavours.

To be clear: If I run the devlink commands to create a sub-function, `ip
link show` should list a net_device that corresponds to the sub-function?
