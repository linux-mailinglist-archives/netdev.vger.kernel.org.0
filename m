Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE04549F281
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346040AbiA1EbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:31:17 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:53662 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiA1EbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:31:16 -0500
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id D6AD520205;
        Fri, 28 Jan 2022 12:31:09 +0800 (AWST)
Message-ID: <6eb22909c04bfb561805ba8980e7f07d121ee90e.camel@codeconstruct.com.au>
Subject: Re: [Cake] [PATCH net] sch_cake: diffserv8 CS1 should be bulk
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Sebastian Moeller <moeller0@gmx.de>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        cake@lists.bufferbloat.net, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Fri, 28 Jan 2022 12:31:09 +0800
In-Reply-To: <82BBD116-4A04-4E19-9833-0DCB5134C73C@gmx.de>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
         <87r18w3wvq.fsf@toke.dk> <242985FC-238B-442D-8D86-A49449FF963E@gmx.de>
         <db81c2b5bd1fb2fb6410ce0d04e577bbff61ee1e.camel@codeconstruct.com.au>
         <82BBD116-4A04-4E19-9833-0DCB5134C73C@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-01-27 at 17:00 +0100, Sebastian Moeller wrote:
> > 
> > The documentation doesn't match the code though.
> 
> 	Since I did not see your original mail, only Toke's response, which documentation is wrong here?

Ah, I had missed that the docs were updated already on 6 Jan 2022.
Sorry for the noise!

9ed6786c19ae ("sch_cake: diffserv8 CS1 should be bulk")

Cheers,
Matt


