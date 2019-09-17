Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95ADB580D
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 00:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfIQWe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 18:34:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41300 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfIQWe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 18:34:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id f20so2374645edv.8
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 15:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fTzO0ms8tIGdTmA1uWxx590B01VCkrTSh+iJuOCQSlw=;
        b=WCKumDDOF3xHQBBM5aYhETY2ipMvxXLpX8EQLDAvh9DiJ7G6XnQCZdGqXVPm3+o/dd
         ZEuW9RO+yyY7zx8RbR3Mp3DLJg2lYBblWd3HtD+u4MG4WBIJR3oNebs5iXQymmuSKoWa
         /SIxM9xrMv2h3GeAaCNe2Oz5YxggOdrCi3I+D31eMMJqYhmyCfcE67bmCeDvsaXVwArI
         QvUnca83MyWu3lKl09Ob4MYzTeMmtci79x8rgCKlZaVNdUdPDs1BrFJXk4u4gpYqu0GT
         vgRT7YES3G1UUPw8mXRy6P3fYF+PCq2nLcj/TQmN3iBjhtDaUv8/ucMtaj+DJZBSv9nk
         mJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fTzO0ms8tIGdTmA1uWxx590B01VCkrTSh+iJuOCQSlw=;
        b=fh3VVwcf1crWSz0STpR5f5Z0KRjdDWYiDvdYZpAW0w10ZSzr34DDGUG7mTcuOP6MZG
         8Bq538BdWEuSrWLg0H5h29S3UhQitbnu4CpumXwDJMzscpfQIboUlLdHG6c7/o7q2c4g
         KnEokYZyMVZXgkSnlGcFOrIKFAg9KL7gaR3zRsKaoXdm4B+4E8+xQz8bjpMBG0/uW4sA
         Mcuc9R6LwNIs9kKYMqyIs3VUupBr9DtiO/amxb49LjxnnHJ1io/IwSYHx19+QoTC4Z5e
         I9pb2jhSwbs6G2YdqJ18gw8VjRumhx6pGkuhB/pLp4uOiU0E1BWpMrMQ0vM58xVG2xEl
         dJUg==
X-Gm-Message-State: APjAAAU3Izm5p6XzsMySliFdb0S2uMj3TCBYQyU3gCckk8FR5LK/X6zV
        T9hsCifAKbXtGK/RfDYOR1g=
X-Google-Smtp-Source: APXvYqztHPpuLn0cZskjK4PzDBD3Rq3FML793TR0PcZBFlE2nd/3FBk2/F39uAFsNDQRadLPybwSRA==
X-Received: by 2002:a50:c3c7:: with SMTP id i7mr7207388edf.138.1568759667048;
        Tue, 17 Sep 2019 15:34:27 -0700 (PDT)
Received: from i5wan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id s16sm663441edd.39.2019.09.17.15.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 15:34:25 -0700 (PDT)
Date:   Wed, 18 Sep 2019 00:32:32 +0200
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add support for port
 mirroring
Message-ID: <20190917223232.GA32887@i5wan>
References: <20190917202301.GA29966@i5wan>
 <20190917205505.GF9591@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917205505.GF9591@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 10:55:05PM +0200, Andrew Lunn wrote:
> On Tue, Sep 17, 2019 at 10:23:01PM +0200, Iwan R Timmer wrote:
> > Add support for configuring port mirroring through the cls_matchall
> > classifier. We do a full ingress and/or egress capture towards the
> > capture port, configured with set_egress_port.
> 
> Hi Iwan
> 
> This looks good as far as it goes.
> 
> Have you tried adding/deleting multiple port mirrors? Do we need to
> limit how many are added. A quick look at the datasheet, you can
> define one egress mirror port and one ingress mirror port. I think you
> can have multiple ports mirroring ingress to that one ingress mirror
> port. And you can have multiple port mirroring egress to the one
> egress mirror port. We should add code to check this, and return
> -EBUSY if the existing configuration prevents a new mirror being
> configured.
> 
> Thanks
> 	Andrew

Hi Andrew,

I only own a simple 5 ports switch (88E6176) which has no problem of
mirroring the other ports to a single port. Except for a bandwith
shortage ofcourse. While I thought I checked adding and removing ports,
I seemed to forgot to check removing ingress traffic as it will now
disable mirroring egress traffic. Searching for how I can distinct
ingress from egress mirroring in port_mirror_del, I saw there is a
variable in the mirror struct called ingress. Which seems strange,
because why is it a seperate argument to the port_mirror_add function?

Origally I planned to be able to set the egress and ingress mirror
seperatly. But in my laziness when I saw there already was a function
to configure the destination port this functionality was lost.

Because the other drivers which implemented the port_mirror_add (b53 and
ksz9477) also lacks additional checks to prevent new mirror filters from
breaking previous ones I assumed they were not necessary.

At least I will soon sent a new version with at least the issue of
removing mirror ingress traffic fixed and the ability to define a 
seperate ingress and egress port.

Regards,
Iwan
