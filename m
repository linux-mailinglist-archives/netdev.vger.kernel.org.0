Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9721D2FC53B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394985AbhASNyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389385AbhASLwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 06:52:19 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512A7C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:51:18 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id y187so16458367wmd.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9J4slv4/qVpzcfAFRgdtq0+dmM+yCPPM0TKiha0SqVk=;
        b=FUnS5FfI1g5B51JClw9TWf7KDaJjE4rzOWmkm/9aR1yHUzAAbSxKUlKwOLmcFOnXfG
         VkTsqH68ylfkJA3Xo18nKGc8USiudtEKWj+knqU1DwwnSW9dOG1eSZ6Y45z2k01T5G0l
         1HQyylMTNubS+wWROTUCIm1mJ1xB8rCCi7qR1CvNckyscO2JPfkjc1k9J5U8sU6tr8An
         hRFiyZsQB85vkHNKauA+e9tWJX0XCcVLJ6TsYQGJtg5OkKcpdskME1+yXB4Ojvrkx5if
         DOWXFub1jTPk+tVGxvzjT8DhZZ3GSXCex2GhZdznEfnuUpTF3vA+RzelJ5XcWF6w3wZP
         HmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9J4slv4/qVpzcfAFRgdtq0+dmM+yCPPM0TKiha0SqVk=;
        b=c6NlyRix/tUZ4KNB09UmyX5lRwoyFifd8GFknP4H3rTvV0Z/xWUlaYLCIuSBcEpVTN
         e3JHB968J8fXuTY9+OcvBArjtnzqOsoKB3t11XHiHAlyHorHWbMxoXq4dwFD5zbWFYL4
         zO9jfE68wTafndmsIy0GA+fAeWwQvmS+SDb7u8HVaAqS+Bfrkp9Gxk6PiXSf9pRkoaj+
         /noUuty43KSYE280lzzGu3RthFrpIanCQfc/IbaKijmzD0KTxKw2IgiplAjlKUmw1JSu
         KYDtam0+MWLF2T8ApOo3Fe2LxykcbjhFID5WhZz3X6uEm75bOh69S2P3LKHlxEvhueHL
         wD2Q==
X-Gm-Message-State: AOAM532shHkA09A/A5Q49swnkQ1injyaQMNIu/i4ImbTuk3sGevLaaFD
        R/0EeiPUS1nSlc5UlawrCVZuAg==
X-Google-Smtp-Source: ABdhPJx/v166hIqCdvdSb+tNnbIfEjmCkEIdBHrN0nWxwo3xM2dZ6fjlWiZdCfVRC9DfhlURLmr5Qg==
X-Received: by 2002:a1c:a145:: with SMTP id k66mr3745247wme.18.1611057076918;
        Tue, 19 Jan 2021 03:51:16 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i4sm4233410wml.46.2021.01.19.03.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 03:51:16 -0800 (PST)
Date:   Tue, 19 Jan 2021 12:51:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210119115115.GY3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114074804.GK3565223@nanopsycho.orion>
 <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115143906.GM3565223@nanopsycho.orion>
 <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210118130009.GU3565223@nanopsycho.orion>
 <20210118095928.001b5687@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118095928.001b5687@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 18, 2021 at 06:59:28PM CET, kuba@kernel.org wrote:
>On Mon, 18 Jan 2021 14:00:09 +0100 Jiri Pirko wrote:
>> >> >Or to put it differently IMO the netdev should be provisioned if the
>> >> >system has a port into which user can plug in a cable. When there is     
>> >> 
>> >> Not really. For slit cables, the ports are provisioned not matter which
>> >> cable is connected, slitter 1->2/1->4 or 1->1 cable.
>> >> 
>> >>   
>> >> >a line card-sized hole in the chassis, I'd be surprised to see ports.
>> >> >
>> >> >That said I never worked with real world routers so maybe that's what
>> >> >they do. Maybe some with a Cisco router in the basement can tell us? :)    
>> >> 
>> >> The need for provision/pre-configure splitter/linecard is that the
>> >> ports/netdevices do not disapper/reappear when you replace
>> >> splitter/linecard. Consider a faulty linecard with one port burned. You
>> >> just want to replace it with new one. And in that case, you really don't
>> >> want kernel to remove netdevices and possibly mess up routing for
>> >> example.  
>> >
>> >Having a single burned port sounds like a relatively rare scenario.  
>> 
>> Hmm, rare in scale is common...
>
>Sure but at a scale of million switches it doesn't matter if a couple
>are re-configuring their routing.
>
>> >Reconfiguring routing is not the end of the world.  
>> 
>> Well, yes, but you don't really want netdevices to come and go then you
>> plug in/out cables/modules. That's why we have split implemented as we
>> do. I don't understand why do you think linecards are different.
>
>If I have an unused port it will still show up as a netdev.
>If I have an unused phymod slot w/ a slot cover in it, why would there
>be a netdev? Our definition of a physical port is something like "a
>socket for a networking cable on the outside of the device". With your
>code I can "provision" a phymod and there is no whole to plug in a
>cable. If we follow the same logic, if I have a server with PCIe
>hotplug, why can't I "provision" some netdevs for a NIC that I will
>plug in later?
>
>> Plus, I'm not really sure that our hw can report the type, will check.
>
>I think that's key.

So, it can't. The driver is only aware of "activation" of the linecard
being successful or not.


>
>> One way or another, I think that both configuration flows have valid
>> usecase. Some user may want pre-configuration, some user may want auto.
>> Btw, it is possible to implement splitter cable in auto mode as well.
>
>Auto as in iterate over possible configs until link up? That's nasty.
>
>> >> >If the device really needs this configuration / can't detect things
>> >> >automatically, then we gotta do something like what you have.
>> >> >The only question is do we still want to call it a line card.
>> >> >Sounds more like a front panel module. At Netronome we called 
>> >> >those phymods.    
>> >> 
>> >> Sure, the name is up to the discussion. We call it "linecard"
>> >> internally. I don't care about the name.  
>> >
>> >Yeah, let's call it something more appropriate to indicate its
>> >breakout/retimer/gearbox nature, and we'll be good :)  
>> 
>> Well, it can contain much more. It can contain a smartnic/fpga/whatever
>> for example. Not sure we can find something that fits to all cases.
>> I was thinking about it in the past, I think that the linecard is quite
>> appropriate. It connects with lines/lanes, and it does something,
>> either phy/gearbox, or just interconnects the lanes using smartnic/fpga
>> for example.
>
>If it has a FPGA / NPU in it, it's definitely auto-discoverable. 
>I don't understand why you think that it's okay to "provision" NICs
>which aren't there but only for this particular use case.
