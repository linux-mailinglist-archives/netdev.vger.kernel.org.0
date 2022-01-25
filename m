Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE249B655
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiAYOex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:34:53 -0500
Received: from elvis.franken.de ([193.175.24.41]:39453 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1578308AbiAYOUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 09:20:17 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nCMg9-0001mq-00; Tue, 25 Jan 2022 15:20:13 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 87595C10D8; Tue, 25 Jan 2022 15:20:02 +0100 (CET)
Date:   Tue, 25 Jan 2022 15:20:02 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        "Tobin C. Harding" <me@tobin.cc>, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.17-rc1
Message-ID: <20220125142002.GA26778@alpha.franken.de>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 08:55:40AM +0100, Geert Uytterhoeven wrote:
> >  + /kisskb/src/lib/test_printf.c: error: "PTR" redefined [-Werror]:  => 247:0, 247
> >  + /kisskb/src/sound/pci/ca0106/ca0106.h: error: "PTR" redefined [-Werror]:  => 62, 62:0
> 
> mips-gcc8/mips-allmodconfig
> mipsel/mips-allmodconfig

fixing patch sent.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
