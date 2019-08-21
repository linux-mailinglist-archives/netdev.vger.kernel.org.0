Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE997CFE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfHUO3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:29:20 -0400
Received: from elvis.franken.de ([193.175.24.41]:40130 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbfHUO3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:29:19 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1i0Rbv-00070m-00; Wed, 21 Aug 2019 16:29:15 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C8B50C275D; Wed, 21 Aug 2019 14:48:46 +0200 (CEST)
Date:   Wed, 21 Aug 2019 14:48:46 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 3/9] nvmem: core: add nvmem_device_find
Message-ID: <20190821124846.GA12591@alpha.franken.de>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-4-tbogendoerfer@suse.de>
 <8d18de64-9234-fcba-aa3d-b46789eb62a5@linaro.org>
 <20190814134616.b4dab3c0aa6ac913d78edb6a@suse.de>
 <31d680ee-ddb3-8536-c915-576222d263e1@linaro.org>
 <20190816140942.GA15050@alpha.franken.de>
 <fca76e6d-fa0b-176b-abcf-e7551b22e6a9@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fca76e6d-fa0b-176b-abcf-e7551b22e6a9@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 05:03:42PM +0100, Srinivas Kandagatla wrote:
> >>On 14/08/2019 12:46, Thomas Bogendoerfer wrote:
> >these patches are not in Linus tree, yet. I guess they will show up
> >in 5.4. No idea how to deal with it right now, do you ?
> All these patches are due to go in next merge window,
> You should base your patch on top of linux-next.

that depends, which maintainer will merge this series. Right now
it doesn't look like this series will make it into 5.4 as there
is still no sign form the W1 maintainer. My idea is to break out
the 5.4 parts and submit it. So I'll rebase the nvmem patch to
linux-next and send it. Hope it will be ok,  if the user of
the new function will show up in 5.5.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
