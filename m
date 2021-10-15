Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A602442E546
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 02:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhJOAaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 20:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229983AbhJOAaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 20:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 065F4600CC;
        Fri, 15 Oct 2021 00:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634257681;
        bh=qgAzhKwAF3KDwxxqTXRD7qYDvukIZgRp5XGAGy+Qmzs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hb+jjMQFzu5/a9RADaTKjPfSg0IifgcCX+KhbrcjU7/u3uaVBMk75eQPquqeiF8CM
         pbLsbhQrM9nUY5t5lMP/LxOa2zXLqaSTgA35tphHw0tuulQxUpMmZTi3kwmmmF756R
         K/LVFjgpBBy7P5x1orFjx6A3984pKSV38dzw86Jz1Rc0i7/70SLybmfaXSlr3eoNVO
         NNu8dd1F70KSS4hdlRoGzae7nDovOSjbtKhcKesppigTP2eCLrYvBinlOMX+B9wNi/
         S9dIj+OIumNm+AFXkeK5sr0le0R+jLEExKY7tQGuqYQ2TQx725QM+Kh13Z4IHa9fdy
         glkqDgnzwR0xQ==
Date:   Thu, 14 Oct 2021 17:28:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [PATCH net 0/2] Correct the IOAM behavior for undefined trace
 type bits
Message-ID: <20211014172800.26374a35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011180412.22781-1-justin.iurman@uliege.be>
References: <20211011180412.22781-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 20:04:10 +0200 Justin Iurman wrote:
> (@Jakub @David: there will be a conflict for #2 when merging net->net-next, due
> to commit [1]. The conflict is only 5-10 lines for #2 (#1 should be fine) inside
> the file tools/testing/selftests/net/ioam6.sh, so quite short though possibly
> ugly. Sorry for that, I didn't expect to post this one... Had I known, I'd have
> made the opposite.)

Hi Justin, net was merged into net-next now, please double check the
resolution. I think it's the same as Stephen's [1]. In the future please
try to include a tree way diff or instructions on how to do the merge.

Thanks!

[1]
https://lore.kernel.org/all/20211013104227.62c4d3af@canb.auug.org.au/
