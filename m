Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B216BF39
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 17:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfGQPh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 11:37:56 -0400
Received: from E.TopQuark.net ([168.235.66.66]:40386 "EHLO E.TopQuark.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfGQPh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 11:37:56 -0400
Received: from Mail1.TopQuark.net (pool-108-28-144-167.washdc.fios.verizon.net [108.28.144.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "Mail1.TopQuark.net", Issuer "TopQuark Mail Relay CA" (verified OK))
        by Mail2.TopQuark.net (Postfix) with ESMTPS id E0F4F304011B;
        Wed, 17 Jul 2019 11:37:49 -0400 (EDT)
Received: from Mail1.TopQuark.net (unknown [127.0.0.1])
        by Mail1.TopQuark.net (Postfix) with ESMTP id 1902E27EE17B;
        Wed, 17 Jul 2019 11:37:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=PaulSD.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=Z3Ry3UUiHANKLmo1lipK55Uxzsk=; b=G/VcgUX
        jCRUVaFmxGEGEuowWSkW/SKlCLPkTCttqKg4H2EImceW90iNFaGGRKm3zH9s5K9a
        tnowO46tklX94dyMI8qypzhtKW7QQZjFMSMxeTu4HGXv0vScO3gcKmEXLetWmdut
        YhEjtp9lc0RoRdG0TQ6EqtisbQAGLZVN2WIM=
Received: by Mail1.TopQuark.net (Postfix, from userid 1000)
        id DDDD727EE1B1; Wed, 17 Jul 2019 11:37:48 -0400 (EDT)
Date:   Wed, 17 Jul 2019 11:37:48 -0400
From:   Paul Donohue <linux-kernel@PaulSD.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: IPv6 L2TP issues related to 93531c67
Message-ID: <20190717153748.GG2622@TopQuark.net>
References: <20190715161827.GB2622@TopQuark.net>
 <d6db74f5-5add-7500-1b7a-fa62302a455f@gmail.com>
 <20190716135646.GE2622@TopQuark.net>
 <22e3eabc-526d-8265-ac39-a6aefc9ef7db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e3eabc-526d-8265-ac39-a6aefc9ef7db@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 05:11:21AM -0600, David Ahern wrote:
> This fixes the test script (whitespace damaged but simple enough to
> manually patch). See if it fixes the problem with your more complex
> setup. If so I will send a formal patch.

Yes! I applied this on top of f632a8170a6b667ee4e3f552087588f0fe13c4bb (master branch), and it fixes the problem on my systems.

Thank you very much!  I really appreciate all of your work on Linux networking!
