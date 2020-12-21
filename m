Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF142E00B4
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgLUTIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgLUTIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:08:24 -0500
Date:   Mon, 21 Dec 2020 14:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608577663;
        bh=nzodhQOYcOtmkolYERXSw4lgxDNMgE+5FfZpLkVIado=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZs/Comh3uyd98CpHKwcSiNXvWMsci4k+kM3LQOVJqZ/VgTxn/RGvUYZm17eQQxbP
         oSt2fbpKFTMx1Klj4ri10ibTY0MQiyYU6PkFQu23Rx1O5iJ2XL/NoFvrzRBfWvvS+h
         gFBg8SflDbPTYPmCfz/KL4kc+bMuoweP8S73WANMzMy3lE/0eDMHGJWB1r4k6BORwa
         io3WZ8hoheA19U4JwOAA7gSRvVkY6STRCNA/NXI/NLWQreOUsNgPlm7yLCVDYGv+GJ
         1DEe5Enpcuflj62iAF2Nmt3hRp68FJqa0EeYxXgQaC3C3AvWgqGceMcYoG491Scy1D
         gbUbAigvgS+ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201221190742.GE643756@sasha-vm>
References: <20201102180326.GA2416734@kroah.com>
 <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm>
 <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com>
 <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
 <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201221183032.GA1551@shell.armlinux.org.uk>
 <20201221104757.2cd8d68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201221104757.2cd8d68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 10:47:57AM -0800, Jakub Kicinski wrote:
>On Mon, 21 Dec 2020 18:30:32 +0000 Russell King - ARM Linux admin wrote:
>> On Mon, Dec 21, 2020 at 10:25:39AM -0800, Jakub Kicinski wrote:
>> > We need to work with stable maintainers on this, let's see..
>> >
>> > Greg asked for a clear description of what happens, from your
>> > previous response it sounds like a null-deref in mvpp2_mac_config().
>> > Is the netdev -> config -> netdev linking not ready by the time
>> > mvpp2_mac_config() is called?
>>
>> We are going round in circles, so nothing is going to happen.
>>
>> I stated in detail in one of my emails on the 10th December why the
>> problem occurs. So, Greg has the description already. There is no
>> need to repeat it.
>>
>> Can we please move forward with this?
>
>Well, the fact it wasn't quoted in Marcin's reply and that I didn't
>spot it when scanning the 30 email thread should be a clear enough
>indication whether pinging threads is a good strategy..
>
>A clear, fresh backport request would had been much more successful
>and easier for Greg to process. If you still don't see a reply in
>2 weeks, please just do that.
>
>In case Greg is in fact reading this:
>
>
>Greg, can we backport:
>
>6c2b49eb9671 ("net: mvpp2: add mvpp2_phylink_to_port() helper")

I've queued it for 5.4, thanks!

-- 
Thanks,
Sasha
