Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14621327A3B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 10:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhCAI6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:58:42 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59331 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233614AbhCAIz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:55:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9C836580221;
        Mon,  1 Mar 2021 03:54:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 Mar 2021 03:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2wvNQI
        WBpBOZWpWbefbd33FSrA5QpP7DmdH/BxqyZQE=; b=nve+oeJBo2TDkIH/qMAahu
        QSly78fe6d9N7PH1CzszhHH2vdxjGw6EMkIII9WJPhanmPpuqpfVgI4/Uz7iyxpY
        rXTffOVZxkqTkN4GXLR4n81li451mocOmn7QtkRsUMziY6GTfcyDrLt2NnzKqDgq
        qMHzxvMT6ew+4T5kJ75BuH2M5HfiiI8cGoeoSt4JpL/aoRXHwcFsrpHgnSdsQMm0
        dgXHPnIm4bM08GzxZSPLtoiCqhW8NXKVuylAz72q7iRVQXp2JRSVl50sXT8vCxI+
        kxkBBH8/99L3pqnYt3RxRQHlDJHkhIcN4dIRx7lMBDex/CerNPsThav6vyRuXP0Q
        ==
X-ME-Sender: <xms:zKs8YEHC2wXN5ZRCbSeNIye4UN6JQO1z2li1bV3he1BqaphSJAQM3w>
    <xme:zKs8YBkRKQIsyVh6mJnVXVKCUeOCpDcWmuuxl7ejRme_0Rd1dJsiuf_XdDKTO9wbU
    11mHpMvdh65GIU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleejgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:zKs8YJKqjwOdEj7Dkkg0t1GLl1U5eypDAPZTgZ38TADIZ0P_9GFWOg>
    <xmx:zKs8YKbVAYHma4UbKk2rfNR-kpoz1Or260y8OgWIF6qQGnJ-Rkw2qg>
    <xmx:zKs8YDa7VlXZg-bRpWaaC26PewimtSJXzDiA4YM6qsS01YKQWoEsQw>
    <xmx:zas8YEiuDtDMWLYQMX3IpUOQXDef9IY3KhjhRdDkFgFtok12_yinhg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7403B24005E;
        Mon,  1 Mar 2021 03:54:36 -0500 (EST)
Date:   Mon, 1 Mar 2021 10:54:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, vgupta@synopsys.com,
        linux-snps-arc@lists.infradead.org, jiri@nvidia.com,
        idosch@nvidia.com, netdev@vger.kernel.org, Jason@zx2c4.com,
        mchehab@kernel.org
Subject: Re: [PATCH 10/11] pragma once: delete few backslashes
Message-ID: <YDyryN/GOj9JXFm+@shredder.lan>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
 <YDvNSg9OPv7JqfRS@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDvNSg9OPv7JqfRS@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 08:05:14PM +0300, Alexey Dobriyan wrote:
> From 251ca5673886b5bb0a42004944290b9d2b267a4a Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Fri, 19 Feb 2021 13:37:24 +0300
> Subject: [PATCH 10/11] pragma once: delete few backslashes
> 
> Some macros contain one backslash too many and end up being the last
> macro in a header file. When #pragma once conversion script truncates
> the last #endif and whitespace before it, such backslash triggers
> a warning about "OMG file ends up in a backslash-newline".
> 
> Needless to say I don't want to handle another case in my script,
> so delete useless backslashes instead.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

For mlxsw:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
