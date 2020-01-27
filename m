Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9E14A94B
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgA0R42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 12:56:28 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44891 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0R42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 12:56:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so4002721plo.11
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jy43hP9+Df2cXG91F8i+OvLmTs0Ee2ULfkNV6G23utQ=;
        b=OuGM7c8XWlVqJY3cAhA5F8sgxpVMGSFQQZmm7Ljjh6XGXq37cl0WtRcxGrDL6XGOS4
         JTenez/fGM+2mHc9MSaKQTd2wx82oTktPtFdrBTWE4obnhz4UfRrswNzNdjguwm2ffe5
         e8lJR91rC8tgMraXt05kWgNyTBomE4mr4MOuvMxuq3Yg/u/z08Rd+3iqzcGz+Sv/tfGV
         rhQ4ntHvjTGvHDSFOaBboOLT+SZeJxayZsOiPUiNcEn6eY77r5VxxJjRgWUrQty8UMhw
         yH1I1umy6JmkSj4fSVk7aEG8oh2PvDMJOpT2Adfbn4QQPl7b+I742AFdyMyS0V3Ywpvt
         Abfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jy43hP9+Df2cXG91F8i+OvLmTs0Ee2ULfkNV6G23utQ=;
        b=B4jhqomHBPEozNWtRhhbu78gsdi4eAe7XYlie3zi9m+vFz65lEFPpoGo8s/oZ3hGkK
         Xog6ZkWdtsxUgnlD2mYK4cVhCccNfGb24A9MURc8e9uUpskR8jTCo9hXpe3yjZTxb/xa
         +Alt6k0xOdgGdpfXDKmX2konlCnSPbq2/uTv1DjobZAvod5MytFzWNxr+jnO7chN+xPk
         Tk6Fxg8XWBVTBraw+U3HvBJmXkwrScjbTyJ9gKUgJ5yPzOt6CTufW2vfkp+b+tSuvgC8
         eQR/DEm+4xc4goM2AfGDN53DD/CxaauFFR3fiUIwGWAvjvdx+wd4MuQLIWdGCIscmVPL
         Ve1A==
X-Gm-Message-State: APjAAAXHkb/YeVbdorSb2dyAzB6bt+LwGD2Ew8709Y+TOKlWvJoS3WK/
        FhYg9vZSfn5KL0C2aDfcH19WbQ==
X-Google-Smtp-Source: APXvYqzfJ38a2gp3IshboAGe+2sjpLAxA1INBDVfhPryhOKiQE+gMlI090dFVpWrDmHGRsxXzNew5A==
X-Received: by 2002:a17:90b:1110:: with SMTP id gi16mr226469pjb.110.1580147787088;
        Mon, 27 Jan 2020 09:56:27 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 133sm16675317pfy.14.2020.01.27.09.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 09:56:26 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal> <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal> <20200126133353.77f5cb7e@cakuba>
 <20200127054955.GG3870@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <79bc446c-72a0-9209-98bc-e1d85a3a360a@pensando.io>
Date:   Mon, 27 Jan 2020 09:57:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127054955.GG3870@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 9:49 PM, Leon Romanovsky wrote:
> On Sun, Jan 26, 2020 at 01:33:53PM -0800, Jakub Kicinski wrote:
>> On Sun, 26 Jan 2020 23:08:50 +0200, Leon Romanovsky wrote:
>>> On Sun, Jan 26, 2020 at 12:49:57PM -0800, Jakub Kicinski wrote:
>>>> On Sun, 26 Jan 2020 21:41:10 +0200, Leon Romanovsky wrote:
>>>>>> This will end up affecting out-of-tree drivers as well, where it is useful
>>>>>> to know what the version number is, most especially since it is different
>>>>>> from what the kernel provided driver is.  How else are we to get this
>>>>>> information out to the user?  If this feature gets squashed, we'll end up
>>>>>> having to abuse some other mechanism so we can get the live information from
>>>>>> the driver, and probably each vendor will find a different way to sneak it
>>>>>> out, giving us more chaos than where we started.  At least the ethtool
>>>>>> version field is a known and consistent place for the version info.
>>>> Shannon does have a point that out of tree drivers still make use of
>>>> this field. Perhaps it would be a more suitable first step to print the
>>>> kernel version as default and add a comment saying upstream modules
>>>> shouldn't overwrite it (perhaps one day CI can catch new violators).
>>> Shannon proposed to remove this field and it was me who said no :)
>> Obviously, we can't remove fields from UAPI structs.
>>
>>> My plan is to overwrite ->version, delete all users and add
>>> WARN_ONEC(strcpy(..->version_)...) inside net/ethtool/ to catch
>>> abusers.
>> What I was thinking just now was: initialize ->version to utsname
>> before drivers are called, delete all upstream users, add a coccicheck
>> for upstream drivers which try to report the version.
>>
>>>> The NFP reports the git hash of the driver source plus the string
>>>> "(oot)" for out-of-tree:
>>>>
>>>> https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L297
>>>> https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L315
>>> I was inspired by upstream code.
>>> https://elixir.bootlin.com/linux/v5.5-rc7/source/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c#L184
>> Right, upstream nfp reports kernel version (both in modinfo and ethtool)
>> GitHub/compat/backport/out-of-tree reports kernel version in which the
>> code was expected to appear in modinfo:
>>
>> https://github.com/Netronome/nfp-drv-kmods/commit/7ec15c47caf5dbdf1f9806410535ad5b7373ec34#diff-492d7fa4004d885a38cfa889ed1adbe7L1284
>>
>> And git hash of the driver source plus out of tree marker in ethtool.
>>
>> That means it's out-of-tree driver which has to carry the extra code
>> and require extra feeding. As backport should IMHO.
>>
>>>>> Leaving to deal with driver version to vendors is not an option too,
>>>>> because they prove for more than once that they are not capable to
>>>>> define user visible interfaces. It comes due to their natural believe
>>>>> that their company is alone in the world and user visible interface
>>>>> should be suitable for them only.
>>>>>
>>>>> It is already impossible for users to distinguish properly versions
>>>>> of different vendors, because they use arbitrary strings with some
>>>>> numbers.
>>>> That is true. But reporting the kernel version without even as much as
>>>> in-tree/out-of-tree indication makes the field entirely meaningless.
>>> The long-standing policy in kernel that we don't really care about
>>> out-of-tree code.
>> Yeah... we all know it's not that simple :)
> It is simple, unfortunately netdev people like to complicate things
> by declaring ABI in very vague way which sometimes goes so far that
> it ends more strict than anyone would imagine.
>
> We, RDMA and many other subsystems mentioned in that ksummit thread,
> removed MODULE_VERSION() a long time ago and got zero complains from
> the real users.
>
>> The in-tree driver versions are meaningless and cause annoying churn
>> when people arbitrarily bump them. If we can get people to stop doing
>> that we'll be happy, that's all there is to it.
>>
>> Out of tree the field is useful, so we don't have to take it away just
>> as a matter of principle. If we can't convince people to stop bringing
>> the versions into the tree that'll be another story...
> As Shannon pointed, even experienced people will try to sneak those
> changes. I assume that it is mainly because they are pushed to do it
> by the people who doesn't understand Linux kernel process.
>
I don't think that the Intel Networking folks were trying to "sneak" 
something through, I think they have simply been continuing the process 
that they've been following for years.  When we have groups such as 
them, with a long history of contributions to drivers and stack, not 
following the new rules, perhaps we need to take a look at how we're 
publicizing these changes.

sln


