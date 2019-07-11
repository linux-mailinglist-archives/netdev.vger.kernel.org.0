Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23178651A9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfGKFyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfGKFyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 01:54:33 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C79B620872;
        Thu, 11 Jul 2019 05:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562824472;
        bh=yORBKndUdJp0QPxy5gc6aaEDuQpabzg64cD55IuzLXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yEod7BaavWmldLciggIA1ku2KamQ4bnSf2tF+Hi/P9NrTXBb56q6ldZDRUqWcFCZL
         i1SpyvxEVDsrELo2BebhlkGzXhpYITyMuAYJkyX7/CmFvKAToSGNrUhIKuf/ZxJuAl
         F7FCI5z5ZFtSuzwbzX9bfp2/IT/rc/15oD87mc+U=
Date:   Thu, 11 Jul 2019 08:54:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: Fw: [Bug 204099] New: systemd-networkd fails on 5.2 - same
 version works on 5.1.16
Message-ID: <20190711055429.GB23598@mtr-leonro.mtl.com>
References: <20190709074344.76049d02@hermes.lan>
 <37ee2993-f81b-6265-87b0-1179162f1a2d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ee2993-f81b-6265-87b0-1179162f1a2d@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 04:43:18PM -0600, David Ahern wrote:
> On 7/9/19 8:43 AM, Stephen Hemminger wrote:
> > Looks like the stricter netlink validation broke userspace.
> > This is bad.

Actually, the initial bug in systemd and it is where it should be fixed.

>
> I believe other reports have traced this to
>
> commit 7dc2bccab0ee37ac28096b8fcdc390a679a15841
> Author: Maxim Mikityanskiy <maximmi@mellanox.com>
> Date:   Tue May 21 06:40:04 2019 +0000
>
>     Validate required parameters in inet6_validate_link_af
