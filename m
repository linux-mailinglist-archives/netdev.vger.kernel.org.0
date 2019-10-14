Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3389D657E
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbfJNOoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 10:44:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50723 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732932AbfJNOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 10:44:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so17596044wmg.0
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 07:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lV9WUHRQYa+vcbnXaIrl9dHPzPBQxfzmjkh8HTlj1Bg=;
        b=R4Sv0nu/0zTthcOB5gdAeVN4GjOy9iItL0K/CL5nKP+gYb8+0NlbvVtDbWrASvGTFg
         Xq15G3Gif4VH+0edHvuVUs3yIveqxdNZS+8W6cN8Flbst2a09CdpfrX6aj/yKZ1HvxOG
         cQU1WqMXDcgvms+37/3cqYRyAB5jN2IxSxkEyEBgja6lyNdKXHm0CEv1CMkA8A+C5OWg
         43HJiqe22PxAK/W1GQfdSX6aDYU4+E4RJnH8Y8nwGD/OLM46seNi4tRfEWtaWljw1njn
         v6hKrQOmlP1FYMfLEPltHPE+Lmo/zYA5/AtOZspeSJfUN9bqOQMmuTW+F49uO98xA3J+
         dvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lV9WUHRQYa+vcbnXaIrl9dHPzPBQxfzmjkh8HTlj1Bg=;
        b=dWD8xE95ulQ7taxaVoWOq6UMrgqGbw0lD3SL6Tb+l34C/ryyQdWMzSQr301i9SWbY8
         yjQ2MV/mJpPy6wX2ukkhvJEsNhnlGlsr3t8Shttm4x8aBO5hgqwJwjRUH0tcgao9/FbR
         eVjbTfencb58ZURB9jtoaAFYtDw7xgd0sLL1hahcDGgvIwQjiG/idVShA6T62IXbMAfN
         thupVlTtVHYQ14EP0VjTVVvRTAmL6VQpOdk1INsy4NuybwoFPgXXNJFM/zCXmghaRAtP
         9YKnRNXLoZMRRRzZaySIWK81LqGANGWcd7l4XzZ3SV8eQIlEbG4AnlFra4lAOckrPqW4
         eh/Q==
X-Gm-Message-State: APjAAAW3wWGZyMqW+wvoF1TJz/30lHZUlqV6zaCy2qNTqe2HW74KkgG6
        88cJLAg5o3EMJinn1Vdi2ktjVQcDVA8=
X-Google-Smtp-Source: APXvYqzTSv6CMEyQM3i6C4SK/hTjeAMaTon8/RvoovUvDlefqH05gxDzk92qF3PTigpHHIEcQwWRyw==
X-Received: by 2002:a05:600c:2481:: with SMTP id 1mr14687975wms.98.1571064280936;
        Mon, 14 Oct 2019 07:44:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id z189sm33273049wmc.25.2019.10.14.07.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 07:44:40 -0700 (PDT)
Date:   Mon, 14 Oct 2019 15:44:40 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191014144440.GG35313@google.com>
References: <20191014085235.GW16384@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191014085235.GW16384@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luis!

On Mon, Oct 14, 2019 at 08:52:35AM +0000, Luis Chamberlain wrote:
>On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
>> On 10.10.2019 19:15, Luis Chamberlain wrote:
>> >
>> >
>> > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>> >
>> >        MODULE_SOFTDEP("pre: realtek")
>> >
>> >     Are you aware of any current issues with module loading
>> >     that could cause this problem?
>> >
>> >
>> > Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
>> >
>> > If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
>> >
>> >   Luis
>>
>> Maybe issue is related to a bug in introduction of symbol namespaces, see here:
>> https://lkml.org/lkml/2019/10/11/659
>
>Can you have your user with issues either revert 8651ec01daed or apply the fixes
>mentioned by Matthias to see if that was the issue?
>
>Matthias what module did you run into which let you run into the issue
>with depmod? I ask as I think it would be wise for us to add a test case
>using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
>regression you detected.

The depmod warning can be reproduced when using a symbol that is built
into vmlinux and used from a module. E.g. with CONFIG_USB_STORAGE=y and
CONFIG_USB_UAS=m, the symbol `usb_stor_adjust_quirks` is built in with
namespace USB_STORAGE and depmod stumbles upon this emitting the
following warning (e.g. during make modules_install).

  depmod: WARNING: [...]/uas.ko needs unknown symbol usb_stor_adjust_quirks

As there is another (less intrusive) way of implementing the namespace
feature, I posted a patch series [1] on last Thursday that should
mitigate the issue as the ksymtab entries depmod eventually relies on
are no longer carrying the namespace in their names.

Cheers,
Matthias

[1] https://lore.kernel.org/lkml/20191010151443.7399-1-maennich@google.com/

>
>  Luis
