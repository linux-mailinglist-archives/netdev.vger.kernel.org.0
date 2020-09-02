Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7273A25AA7E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgIBLqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIBLqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:46:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89894C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:46:03 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id u126so5370238iod.12
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tdgfvkvLF4aQSlaEeEhss00MGGBuZUbnVX7zjmufUoo=;
        b=yz2+RzsRKaMvraM+LPCDjXrGCz6ipsYgdND6M0DiTzyd89uQs2oBY16nkYXq1jrrMx
         4s6iTnazg9upQW00ntl6rACJNh54odUylhz67S5BeXCgxolLh4GTk4S64rYsg8SBhHbh
         ejomlBCILTYDTR9z5lzBTllaVA2zbTbOdEu77AWktp269udgCiQbumOv9CTsX+UTDF+o
         JBozT8cYUV4NvOQ9siBi5iG2zmRNCUrreVadgasuoWPbyu/hbvJKMHW+tire73yWbAWF
         hryjKz4yoU1IbK9OILTf4ff2vxJMUhctq4mkNk4IFtZMCw1Br9eCLwKvSP/XZ+Q/NiRo
         qKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tdgfvkvLF4aQSlaEeEhss00MGGBuZUbnVX7zjmufUoo=;
        b=R8a/JEeUGwFkZyVGT5Y82tk7XBtb9ESFtQFOHuLBMY7o6RC/tQL+QG0azI6FHOqt9P
         /AvRvfuVQynFW58uLlD/4k9sEsUIYyOoV2DlZ7oEl1zZvThFvkEaOFzQW2MAHVPiyh25
         MQCQ0aYJNduA5G4Ip6OmcQ02fDNt83S3KA1K5l0TZHGg+LnjxMiFX6vb08A+9Lf0W7Kv
         0y5FStkFyq0oHhb0RTwpHrw4ioH4bGdQRtuyTZCeyHlmjwuZtXMvNOL8dXl/x75mk8iv
         ej2evPKz+64HoCODtZx/KsFVWhmHGStwgdpeCTad6RsHj9Hhc3EckB9nr68VLplg3ys0
         80NA==
X-Gm-Message-State: AOAM532uVtXrXKBwnRPY2szvPwtfnF1QTdAWZvZZDboM+Cz7YvLg8TDX
        wFS9iVnMYld4teqpAqYu1aMfq7L+E+iZTg==
X-Google-Smtp-Source: ABdhPJxUUi6TWEzhGRHxxWHhHdE93zjHpJ+zIr0veBoucNeU6QvV6AGSmhvuhVbo/5zlVXqUBc0hEA==
X-Received: by 2002:a02:6341:: with SMTP id j62mr2841699jac.69.1599047162372;
        Wed, 02 Sep 2020 04:46:02 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z1sm2161538ilk.5.2020.09.02.04.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 04:46:01 -0700 (PDT)
Subject: Re: COMPILE_TEST
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Networking <netdev@vger.kernel.org>
References: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
 <20200901214852.GA3050651@lunn.ch>
 <20200901171738.23af6c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <18f4418f-0ca0-bd5d-10fc-998b4689f9e5@infradead.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <1743f479-68c8-5f27-8d35-e17d5c96b60a@linaro.org>
Date:   Wed, 2 Sep 2020 06:46:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <18f4418f-0ca0-bd5d-10fc-998b4689f9e5@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 7:52 PM, Randy Dunlap wrote:
> On 9/1/20 5:17 PM, Jakub Kicinski wrote:
>> On Tue, 1 Sep 2020 23:48:52 +0200 Andrew Lunn wrote:
>>> On Tue, Sep 01, 2020 at 03:22:31PM -0500, Alex Elder wrote:
>>>> Jakub, you suggested/requested that the Qualcomm IPA driver get
>>>> built when the COMPILE_TEST config option is enabled.  I started
>>>> working on this a few months ago but didn't finish, and picked
>>>> it up again today.  I'd really like to get this done soon.
>>>>
>>>> The QCOM_IPA config option depends on and selects other things,
>>>> and those other things depend on and select still more config
>>>> options.  I've worked through some of these, but now question
>>>> whether this is even the right approach.  Should I try to ensure
>>>> all the code the IPA driver depends on and selects *also* gets
>>>> built when COMPILE_TEST is enabled?  Or should I try to minimize
>>>> the impact on other code by making IPA config dependencies and
>>>> selections also depend on the value of COMPILE_TEST?
>>>>
>>>> Is there anything you know of that describes best practice for
>>>> enabling a config option when COMPILE_TEST is enabled?  
>>>
>>> Hi Alex
>>>
>>> In general everything which can be build with COMPILE_TEST should be
>>> built with COMPILE_TEST. So generally it just works, because
>>> everything selected should already be selected because they already
>>> have COMPILE_TEST.

This makes sense.  And it sounds to me that you are saying I should
ensure every dependency and selected option is also built (or maybe
tolerates) having COMPILE_TEST enabled.  It's basically the approach
I was following, but the chain of dependencies means it affects a
lot more code than I wanted, including the ARM SCM (e.g. Trust
Zone) entry points.  I agree things should "just work" but before
I went too much further I wanted to see if there was a better way.

>>> Correctly written drivers should compile for just about any
>>> architecture. If they don't it suggests they are not using the APIs
>>> correctly, and should be fixed.
>>>
>>> If the dependencies have not had COMPILE_TEST before, you are probably
>>> in for some work, but in the end all the drivers will be of better
>>> quality, and get build tested a lot more.

Yes I understand this, and agree with it.

>> Nothing to add :) I'm not aware of any codified best practices.
>>
> 
> I have a little to add, but maybe some can complete this more
> than I can.
> 
> Several subsystem header files add stubs for when that subsystem is not
> enabled.  I know <linux/of.h> works with CONFIG_OF=y or =n, with lots of stubs.
> 
> Same is true for <linux/gpio.h> and CONFIG_GPIOLIB.

Yes I saw this in some places.  In other places I saw things
addressed by (for example) something like:
  config FOO
    ...
    select BAR if !COMPILE_TEST

I didn't chase down whether that meant code enabled by FOO
created its own stubs, or if something else was going on.

> It would be good to know which other CONFIG symbols and header files
> are known to work (or expected to work) like this.
> 
> Having these stubs allows us to always either omit e.g.
> 	depends on GPIOLIB

The above could only be done if the dependency is simply for
linkage and not functionality.  Maybe that makes sense in
some cases but it seems like a mistake.

> or make it say
> 	depends on GPIOLIB || COMPILE_TEST
> 
> 
> Also, there are $ARCH conditions whose drivers also usually
> could benefit from COMPILE_TEST, so we often see for a driver:
> 
> 	depends on MIPS || COMPILE_TEST
> or
> 	depends on ARCH_some_arm_derivative || COMPILE_TEST
> or
> 	depends on *PLATFORM* || COMPILE_TEST
> or
> 	depends on ARCH_TEGRA || COMPILE_TEST
> 
> So if a driver is destined (or designed) for one h/w environment,
> we very much want to build it with COMPILE_TEST for other h/w platforms.

Yes, that's really my purpose here.  Thanks a lot for your
comments.  I'll continue with what I've been doing and will
incorporate this input where possible.

					-Alex

> HTH.
> 

