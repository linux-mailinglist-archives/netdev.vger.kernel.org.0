Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800BBF9500
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLQBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:01:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40865 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:01:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id f3so3525931wmc.5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 08:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5GNy4kWoH7uUJb7iK5pCT2GbryG8qmSs8tn6dbpPoFo=;
        b=iVVMQ1fmMgLaW6nvD0WeX2flZJdNI1Pdxi/XRfDsklbkV52ptyrmUEKyVtD5UlX4CK
         yFYj4VzdlzAQziB1Iiype73Ipd1ebMmI1pksREnCOSjkDmZXENpoMXRq1qlVwRrdEEvK
         wzqUVgRy7oriFUkWH8rG2t9bMWnrrtVQfjaG3Gi4gU3mpqER76JaSemoMb76GGi3HE1S
         gLBe831WtvWgSlQAULxyLuNwtGkZ+IVODubeoMCMK0wiSewFo41/3kjY5PMaHtBegvvw
         JrXKjin+cZ/mRiY+C+PKZEJRMu+7MiuTmiSQj/iGZd7GwCE+ATr4JyU6it/goRt0kf2c
         Z/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5GNy4kWoH7uUJb7iK5pCT2GbryG8qmSs8tn6dbpPoFo=;
        b=rgzR7cFiTrDqhyxNzpVK7SURHAvinSX0hKlZ3zyvHzrVRyocU92hkcF99q/g04Yn9I
         QILA6RrjgZrvK2HeQ/erx5FNxOmIwRkCYoy3kHAb/q3uzgqxzq6ehD+U/QFQMX7suDfe
         MoF/l1Cvybr5E/xDB/oTf8WEu2Ft8YME8R2PzXSRbt/6nHydn8mwAlK27eBWH1aW+pJv
         oiaxOaPIv9aWp4jeFaUXUsSZKcIgqkKhzEy3RaRPSleUO/8MYMBD2BkBjFEiTF8tm+UI
         Y60s8D6nRhTIXSi5G0cPJuEumYVzVEBeWjUzbjH2CNuP0Mh+ceKwayQWFuE85JzGVETG
         hA9g==
X-Gm-Message-State: APjAAAVq6nIjdR8HvjPTuGgwFdtH+MY05eN72eH/4X9RIyKk/GFd6L02
        VFq0/58tqiiGP2OtFKf2ryctlniHOc0=
X-Google-Smtp-Source: APXvYqww5ypr9C4rNaoYMueY5yBv3xV2JIx02Cvj/Matw/UZbBFnNgPnKK46gfBATupwdRHEpq1/WQ==
X-Received: by 2002:a1c:3b05:: with SMTP id i5mr4816744wma.8.1573574480117;
        Tue, 12 Nov 2019 08:01:20 -0800 (PST)
Received: from C02YVCJELVCG ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id r15sm42582214wrc.5.2019.11.12.08.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:01:19 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:01:15 -0500
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Possibility of me mainlining Tehuti Networks 10GbE driver
Message-ID: <20191112160115.GA16865@C02YVCJELVCG>
References: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 02:24:44AM +0000, Nicholas Johnson wrote:
> Hi all,
> 
> To start off, if I am emailing the wrong people, please blame the output 
> of: "scripts/get_maintainer.pl drivers/net/ethernet/tehuti/" and let me 
> know who I should be contacting. Should I add in 
> "linux-kernel@vger.kernel.org"?
> 
> I just discovered that the Tehuti 10GbE networking drivers (required for 
> things such as some AKiTiO Thunderbolt to 10GbE adapters) are not in 
> mainline. I am interested in mainlining it, but need to know how much 
> work it would take and if it will force me to be the maintainer for all 
> eternity.
> 
> The driver, in tn40xx-0.3.6.15-c.tar appears to be available here:
> Link: https://www.akitio.com/faq/341-thunder3-10gbe-adapter-can-i-use-this-network-adapter-on-linux
> Also here:
> Link: https://github.com/acooks/tn40xx-driver
> 
> I see some immediate style problems and indentation issues. I can fix 
> these.
> 
> The current driver only works with Linux v4.19, I believe. There are a 
> small handful of compile errors with v5.4. I can probably fix these.
> 
> However, could somebody please comment on any technical issues that you 
> can see here? How much work do you think I would have to do to mainline 
> this? Would I have to buy such a device for testing? Would I have to buy 
> *all* of the supported devices for testing? Or can other people do that 
> for me?
> 
> I am not keen on having to buy anything without mainline support - it is 
> an instant disqualification of a hardware vendor. It results in a 
> terrible user experience for experienced people (might not be able to 
> use latest kernel which is needed for supporting other things) and is 
> debilitating for people new to Linux who do not how to use the terminal, 
> possibly enough so that they will go back to Windows.
> 
> Andy, what is your relationship to Tehuti Networks? Would you be happy 
> to maintain this if I mainlined it? It says you are maintainer of 
> drivers/net/ethernet/tehuti/ directory. I will not do this if I am 
> expected to maintain it - in no small part because I do not know a lot 
> about it. I will only be modifying what is currently available to make 
> it acceptable for mainline, if possible.

[Nicolas, sorry for the slow response -- I've been AFK for a bit.]

A long time ago, in a galaxy far, far away Tehuti sent me one of their
early 10GbE adapters and asked if I would help them take their driver
upstream.  They provided an out of tree driver as a basis and after a
few revisions David Miller agreed to take this into net-next.  The
driver as it exists today could use lots of work.  There were many items
on my TODO list for it, but I never made the time to clean it up
properly so it could still use some care and feeding.  I just checked my
cache of cards and unfortunately it looks like I do not have any of
these adapters at home any longer.  I may need to check the office to
see if I have one there, but I think chances are slim.

I'd feel better about helping to maintain the driver if there was
hardware available for whoever was doing the work.  It looks like there
are some pretty cheap (sub-200USD) cards available online that use that
chipset.  Frankly, I'd probably also feel better about maintaining it
and updating to all the coolest new features if I didn't currently work
at another hardware vendor, so I need to consider that.

I haven't pulled down their latest driver from github, but I'd be
curious to see how close the hardware drivers appear to be between the
40xx chipset and the original TOE SmartNIC[sic] that is supported
upstream today.  Did you by any chance compare the two?

> Also, license issues - does GPLv2 permit mainlining to happen? I believe 
> the Tehuti driver is available under GPLv2 (correct me if I am wrong).
> 
> Would I need to send patches for this, or for something this size, is it 
> better to send a pull request? If I am going to do patches, I will need 
> to make a gmail account or something, as Outlook messes with the 
> encoding of the things which I send.
> 
> Thanks for any comments on this.
> 
> Kind regards,
> Nicholas Johnson
