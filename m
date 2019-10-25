Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A677EE4882
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436922AbfJYKWS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Oct 2019 06:22:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37160 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409177AbfJYKWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 06:22:18 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iNwjL-0005Fl-Gu; Fri, 25 Oct 2019 12:22:03 +0200
Date:   Fri, 25 Oct 2019 12:22:03 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
Message-ID: <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
 <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 12:14:59 [+0200], Joerg Vehlow wrote:
> Here is one of the oops logs I still have:
> 
> [  139.717273] CPU: 2 PID: 11987 Comm: netstress Not tainted
> 4.19.59-rt24-preemt-rt #1

could you retry with the latest v5.2-RT, please? qemu should boot fine…

Sebastian
