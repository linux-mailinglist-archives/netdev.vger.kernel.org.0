Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8794821CF
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbhLaDdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:33:05 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:40876 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLaDdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:33:04 -0500
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id C4BF72012D;
        Fri, 31 Dec 2021 11:33:01 +0800 (AWST)
Message-ID: <e20e47833649b5141fa327aa8113e34d4b1bbe15.camel@codeconstruct.com.au>
Subject: Re: [PATCH] mctp: Remove only static neighbour on RTM_DELNEIGH
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>,
        Gagan Kumar <gagan1kumar.cs@gmail.com>
Cc:     matt@codeconstruct.com.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 Dec 2021 11:33:00 +0800
In-Reply-To: <20211230175112.7daeb74e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
         <20211230175112.7daeb74e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub & Gagan,

> > Add neighbour source flag in mctp_neigh_remove(...) to allow
> > removal of only static neighbours.
> 
> Which are the only ones that exist today right?

That's correct. There may be a future facility for the kernel to perform
neighbour discovery itself (somewhat analogous to ARP), but only the
static entries are possible at the moment.

> Can you clarify the motivation and practical impact of the change 
> in the commit message to make it clear? AFAICT this is a no-op / prep
> for some later changes, right Jeremy?

Yes, it'll be a no-op now; I'm not aware of any changes coming that
require parameterisation of the neighbour type yet.

Gagan - can you provide any context on this change?

Cheers,


Jeremy
