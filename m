Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB4D92AB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391966AbfJPNhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:37:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46082 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfJPNhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 09:37:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so28060774wrv.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 06:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=CMdNj2+acb0B7tDCqXrl91GW8f8XDBPBKRIxHWWs42c=;
        b=LuQBx/8tJ64k2Fp4YEOOrFwjVU627ODDbybjUhS2ifRD0J9i+tD7rY7Win7VAqzbsg
         saC06fZc5v0/q2MizPah9BJ5KOM2ncpNw3gtWNTuqIcAa3KMlPmywDBx0jKw9SztWdBx
         kxKctzZdDalr7X9Kl9XtTTYu6RniliFk4YJcZlygcylMg+WNakhRSQsj38nUyGvYIggr
         3rDCPZh2JAsyF2G7ufRa5ZlG7k46Td/fUWRp46ey9aoiNv+UT3gxK1Rj77PvFvPMEajn
         wvAMjUW6D0mvWBCcCCkkMLD5UJbi5l7rIEa63QizI0X6jmgyxlDEUHNgVu6E38YBBHVD
         x+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=CMdNj2+acb0B7tDCqXrl91GW8f8XDBPBKRIxHWWs42c=;
        b=VpN0Ds+XzpTOjRIaqXXt5Z+KHegdQ4MOVElfX+q3dIqCBf4/S+XZLZb6/xFZT4lWPt
         z0+FCiz3Qy5YIh92iBcnHwAyeyS/9GxZxuKZn0gnWCcZc+h1dUCUDsrXH6Q+vUOitFby
         gyAoubDC/ergd1kOPxGahdSRbvqdIiO28LFcx0uS9vmh7l2we3i1vb15Uh16siG5KsVI
         4Ugkd7CidTLUUGCm92HLXJYhkbk/GPRrUU/bDckqbPPJJDUvybufmQfkN2inIDEoD+Ld
         p5R2UFzcrorJNgDQm1ElQZ1s72+WWScmCVKe99veTKukK5MyHpjBycDX7vlpvUdYPUJX
         qJwA==
X-Gm-Message-State: APjAAAXu8n46yykoFhNpMkf65wLwBIg33A2dSv0rGRa7mBdZZYjkQbWk
        FMGkqdBZKXrf2LR/AnGaFHtxLA==
X-Google-Smtp-Source: APXvYqyRAfZ2navxpVMc69fM9dW1dVKGTOneB+CBuphbL/MPphkzJlEhwqcSStzQWgG7AJ9AyOFleg==
X-Received: by 2002:a5d:49c9:: with SMTP id t9mr1670541wrs.146.1571233031987;
        Wed, 16 Oct 2019 06:37:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id 207sm3212108wme.17.2019.10.16.06.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 06:37:11 -0700 (PDT)
Date:   Wed, 16 Oct 2019 14:37:10 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191016133710.GB35139@google.com>
References: <20191014085235.GW16384@42.do-not-panic.com>
 <20191014144440.GG35313@google.com>
 <20191016125030.GH16384@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191016125030.GH16384@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:50:30PM +0000, Luis Chamberlain wrote:
>On Mon, Oct 14, 2019 at 03:44:40PM +0100, Matthias Maennich wrote:
>> Hi Luis!
>>
>> On Mon, Oct 14, 2019 at 08:52:35AM +0000, Luis Chamberlain wrote:
>> > On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
>> > > On 10.10.2019 19:15, Luis Chamberlain wrote:
>> > > >
>> > > >
>> > > > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>> > > >
>> > > >        MODULE_SOFTDEP("pre: realtek")
>> > > >
>> > > >     Are you aware of any current issues with module loading
>> > > >     that could cause this problem?
>> > > >
>> > > >
>> > > > Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
>> > > >
>> > > > If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
>> > > >
>> > > >   Luis
>> > >
>> > > Maybe issue is related to a bug in introduction of symbol namespaces, see here:
>> > > https://lkml.org/lkml/2019/10/11/659
>> >
>> > Can you have your user with issues either revert 8651ec01daed or apply the fixes
>> > mentioned by Matthias to see if that was the issue?
>> >
>> > Matthias what module did you run into which let you run into the issue
>> > with depmod? I ask as I think it would be wise for us to add a test case
>> > using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
>> > regression you detected.
>>
>> The depmod warning can be reproduced when using a symbol that is built
>> into vmlinux and used from a module. E.g. with CONFIG_USB_STORAGE=y and
>> CONFIG_USB_UAS=m, the symbol `usb_stor_adjust_quirks` is built in with
>> namespace USB_STORAGE and depmod stumbles upon this emitting the
>> following warning (e.g. during make modules_install).
>>
>>  depmod: WARNING: [...]/uas.ko needs unknown symbol usb_stor_adjust_quirks
>>
>> As there is another (less intrusive) way of implementing the namespace
>> feature, I posted a patch series [1] on last Thursday that should
>> mitigate the issue as the ksymtab entries depmod eventually relies on
>> are no longer carrying the namespace in their names.
>>
>> Cheers,
>> Matthias
>>
>> [1] https://lore.kernel.org/lkml/20191010151443.7399-1-maennich@google.com/
>
>Yes but kmalloc() is built-in, and used by *all* drivers compiled as
>modules, so why was that an issue?

I believe you meant, "why was that *not* an issue?".
In ksymtab, namespaced symbols had the format

  __ksymtab_<NAMESPACE>.<symbol>

while symbols without namespace would still use the old format

  __ksymtab_<symbol>

These are also the names that are extracted into System.map (using
scripts/mksysmap). Depmod is reading the System.map and for symbols used
by modules that are in a namespace, it would not find a match as it does
not understand the namespace notation. Depmod would still not emit a
warning for symbols without namespace as their format did not change.

Cheers,
Matthias

>
>  Luis
