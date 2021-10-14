Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5963142D6CD
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhJNKNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNKNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 06:13:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBCFC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 03:10:57 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1maxhN-0006vc-W4; Thu, 14 Oct 2021 12:10:54 +0200
Date:   Thu, 14 Oct 2021 12:10:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, bluca@debian.org, haliu@redhat.com
Subject: Re: [PATCH iproute2 v5 7/7] configure: add the --libdir option
Message-ID: <20211014101053.GJ1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        haliu@redhat.com
References: <cover.1634199240.git.aclaudi@redhat.com>
 <62f6968cc2647685a0ef8074687ecf12c8c1f3c0.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62f6968cc2647685a0ef8074687ecf12c8c1f3c0.1634199240.git.aclaudi@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On Thu, Oct 14, 2021 at 10:50:55AM +0200, Andrea Claudi wrote:
[...]
> diff --git a/Makefile b/Makefile
> index 5eddd504..f6214534 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Top level Makefile for iproute2
>  
> +-include config.mk
> +

Assuming config.mk may be missing (as dash-prefix is used).

>  ifeq ("$(origin V)", "command line")
>  VERBOSE = $(V)
>  endif
> @@ -13,7 +15,6 @@ MAKEFLAGS += --no-print-directory
>  endif
>  
>  PREFIX?=/usr
> -LIBDIR?=$(PREFIX)/lib

Dropping this leads to trouble if config.mk is missing or didn't define
it. Can't you just leave it in place? Usually config.mk would override
it anyway, no?

Rest of the series looks great, thanks a lot for spending the extra
cycles giving it the mirror finish it has now. :)

Cheers, Phil
