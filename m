Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBC4424936
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbhJFVxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:53:21 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:60822 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbhJFVxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:53:19 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 0B75172C8C6;
        Thu,  7 Oct 2021 00:51:25 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id E5E1B7CF7F2; Thu,  7 Oct 2021 00:51:24 +0300 (MSK)
Date:   Thu, 7 Oct 2021 00:51:24 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        Eugene Syromyatnikov <evgsyr@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: strace build error static assertion failed: "XFRM_MSG_MAPPING !=
 0x26"
Message-ID: <20211006215124.GB11000@altlinux.org>
References: <1eb25b8f-09c0-8f5e-3227-f0f318785995@alliedtelesis.co.nz>
 <20211006214816.GA11000@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211006214816.GA11000@altlinux.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:48:16AM +0300, Dmitry V. Levin wrote:
> On Wed, Oct 06, 2021 at 09:43:11PM +0000, Chris Packham wrote:
> > Hi,
> > 
> > When compiling strace-5.14 (although it looks like the same problem 
> > would exist with bleeding edge strace) with headers from the tip of 
> > Linus's tree (5.15.0-rc4) I get the following error
> > 
> > strace: In file included from static_assert.h:11,
> > strace:ššššššššššššššššš from print_fields.h:12,
> > strace:ššššššššššššššššš from defs.h:1901,
> > strace:ššššššššššššššššš from netlink.c:10:
> > strace: xlat/nl_xfrm_types.h:162:1: error: static assertion failed: 
> > "XFRM_MSG_MAPPING != 0x26"
> > strace:š static_assert((XFRM_MSG_MAPPING) == (0x26), "XFRM_MSG_MAPPING 
> > != 0x26");
> > strace:š ^~~~~~~~~~~~~
> > 
> > It looks like commit 2d151d39073a ("xfrm: Add possibility to set the 
> > default to block if we have no policy") added some XFRM messages and the 
> > numbers shifted. Is this considered an ABI breakage?
> > 
> > I'm not sure if this is a strace problem or a linux problem so I'm 
> > reporting it in both places.
> 
> Yes, this is already covered by 
> https://lore.kernel.org/lkml/20210912122234.GA22469@asgard.redhat.com/T/#u
> 
> Thanks,

I wonder, why the fix hasn't been merged yet, though.


-- 
ldv
