Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E4E26C1F1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgIPLAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 07:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgIPKeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 06:34:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B61EC061222
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 03:34:33 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so6273136wrn.13
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 03:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mwjb/6V6tLL+6i19tWf9cpaEUzM4KdeyjSnTmhOi4Mc=;
        b=bqaKAdLmgZaJV7L1s6ljxOLzJY0awLwFjfPknTPnvCqEN2tYxuaZ/nNsfbHoyBcIXF
         oGfAdDpfZ622txpVcI5BtzYBDpBWN18zg8Te4zgNZ/bJKD2wYANFIH1+aJTDM7h/17T8
         8pl/DjF52h3bgaEFEcAA6EmQSPYx08o1UO1NN2MQw3K/x6ZaKOJuaVs5tSsZXidtNYsq
         tSPnfZvVBHODGo2oB7uDPe/G2L7Fh620+5uiqDiM8nro1boft6oReUV5VUKVVTd0cMqV
         S3o/IhU0N2TkecHqH14liVNjdOD/0lWM/aquJTRjzEzCL9kH5L9R+4UtH5V1jvheaDZu
         tfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mwjb/6V6tLL+6i19tWf9cpaEUzM4KdeyjSnTmhOi4Mc=;
        b=RfZG4BXV/H8HLXYuPtI/SPj8R9qZpGBoQBYWOrp+TY5iWxoZ2KkmO1olB17pF5+sn5
         YY3cdGjA0MNG94CJYXruk3g+BsOy8LsUyY9RgDYrIafjvwO3FwRYprzMmbHXQouRL8KW
         flBkVxcejlveTi4KgN7/I9mBeqpRN6cmEoUe6TjBEIHUbRNUl1fzS4xhbUJ5S6Pkv+e/
         E3jYsSVIsl2VNuJXcXGcwjhjXYPJe3QtKXmbeMq2Unlo8rHA/YQuS7CLu0ls5vYBYUOE
         h+LTKsK5NnoBZn9shTUB/BCB2/jp5GGqpv7AsvVsY5YcNo1uN5hOmEPT9/qni/tD5Rt4
         LfOA==
X-Gm-Message-State: AOAM530B0kQuLib+b48O2hlm+RB0tkxEAsXAre+GaMnk9zDFqe97Wj9c
        ogYyTWCB8Brwz/r3ic4Tke230Q==
X-Google-Smtp-Source: ABdhPJwozht5PdwAnzcnVhUOQcmIn7GmTqjzATyD7S3zt/1AzxIiBUKq5TM3446+ZlSsmJBa8VM7DQ==
X-Received: by 2002:adf:e488:: with SMTP id i8mr27639492wrm.116.1600252471989;
        Wed, 16 Sep 2020 03:34:31 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 189sm4702629wmb.3.2020.09.16.03.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 03:34:31 -0700 (PDT)
Date:   Wed, 16 Sep 2020 12:34:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200916103430.GA2298@nanopsycho.orion>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion>
 <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion>
 <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 07, 2020 at 12:59:45PM CEST, sundeep.lkml@gmail.com wrote:
>Hi Jakub,
>
>On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
>> > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
>> > > >be many instances of the same devices. So there can be 10's of instances of
>> > > AF, PF and VFs.
>> > >
>> > > So you can still have per-pci device devlink instance and use the tracepoint
>> > > Jakub suggested.
>> > >
>> >
>> > Two things
>> > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
>> >   which is in the process of upstreaming. There also we would need trace points.
>> >   Not sure registering to devlink just for the sake of tracepoint is proper.
>> >
>> > - The devlink trace message is like this
>> >
>> >    TRACE_EVENT(devlink_hwmsg,
>> >      . . .
>> >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
>> >                   __get_str(bus_name), __get_str(dev_name),
>> >                   __get_str(driver_name), __entry->incoming, __entry->type,
>> >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
>> >    );
>> >
>> >    Whatever debug message we want as output doesn't fit into this.
>>
>> Make use of the standard devlink tracepoint wherever applicable, and you
>> can keep your extra ones if you want (as long as Jiri don't object).
>
>Sure and noted. I have tried to use devlink tracepoints and since it
>could not fit our purpose I used these.

Why exactly the existing TP didn't fit your need?

>
>Thanks,
>Sundeep
