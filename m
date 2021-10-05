Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B96421EF0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhJEGnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhJEGm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 02:42:58 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E7C061749
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 23:41:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z2so15456389wmc.3
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 23:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RQd1eb7LuGWMGXLW0Toj0Xy2/OgdsTmnaijiP9bfs9U=;
        b=RPHqYA3e3EwHYTUB3ZxwTfsF8lSLbP97gBZAXp/Qh0rKVVJRSUJxMFhjfA6T1BeCBm
         LW4SosYc0ZipAwZLYXCfNfqjzrgBqNBY8TwUpUlEVb3Mu6jb4bCgYL4traaopI3szxsR
         LlKpRmFJN8ZXa9cfVqclrLQuDxA7t9EGWF7TohOFrkvIZl0f4w/8hqhL212bHnMSxhW8
         6kOgzrvrz4U696/iQD37Lb/vogdOVzXvt65pwGrc5P0FWoyjlWhPyBh5iIZ/+HkSIGWk
         2B0FxFD9vacmkuPphLWv8iH1echfyjf7R/KF73PVEIgcEqRf5fbocGsugZ8ay3bgjHv5
         Zc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RQd1eb7LuGWMGXLW0Toj0Xy2/OgdsTmnaijiP9bfs9U=;
        b=LlRtilap7uwctxjaqDiB/qTC6cDc7JXN8y/r+nzwWSJ11kv/y/wVE5Qp+58UCW4fEq
         bDjmY84efw/0uC4lhvO3KU8L2Vp+4PKsBwjOGDKnDIt1rNABKRqe8jk7CnlS6/XmhrRV
         HtPCtbbDAbbiAes6Z2JCwhXGSLenzb5Zjd6pJB9n/DPNEyiybDnYxIJQtoiuG4e4/xdi
         Qv2FwA8TymRphINr2a7IoKsYL+67WpixOqtQ9pWb/kQJwBb7e1+thWqmISFwtoABN50q
         r1PatlHYcD6LQfECs92gD8o1QrOzwppDsr1NaguIhwgliUNFBXhdSqJ7rPTILZAk/oMR
         aT/g==
X-Gm-Message-State: AOAM531hbaENxriXIOzHDkEN6iWojSZXG6CebU6lmQs/Ny6+mK3zLOKa
        0v48IMgMPqWhZfiIwsriLQewiDg2cFImPQ==
X-Google-Smtp-Source: ABdhPJwHYdrAmn7HqGpTOF+tOwfSklRJAwMdUfFhaC6YHYzyjRrTA6T939GnW35iI62OmGc1AXFUzA==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr1573727wmk.51.1633416064597;
        Mon, 04 Oct 2021 23:41:04 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:573:1b46:b04d:a14c? ([2a01:e0a:410:bb00:573:1b46:b04d:a14c])
        by smtp.gmail.com with ESMTPSA id c17sm772160wmr.15.2021.10.04.23.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 23:41:04 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Cpp Code <cpp.code.lv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
 <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com>
 <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAASuNyVe8z1R6xyCfSAxZbcrL3dej1n8TXXkqS-e8QvA6eWd+w@mail.gmail.com>
 <b091ef39-dc29-8362-4d31-0a9cc498e8ea@6wind.com>
 <CAASuNyW81zpSu+FGSDuUrOsyqJj7SokZtvX081BbeXi0ARBaYg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a4894aef-b82a-8224-611d-07be229f5ebe@6wind.com>
Date:   Tue, 5 Oct 2021 08:41:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAASuNyW81zpSu+FGSDuUrOsyqJj7SokZtvX081BbeXi0ARBaYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/10/2021 à 22:42, Cpp Code a écrit :
> On Fri, Oct 1, 2021 at 12:21 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 30/09/2021 à 18:11, Cpp Code a écrit :
>>> On Wed, Sep 29, 2021 at 6:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
>>>>>> /* Insert a kernel only KEY_ATTR */
>>>>>> #define OVS_KEY_ATTR_TUNNEL_INFO    __OVS_KEY_ATTR_MAX
>>>>>> #undef OVS_KEY_ATTR_MAX
>>>>>> #define OVS_KEY_ATTR_MAX            __OVS_KEY_ATTR_MAX
>>>>> Following the other thread [1], this will break if a new app runs over an old
>>>>> kernel.
>>>>
>>>> Good point.
>>>>
>>>>> Why not simply expose this attribute to userspace and throw an error if a
>>>>> userspace app uses it?
>>>>
>>>> Does it matter if it's exposed or not? Either way the parsing policy
>>>> for attrs coming from user space should have a reject for the value.
>>>> (I say that not having looked at the code, so maybe I shouldn't...)
>>>
>>> To remove some confusion, there are some architectural nuances if we
>>> want to extend code without large refactor.
>>> The ovs_key_attr is defined only in kernel side. Userspace side is
>>> generated from this file. As well the code can be built without kernel
>>> modules.
>>> The code inside OVS repository and net-next is not identical, but I
>>> try to keep some consistency.
>> I didn't get why OVS_KEY_ATTR_TUNNEL_INFO cannot be exposed to userspace.
> 
> OVS_KEY_ATTR_TUNNEL_INFO is compressed version of OVS_KEY_ATTR_TUNNEL
> and for clarity purposes its not exposed to userspace as it will never
> use it.
> I would say it's a coding style as it would not brake anything if exposed.
In fact, it's the best way to keep the compatibility in the long term.
You can define it like this:
OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info, reserved for kernel use */

> 
>>
>>>
>>> JFYI This is the file responsible for generating userspace part:
>>> https://github.com/openvswitch/ovs/blob/master/build-aux/extract-odp-netlink-h
>>> This is the how corresponding file for ovs_key_attr looks inside OVS:
>>> https://github.com/openvswitch/ovs/blob/master/datapath/linux/compat/include/linux/openvswitch.h
>>> one can see there are more values than in net-next version.
>> There are still some '#ifdef __KERNEL__'. The standard 'make headers_install'
>> filters them. Why not using this standard mechanism?
> 
> Could you elaborate on this, I don't quite understand the idea!? Which
> ifdef you are referring, the one along OVS_KEY_ATTR_TUNNEL_INFO or
> some other?
My understanding is that this file is used for the userland third party, thus,
theoretically, there should be no '#ifdef __KERNEL__'. uapi headers generated
with 'make headers_install' are filtered to remove them.

> 
>>
>> In this file, there are two attributes (OVS_KEY_ATTR_PACKET_TYPE and
>> OVS_KEY_ATTR_ND_EXTENSIONS) that doesn't exist in the kernel.
>> This will also breaks if an old app runs over a new kernel. I don't see how it
>> is possible to keep the compat between {old|new} {kernel|app}.
> 
> Looks like this most likely is a bug while working on multiple
> versions of code.  Need to do add more padding.
As said above, just define the same uapi for everybody and the problem is gone
forever.


Regards,
Nicolas
