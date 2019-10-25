Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA857E5454
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfJYTZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:25:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38780 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfJYTZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:25:34 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iO5D1-0004A5-Fy; Fri, 25 Oct 2019 21:25:15 +0200
Date:   Fri, 25 Oct 2019 21:25:15 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Tom Rix <trix@redhat.com>
Cc:     Joerg Vehlow <lkml@jv-coder.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
Message-ID: <20191025192515.onr3c3yb3zxgvcx2@linutronix.de>
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
 <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
 <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
 <CACVy4SVAsG37n7q6jrRPSr-WV2QxSympuNQC2j+GJzBXqfwvtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACVy4SVAsG37n7q6jrRPSr-WV2QxSympuNQC2j+GJzBXqfwvtQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 07:26:49 [-0700], Tom Rix wrote:
> I will work on refactoring the patch to v5.2-rt.

please verify first that the issue still exists.

> trix

Sebastian
