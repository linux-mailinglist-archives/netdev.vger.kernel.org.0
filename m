Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644B3283FDF
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgJETtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:49:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgJETtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:49:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kPWTx-000GYT-76; Mon, 05 Oct 2020 21:49:13 +0200
Date:   Mon, 5 Oct 2020 21:49:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
Message-ID: <20201005194913.GC56634@lunn.ch>
References: <20201001011232.4050282-1-andrew@lunn.ch>
 <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch>
 <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry, to be more specific about my concern; I like the idea of
> exporting the W=* flags, then selectively applying them via
> subdir-ccflags-y.  I don't like the idea of supporting W=1 as defined
> at a precise point in time via multiple date specific symbols.  If
> someone adds something to W=1, then they should need to ensure subdirs
> build warning-free, so I don't think you need to "snapshot" W=1 based
> on what it looked like on 20200930.

Hi Nick

That then contradicts what Masahiro Yamada said to the first version i
posted:

https://www.spinics.net/lists/netdev/msg685284.html
> With this patch series applied, where should we add -Wfoo-bar?
> Adding it to W=1 would emit warnings under drivers/net/ since W=1 is
> now the default for the net subsystem.

The idea with the date stamps was to allow new warnings to be added to
W=1 without them immediately causing warnings on normal builds. You
are saying that whoever adds a new warning to W=1 needs to cleanup the
tree which is already W=1 clean? That might have the side effect that
no more warnings are added to W=1 :-(

   Andrew
