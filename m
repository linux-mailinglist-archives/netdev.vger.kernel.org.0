Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458EFE47B9
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394393AbfJYJsT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Oct 2019 05:48:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37006 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391988AbfJYJsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:48:19 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iNwCM-0004dr-SG; Fri, 25 Oct 2019 11:47:58 +0200
Date:   Fri, 25 Oct 2019 11:47:58 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
Message-ID: <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 11:37:59 [+0200], Joerg Vehlow wrote:
> Hi,
> 
> I always expected this to be applied to the RT patches. That's why
> I originally send my patch to to Sebastian, Thomas and Steven (I added
> them again now. The website of the rt patches says patches for the
> CONFIG_REEMPT_RT patchset should be send to lkml.
> 
> I hope one of the rt patch maintainers will reply here.

I've seen the first patch and it was not mentioned that it was RT
related so I did not pay any attention to it. 
Please repost your v2, please add RT next to patch, please state the RT
version and the actual problem and I take a look.

> Jörg

Sebastian
