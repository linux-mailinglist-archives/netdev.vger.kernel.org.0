Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78021086A5
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 04:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfKYDCx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 24 Nov 2019 22:02:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKYDCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 22:02:53 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F67A14BE91A5;
        Sun, 24 Nov 2019 19:02:52 -0800 (PST)
Date:   Sun, 24 Nov 2019 19:02:49 -0800 (PST)
Message-Id: <20191124.190249.1262907259702322148.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Subject: Re: xfrmi: request for stable trees
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191124100746.GD14361@gauss3.secunet.de>
References: <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
        <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
        <20191124100746.GD14361@gauss3.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Nov 2019 19:02:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Sun, 24 Nov 2019 11:07:46 +0100

> On Mon, Nov 18, 2019 at 04:31:14PM +0100, Nicolas Dichtel wrote:
>> Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
>> > Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
>> >> 1) Several xfrm interface fixes from Nicolas Dichtel:
>> >>    - Avoid an interface ID corruption on changelink.
>> >>    - Fix wrong intterface names in the logs.
>> >>    - Fix a list corruption when changing network namespaces.
>> >>    - Fix unregistation of the underying phydev.
>> > Is it possible to queue those patches for the stable trees?
>> 
>> Is there a chance to get them in the 4.19 stable tree?
>> 
>> Here are the sha1:
>> e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
>> e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
>> c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
>> 22d6552f827e ("xfrm interface: fix management of phydev")
> 
> I'm ok with this. David does the stable submitting for
> networking patches usually. So I guess he will pick them
> into his stable queue after the patches are mainline some
> time.

Steffen you can submit things directly to -stable for IPSEC if you
wish, and it would help me in this case.

Thanks!
