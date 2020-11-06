Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A9B2A8F07
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 06:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKFFw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 00:52:29 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:57785 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgKFFw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 00:52:29 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 00:52:29 EST
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kauXU-0006e1-VJ; Fri, 06 Nov 2020 06:43:57 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kauXT-0002S9-Jk; Fri, 06 Nov 2020 06:43:55 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E92E924004B;
        Fri,  6 Nov 2020 06:43:54 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 4FFCF240049;
        Fri,  6 Nov 2020 06:43:54 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id D87F120049;
        Fri,  6 Nov 2020 06:43:53 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Nov 2020 06:43:53 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Organization: TDT AG
In-Reply-To: <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
Message-ID: <927918413d7c2e515e61d751b2424886@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1604641436-000013A4-FE3D097D/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-05 16:06, Arnd Bergmann wrote:
> ...
> Adding Martin Schiller and Andrew Hendry, plus the linux-x25 mailing
> list to Cc. When I last looked at the wan drivers, I think I concluded
> that this should still be kept around, but I do not remember why.
> OTOH if it was broken for a long time, that is a clear indication that
> it was in fact unused.

As Xie has already mentioned, the linux-x25 mailing list unfortunately
is broken for a long time. Maybe David could have a look at this.

I still use the X.25 subsystem together with the hdlc-x25 driver and as
I wrote some time ago this will continue for some time.

I'm also still contributing patches for it (even if only drop by drop).

But I have never used the x25_asy driver.

> ...
> 
> Hopefully Martin or Andrew can provide a definite Ack or Nack on this.
> 

ACK from my side, even if I'm a bit sorry about the work of Xie.

Acked-by: Martin Schiller <ms@dev.tdt.de>
