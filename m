Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D2C281070
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJBKQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:16:20 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:42309 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgJBKQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 06:16:19 -0400
X-Greylist: delayed 1169 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2020 06:16:19 EDT
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0929um9J003819;
        Fri, 2 Oct 2020 11:56:48 +0200
Date:   Fri, 2 Oct 2020 11:56:48 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ??? <muryo.ye@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Why ping latency is smaller with shorter send interval?
Message-ID: <20201002095648.GB3783@1wt.eu>
References: <CAP0D=1X946M=yy=hMBvXuT11paPqxMi_xens-R4m7vyCnkUQzw@mail.gmail.com>
 <0d8f732d-03e1-75f0-09fd-520911088c0d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d8f732d-03e1-75f0-09fd-520911088c0d@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 11:26:00AM +0200, Eric Dumazet wrote:
> 2) Idle cpus can be put in a power conserving state.
>   It takes time to exit from these states, as you noticed.
>   These delays can typically be around 50 usec, or more.

This is often the case in my experience. I'm even used to starting a
busy loop in SCHED_IDLE prio on certain machines or in certain VMs
just to keep them busy, and to see the ping latency cut in half.

Willy
