Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A12462887
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhK2XtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:49:07 -0500
Received: from mail-ua1-f47.google.com ([209.85.222.47]:43847 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhK2XtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:49:06 -0500
Received: by mail-ua1-f47.google.com with SMTP id j14so37558717uan.10
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tGIRepi63pTnbYruX2a9WA7d2ohRccV/Yg13dt7n3w=;
        b=fy5kmmTV21ycnCVhsfzGVzEC0wqZgdW0U6opaHVS724LjUyHPGpqTUhpMJgNAINbD/
         xElcDmQYCp/bJvcxDjYgYO0MNvNAdLUsOrPfTCpFnLF8adAUl278ljAnuvjTN9ed2oPW
         U6N21xqMLW2aQlNXmDSpye0XNm0XxI5s8UVkYiue8co1aVjNCouxhqJx+JNW5ICYuEWB
         QwAWFZfKOUHI0N4/V99pyB7m1T8FGk008ANenEsRWM6tA6Bw5qOqzcVb0N0ZTgZK4N7w
         Bp7qbQH6K5EU6MDMXed5KhKY4pA3/yJ97mfsTB5vBhJwkqxR2lCOpnudIN1ZriwjTzSV
         AwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tGIRepi63pTnbYruX2a9WA7d2ohRccV/Yg13dt7n3w=;
        b=N235jaP++wZ1l69wb/tcNIRiXvQwsl0pRfxWFjlmaUamlks6hW8CDuesGecoCdeS9D
         llYmHRrJfTM/48akG01LhGmI5QxEiMCw5hGFp3V2wUneaXGkZDoKnTT/sq7CuvsV5hoW
         SWL2Xuln1aMezbzXlDF7eWniuG5OxdmKme0Ctn+8G1q3uF5OSdhjAOHCQoT2ObY1KEFV
         CGFD9J8YCiqd0tMwlQTFMzrebj8DCqaeTzzjr/CEhRD0pU/SPmTNit8uZDqlq+b8u97b
         XeCJQRfp0V2p2reQcozhm0+FbsuWcK061byqG2MFtYi1RuIDEgjoEVurjhfk5f0f++kN
         Oqgg==
X-Gm-Message-State: AOAM532nqSBmgShx8EFzKJ4+sSM6d8/Hyd6xhMnezfrw+KwXLkzbWnFJ
        GAjE7lhkweW0TxUBFm4WyFJfjMlU9nzVk9suGBI=
X-Google-Smtp-Source: ABdhPJyaeCKFSGEK8CyNIMe0Gm/eTEmuCzlD8hwNC+046Eagh99mKCxH+WZ8csakUGTT37fwimPmhAJawXiKlhuYuqo=
X-Received: by 2002:a05:6102:c4e:: with SMTP id y14mr38329745vss.61.1638229487558;
 Mon, 29 Nov 2021 15:44:47 -0800 (PST)
MIME-Version: 1.0
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com> <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
 <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com> <YaR17NOQqvFxXEVs@unreal>
In-Reply-To: <YaR17NOQqvFxXEVs@unreal>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 30 Nov 2021 02:44:35 +0300
Message-ID: <CAHNKnsTYzkz+n6rxrFsDSBuYtaqX0vePPv3s3ghB4KfXbP5m+A@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs optional
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 9:40 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Nov 29, 2021 at 02:45:16AM +0300, Sergey Ryazanov wrote:
>> Add Leon to CC to merge both conversations.
>>
>> On Sun, Nov 28, 2021 at 8:01 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>>> On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
>>>>
>>>> +config WWAN_DEBUGFS
>>>> +     bool "WWAN subsystem common debugfs interface"
>>>> +     depends on DEBUG_FS
>>>> +     help
>>>> +       Enables common debugfs infrastructure for WWAN devices.
>>>> +
>>>> +       If unsure, say N.
>>>>
>>>
>>> I wonder if that really should even say "If unsure, say N." because
>>> really, once you have DEBUG_FS enabled, you can expect things to show up
>>> there?
>>>
>>> And I'd probably even argue that it should be
>>>
>>>         bool "..." if EXPERT
>>>         default y
>>>         depends on DEBUG_FS
>>>
>>> so most people aren't even bothered by the question?
>>>
>>>
>>>>  config WWAN_HWSIM
>>>>       tristate "Simulated WWAN device"
>>>>       help
>>>> @@ -83,6 +91,7 @@ config IOSM
>>>>  config IOSM_DEBUGFS
>>>>       bool "IOSM Debugfs support"
>>>>       depends on IOSM && DEBUG_FS
>>>> +     select WWAN_DEBUGFS
>>>>
>>> I guess it's kind of a philosophical question, but perhaps it would make
>>> more sense for that to be "depends on" (and then you can remove &&
>>> DEBUG_FS"), since that way it becomes trivial to disable all of WWAN
>>> debugfs and not have to worry about individual driver settings?
>>>
>>>
>>> And after that change, I'd probably just make this one "def_bool y"
>>> instead of asking the user.
>>
>> When I was preparing this series, my primary considered use case was
>> embedded firmwares. For example, in OpenWrt, you can not completely
>> disable debugfs, as a lot of wireless stuff can only be configured and
>> monitored with the debugfs knobs. At the same time, reducing the size
>> of a kernel and modules is an essential task in the world of embedded
>> software. Disabling the WWAN and IOSM debugfs interfaces allows us to
>> save 50K (x86-64 build) of space for module storage. Not much, but
>> already considerable when you only have 16MB of storage.
>>
>> I personally like Johannes' suggestion to enable these symbols by
>> default to avoid bothering PC users with such negligible things for
>> them. One thing that makes me doubtful is whether we should hide the
>> debugfs disabling option under the EXPERT. Or it would be an EXPERT
>> option misuse, since the debugfs knobs existence themself does not
>> affect regular WWAN device use.
>>
>> Leon, would it be Ok with you to add these options to the kernel
>> configuration and enable them by default?
>
> I didn't block your previous proposal either. Just pointed that your
> description doesn't correlate with the actual rationale for the patches.
>
> Instead of security claims, just use your OpenWrt case as a base for
> the commit message, which is very reasonable and valuable case.

Sure. Previous messages were too shallow and unclear. Thanks for
pointing me to this issue. I will improve them based on the feedback
received.

I still think we need separate options for the subsystem and for the
driver (see the rationale below). And I doubt, should I place the
detailed description of the OpenWrt case in each commit message, or it
would be sufficient to place it in a cover letter and add a shorter
version to each commit message. On the one hand, the cover letter
would not show up in the git log. On the other hand, it is not
genteelly to blow up each commit message with the duplicated story.

> However you should ask yourself if both IOSM_DEBUGFS and WWAN_DEBUGFS
> are needed. You wrote that wwan debugfs is empty without ioasm. Isn't
> better to allow user to select WWAN_DEBUGFS and change iosm code to
> rely on it instead of IOSM_DEBUGFS?

Yep, WWAN debugfs interface is useless without driver-specific knobs.
At the moment, only the IOSM driver implements the specific debugfs
interface. But a WWAN modem is a complex device with a lot of
features. For example, see a set of debug and test interfaces
implemented in the proposed driver for the Mediatek T7xx chipset [1].
Without general support from the kernel, all of these debug and test
features will most probably be implemented using the debugfs
interface.

Initially, I also had a plan to implement a single subsystem-wide
option to disable debugfs entirely. But then I considered how many
driver developers would want to create a driver-specific debugfs
interface, and changed my mind in favor of individual options. Just to
avoid an all-or-nothing case.

1. https://lore.kernel.org/all/20211101035635.26999-14-ricardo.martinez@linux.intel.com

-- 
Sergey
