Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6362E3240B1
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhBXPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:21:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235664AbhBXNzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:55:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEuc7-008EWZ-Dj; Wed, 24 Feb 2021 14:54:03 +0100
Date:   Wed, 24 Feb 2021 14:54:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     George McCollister <george.mccollister@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: hsr: add support for EntryForgetTime
Message-ID: <YDZae0VEYBn4RPxe@lunn.ch>
References: <d79b32d366ca49aca7821cb0b0edf52b@EXCH-SVR2013.eberle.local>
 <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
 <1373fd943aa346dabe33508e18e43ed9@EXCH-SVR2013.eberle.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373fd943aa346dabe33508e18e43ed9@EXCH-SVR2013.eberle.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You must decide if you want to send it for net or net-next. If you want to
> > send it for net-next you must wait Linus has closed the merge window and
> > this shows open:
> > http://vger.kernel.org/~davem/net-next.html
> > 
> > To send for net use the subject prefix "[PATCH net]".
> > To send for net-next use the subject prefix "[PATCH net-next]".
> > 
> > If you're using git format-patch you can use the following:
> > git format-patch --subject-prefix='PATCH net-next'
> > 
> > If you're just using git send-email you can use the --annotate option to edit
> > the patch subject manually.
> > 
> > Thanks and sorry for not mentioning this before, George McCollister
> 
> Thanks again for the very helpful hints. I hope the patch will be correct now.

Hi Marco

I know there is a lot of learn, doing the submission correct can be
harder than writing the code, at least for the first few patches.

One thing you missed is the patch version number in the Subject:
line. When there are multiple versions of a patch flying around, it
makes it easier to keep track of, if there is a version number.
Please try to remember this for you next patch. No need to resend just
because of this.


      Andrew
