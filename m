Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D349D90C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiA0DO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:14:29 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:53530 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiA0DO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:14:29 -0500
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id CC3AD20129;
        Thu, 27 Jan 2022 11:14:14 +0800 (AWST)
Message-ID: <db81c2b5bd1fb2fb6410ce0d04e577bbff61ee1e.camel@codeconstruct.com.au>
Subject: Re: [Cake] [PATCH net] sch_cake: diffserv8 CS1 should be bulk
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Sebastian Moeller <moeller0@gmx.de>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        cake@lists.bufferbloat.net, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Thu, 27 Jan 2022 11:14:13 +0800
In-Reply-To: <242985FC-238B-442D-8D86-A49449FF963E@gmx.de>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
         <87r18w3wvq.fsf@toke.dk> <242985FC-238B-442D-8D86-A49449FF963E@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-25 at 12:54 +0100, Sebastian Moeller wrote:
> 
> LE(1) is tin 0 the lowest
> CS1(8) is 1 slightly above LE
> CS0/BE(0) is 2
> AF1x (10, 12, 14) are all in tin 1 as is CS1
...
> Just as documented in the code:
> 
>  *		Bog Standard             (CS0 etc.)
>  *		High Throughput          (AF1x, TOS2)
>  *		Background Traffic       (CS1, LE)

The documentation doesn't match the code though. Almost, but it's off by one.
I can submit a patch instead to change the docs, though it's not clear the
divergence between code and docs was intended in the first place.

(diffserv8 also needs a description in the cake manpage, I'll send a patch
for that once the order is clarified)

Cheers,
Matt

