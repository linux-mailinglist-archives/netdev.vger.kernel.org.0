Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6731326D364
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgIQGEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQGEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:04:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCE9C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 23:04:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so1576318ejb.1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 23:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hvNbwTZwzZgyj/0qtecok/Nbf7vvPX4dKWQ7X0Xs6VU=;
        b=Cfha07paoEWxVCHc+QNc9BsHG7140H39C+TlNmSPZzLT7fNTeLKr1V2n30MQRWbKP7
         vpxNe2s2G6gQLMdJmwjf1pNvbw5nFzTkLZV1r0J7YggW7izA2SeWvboyq+nibHxKfgEn
         oYTwNun/sMFSecmalPbQ0agKktKSX4JrifFkzjKirKwjAV1TqzssX27UJtlJl/26BFIK
         PpPR9c6vX51nL+bVuauzVTuEIo2yW0Yph2lR3zhT1OWV9157dm2hL5bKApGPOPpGphVL
         RzKM+krSAG9dKuZS6+tcRRL6v1le5SbzZ1wiTfEiWin9IXnFG9SJg8lQ1fWWJulOt+6y
         wfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hvNbwTZwzZgyj/0qtecok/Nbf7vvPX4dKWQ7X0Xs6VU=;
        b=nRBP4dQ7WP2bR8e2Id7PeNLycFXyPEpxGQjGfeWHJAYgrNG+A2K/7LxG+i2wAn4eOR
         JXzWDfGk3/RGvJQqEuM70w/WPZNoNlfKTLbbiYnF3rzo///P1VQmnIYWutckRB9XNzv6
         UO8mFGPQWWqVZ+pFxJlmkD9uKeyOaflDWKKZnixBntkbbyhBxtUsYIGTH1XHvGZUq+gv
         2zvGRWtXZ5/DBwubGNX7TuOCXYEO9ElKC91Pz9xDZObbIxgt4R5AS1zu0l3uMAv86WIe
         HTpsqJVslsV3g89RbnrX+ZYOSSxgzso81pSKDKjyly+a1bbflv3OZikl0ffI+38BEHT3
         daOw==
X-Gm-Message-State: AOAM531CR4/HZhdIOKYQtFEgBJaoudB1TLJBYo6Iks8QStnLFFUfL3kg
        0oi0/uR5TfxSug0twEEpPpenVA==
X-Google-Smtp-Source: ABdhPJzJor9AQT0VeFbhA/wEFF14PjaVPlimBbVjGP17T+T29+1823JzscasfBkOP4Czwll5RnVoyA==
X-Received: by 2002:a17:906:c830:: with SMTP id dd16mr29813709ejb.196.1600322686716;
        Wed, 16 Sep 2020 23:04:46 -0700 (PDT)
Received: from localhost (ip-94-113-111-128.net.upcbroadband.cz. [94.113.111.128])
        by smtp.gmail.com with ESMTPSA id h64sm9836005edd.50.2020.09.16.23.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 23:04:46 -0700 (PDT)
Date:   Thu, 17 Sep 2020 08:04:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200917060445.GA2244@nanopsycho>
References: <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion>
 <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion>
 <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
 <20200916103430.GA2298@nanopsycho.orion>
 <CALHRZuru42FZUQ=8S8k2M7Xsp8_9Lh8HrDMxf8LPQmw=Svc15Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZuru42FZUQ=8S8k2M7Xsp8_9Lh8HrDMxf8LPQmw=Svc15Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 16, 2020 at 07:19:36PM CEST, sundeep.lkml@gmail.com wrote:
>On Wed, Sep 16, 2020 at 4:04 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Sep 07, 2020 at 12:59:45PM CEST, sundeep.lkml@gmail.com wrote:
>> >Hi Jakub,
>> >
>> >On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>> >>
>> >> On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
>> >> > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
>> >> > > >be many instances of the same devices. So there can be 10's of instances of
>> >> > > AF, PF and VFs.
>> >> > >
>> >> > > So you can still have per-pci device devlink instance and use the tracepoint
>> >> > > Jakub suggested.
>> >> > >
>> >> >
>> >> > Two things
>> >> > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
>> >> >   which is in the process of upstreaming. There also we would need trace points.
>> >> >   Not sure registering to devlink just for the sake of tracepoint is proper.
>> >> >
>> >> > - The devlink trace message is like this
>> >> >
>> >> >    TRACE_EVENT(devlink_hwmsg,
>> >> >      . . .
>> >> >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
>> >> >                   __get_str(bus_name), __get_str(dev_name),
>> >> >                   __get_str(driver_name), __entry->incoming, __entry->type,
>> >> >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
>> >> >    );
>> >> >
>> >> >    Whatever debug message we want as output doesn't fit into this.
>> >>
>> >> Make use of the standard devlink tracepoint wherever applicable, and you
>> >> can keep your extra ones if you want (as long as Jiri don't object).
>> >
>> >Sure and noted. I have tried to use devlink tracepoints and since it
>> >could not fit our purpose I used these.
>>
>> Why exactly the existing TP didn't fit your need?
>>
>Existing TP has provision to dump skb and trace error strings with
>error code but
>we are trying to trace the entire mailbox flow of the AF/PF and VF
>drivers. In particular
>we trace the below:
>    message allocation with message id and size at initiator.
>    number of messages sent and total size.
>    check message requester id, response id and response code after
>reply is received.
>    interrupts happened on behalf of mailboxes in the entire process
>with source and receiver of interrupt along with isr status.
>    error like initiator timeout waiting for response.
>  All the above are relevant and are required for Octeontx2 only hence
>used own tracepoints.

You can still use devlink_hwmsg for the actual data exchanged between
the driver and hw. For the rest, you can have driver-specific TPs.


>
>Thanks,
>Sundeep
>
>> >
>> >Thanks,
>> >Sundeep
