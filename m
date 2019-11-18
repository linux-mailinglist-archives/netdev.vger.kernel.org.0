Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB701002CB
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfKRKqy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Nov 2019 05:46:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:49610 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRKqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:46:54 -0500
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iWeYG-0007zG-PF; Mon, 18 Nov 2019 11:46:36 +0100
Date:   Mon, 18 Nov 2019 11:46:36 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
Message-ID: <20191118104636.yrt5dz2zxvpjtgkk@linutronix.de>
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
 <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
 <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
 <5b45c8f6-1aa2-2e1e-9019-a140988bba80@jv-coder.de>
 <20191028151447.xwtyh6hfwfvzwmmu@linutronix.de>
 <5575bb95-b89a-727d-0587-9c462f1fddef@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5575bb95-b89a-727d-0587-9c462f1fddef@jv-coder.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-29 08:33:01 [+0100], Joerg Vehlow wrote:
> I testes again with 5.0.19-rt10 and 5.0.19-rt11  and I am pretty sure
> the bug wasfixed by the changes in rt11. I was able to reproduce it with
> rt10 within secondsand unable to reproduce it at all in several minutes on
> rt11. Will 4.19 rt patches receive anymore updates? Is it possible to
> backport
> the changes to softirq/BH habdling from 5.0.16-rt11 to 4.19?

Oh, sorry, I almost forgot about it.
Please repost the patch, state "RT" next to "PATCH" in the subject line.
Please state which kernels are affected (v4.19 and earlier due to BH
rework) and how this can be tested.
The patch/fix should be included in the affected kernels. The softirq
changes are very intrusive and can not be backported for the RT-stable
kernels.

Sebastian
