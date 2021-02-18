Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5147A31F09D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhBRT6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhBRT4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:56:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A9260238;
        Thu, 18 Feb 2021 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613678115;
        bh=oGsSE+76wvfx4Nguhyl57l1C40S6Roq7FT74S76ZX3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3jvY6awlpjUR2knNqGRq/0lFPTJ56DCEvwXeuxvIyhDlYtbwaAHsgpkfCjbCp8Sj
         3tGMRcjHoe+pY316qprOQb1a7Hb/qRcKBj1lIMMNUB9qkaYyIfXOg0k6Na0I3cxWJE
         AsnAo8XujvgZyCU8blZUbzX/1x9Hb21cpg+Ag+pDHd9mSkrvtHmRhxq6pnxKiDzxWp
         ugMWNprObdSbkqmQbihl6bnNRHxYhg++fbUwblL2rM126nDG+Sw/v/9XYUANvHPh+2
         LMk8a1ZjCUQBjWWc7UmkJ3lcHjwbpOlu0QQI0TCIrrvFIHKUjozvn4tjh7yWodyH8s
         783xhFY6j2FJA==
Date:   Thu, 18 Feb 2021 21:55:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YC7GHgYfGmL2wVRR@unreal>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
 <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal>
 <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 09:36:54AM -0800, Xie He wrote:
> On Thu, Feb 18, 2021 at 2:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > It is not me who didn't explain, it is you who didn't want to write clear
> > comment that describes the headroom size without need of "3 - 1".
>
> Why do I need to write unnecessary comments when "3 - 1" and the
> current comment already explains everything?

This is how we write code, we use defines instead of constant numbers,
comments to describe tricky parts and assign already preprocessed result.

There is nothing I can do If you don't like or don't want to use Linux kernel
style.

Thanks
