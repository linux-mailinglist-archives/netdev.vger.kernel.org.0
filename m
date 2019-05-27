Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87BC2BBC8
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfE0Vdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:33:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32863 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfE0Vdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 17:33:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so10159480pfk.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 14:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oo+l5dqkenGdaWu5V62xv5Lwp20lmcm25QvuJlksiyg=;
        b=K66sq1g9D55mvXRtxUkh1xDtvyutqANxXOtarmXY0BgX/H8oQ+OxF7NOCR58HPxeIK
         ll6xospYcoEFnMvSU8rKEQ8xNr8z2fwS4AB2gNmtt5to/bhdUhm/tYKFK8zrZqklnkG1
         zE4d1OjyXokFdYIMkiCRW8Bx2y3TBOUqLcosxBtXDlotOWv83FvBN86p8WKpTgPTJgmZ
         yL46t4JVbkhsk3E/jsCJiHUiFULntMzvPYQn6xzabqpWQ5eJTTWQYzw+5WIS+yAAuhzJ
         ZfPAoTIpseLvqvNQd4BFcSy+x9eI9Az7wgW4lLLNi8/S6808H5+GH4r7Wy0X5bstAnql
         ob2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oo+l5dqkenGdaWu5V62xv5Lwp20lmcm25QvuJlksiyg=;
        b=EGYdukpW7PxIHA2KXgMOZ2I8I5bcKw6s6FtPhXbrfju2wKQ+9GRKEwwCuP1hbYJYWK
         0FuR/G6wr+Ka1dQIwQTl93zMTo1T8uDhhjIDBhAkCmx3GQpy4zdMVKEZ5l4DuY5Fe1hN
         jSSif5FAwMTy1zJkhfnHSEtsEZjhRZgkI6CzDbdke5+l1R7N+qkvgSUHtJsN6n+klItv
         Tp6WyiydOS1lwUncgnw0f1ubnbFEaijX/yTRH1e4SwiHzhK9Kkue03ALgatADn6oJCbR
         vQ0oWPc5423ZJ9tBo1Up1JP4+BaJ4UJvNwB6l7UbzVYcpZ0XdHdV8EN/4f98qI0XlR3V
         NhWg==
X-Gm-Message-State: APjAAAUcRuG8HV7lcH996UxXdnbdq+7uMubNAwYi9DTcOMjkKciavAih
        uANkeweoCbeTQc6H1ZyCrN7kcw==
X-Google-Smtp-Source: APXvYqy6VHSdG7D68oKgu2XolV7MZP2j5r1mc1V5yG8kO+OqfxWg9XXnKpOGkmf3/pf+vYeorF01FA==
X-Received: by 2002:a17:90a:cf12:: with SMTP id h18mr1035180pju.77.1558992823303;
        Mon, 27 May 2019 14:33:43 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z6sm23727363pfr.135.2019.05.27.14.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 14:33:43 -0700 (PDT)
Date:   Mon, 27 May 2019 14:33:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: Replace strncpy() by strscpy()
Message-ID: <20190527143341.1dbc04c8@hermes.lan>
In-Reply-To: <e354f8c2-37d2-e76f-872f-853741f2a258@embeddedor.com>
References: <20190527183855.GA32553@embeddedor>
        <20190527142026.3a07831f@hermes.lan>
        <e354f8c2-37d2-e76f-872f-853741f2a258@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 16:28:05 -0500
"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> On 5/27/19 4:20 PM, Stephen Hemminger wrote:
> > On Mon, 27 May 2019 13:38:55 -0500
> > "Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:
> >   
> >> The strncpy() function is being deprecated. Replace it by the safer
> >> strscpy() and fix the following Coverity warning:
> >>
> >> "Calling strncpy with a maximum size argument of 16 bytes on destination
> >> array ifrr.ifr_ifrn.ifrn_name of size 16 bytes might leave the destination
> >> string unterminated."
> >>
> >> Notice that, unlike strncpy(), strscpy() always null-terminates the
> >> destination string.
> >>
> >> Addresses-Coverity-ID: 1445537 ("Buffer not null terminated")
> >> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> >> ---
> >>  drivers/net/macvlan.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> >> index 61550122b563..0ccabde8e9c9 100644
> >> --- a/drivers/net/macvlan.c
> >> +++ b/drivers/net/macvlan.c
> >> @@ -831,7 +831,7 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> >>  	struct ifreq ifrr;
> >>  	int err = -EOPNOTSUPP;
> >>  
> >> -	strncpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
> >> +	strscpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
> >>  	ifrr.ifr_ifru = ifr->ifr_ifru;
> >>  
> >>  	switch (cmd) {  
> > 
> > Why not use strlcpy like all the other places IFNAMSIZ is copied?
> >   
> 
> strlcpy() is also being deprecated.

Are you going to fix all these:
$ git grep strlcpy | grep IFNAMSIZ| wc -l
47
