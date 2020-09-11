Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629A72663E0
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIKQ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgIKPWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:22:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9045207FB;
        Fri, 11 Sep 2020 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599837758;
        bh=KF+SM6aIBn3OyO0eNQnwwx03nzA7TACIYZpv2J3yp9U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hL7tU/I7nOYzJMA3X+i0rXaLApWXobE3+fvOXtf3FWFs6x5uOh1ldSI2Nn3622sqO
         qbeRDbQxp0x5TTrJlufODjVjBx/z3ROjAU5LyPyg6emXJms11cAxZNOHgrm1520xiM
         vZEIm5Pmnpkw3KeaX9FCl3fKGAEmxbXcm4TLbx+s=
Date:   Fri, 11 Sep 2020 08:22:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        David Miller <davem@davemloft.net>, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
Message-ID: <20200911082236.7dfb7937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911111158.GF1551@shell.armlinux.org.uk>
References: <20200910174826.511423-1-natechancellor@gmail.com>
        <20200910.152811.210183159970625640.davem@davemloft.net>
        <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
        <20200911111158.GF1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 12:11:58 +0100 Russell King - ARM Linux admin wrote:
> On Thu, Sep 10, 2020 at 05:31:42PM -0700, Nathan Chancellor wrote:
> > Ah great, that is indeed cleaner, thank you for letting me know!  
> 
> Hmm, I'm not sure why gcc didn't find that. Strangely, the 0-day bot
> seems to have only picked up on it with clang, not gcc.

May be similar to: https://lkml.org/lkml/2019/2/25/1092

Recent GCC is so bad at catching uninitialized vars I was considering
build testing with GCC8 :/
