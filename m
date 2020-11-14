Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737C42B3084
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKNUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgKNUDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 15:03:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5182231B;
        Sat, 14 Nov 2020 20:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605384191;
        bh=L3Bu3Xs3Gt7CZ3XS4+LlTbCK0t4CN2vUuTntKk2ieJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VpzcMYLnTCW0hcNwtou6FwrDT6/8xX3B3r8kSWxlvvgTipsGvWTWAP1HE3+SZEqP+
         nxTtFNxVZIeoWfqmStowrrG8utiy5VXEIFxBzdEioU/ha2SJtfaD/0LGwHRKpn8B8p
         jTzwmtNkBw99vWAU490lcTLUnE5fW4XtLQlZ8m7o=
Date:   Sat, 14 Nov 2020 12:03:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: remove unused function ipv6_skb_idev()
Message-ID: <20201114120310.0378d56a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113183649.GA1436199@ubuntu-m3-large-x86>
References: <20201113135012.32499-1-lukas.bulwahn@gmail.com>
        <20201113183649.GA1436199@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 11:36:49 -0700 Nathan Chancellor wrote:
> On Fri, Nov 13, 2020 at 02:50:12PM +0100, Lukas Bulwahn wrote:
> > Commit bdb7cc643fc9 ("ipv6: Count interface receive statistics on the
> > ingress netdev") removed all callees for ipv6_skb_idev(). Hence, since
> > then, ipv6_skb_idev() is unused and make CC=clang W=1 warns:
> > 
> >   net/ipv6/exthdrs.c:909:33:
> >     warning: unused function 'ipv6_skb_idev' [-Wunused-function]
> > 
> > So, remove this unused function and a -Wunused-function warning.
> > 
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>  
> 
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks!
