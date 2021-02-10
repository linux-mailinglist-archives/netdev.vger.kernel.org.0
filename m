Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3623170EC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhBJUM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:12:57 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52957 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhBJUM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:12:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D70C5C0176;
        Wed, 10 Feb 2021 15:11:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Feb 2021 15:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TCvk1D
        VzxkB8tOylH3eLjOK480dvbLYysyOrUZmi1FA=; b=OYaIwpuNHalNU1YddeY+p1
        xLi5grGQ+Lmg7nUeW0DOa2d+dZidGM4MrXyd4+795/5bFW/AhmWIGSslCl4hsrwT
        M7yKHJVTvhjMf36caKKFJ7vjw4eTEATTHkkYkDYbzJITDy3mLdCtc8bLh53sl2XF
        saeTi4Z6266dxKkIWEmSrpaEGOVijKe+/9gprunBkWvZj+dOYwuWOPFNkJs0LKXC
        ulymNYzp1LRYGdNGTiQKCmmbjr6Av20Nk+0+OVo2mP59CRcBUU450LC5uZ+gIxaT
        WhZJNd2kLBGUgRjadlmumBYfPddnDKMCv1j0uegpdG80ra7BYKBsdsmhCbG3yOow
        ==
X-ME-Sender: <xms:BT4kYBZMawS8TZFEwTrTAeUR3qBD81LGwkccnxROVAGYzaFSgRXCcw>
    <xme:BT4kYIZFScjQxW46reFJpDoBZqAvIOazsp7MguEc_bg2TBfmPaPCj62rL9iM0c44z
    ZD6P1rolphGKhc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheejgddufeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeekgedrvddvledrudehfe
    drgeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BT4kYD9WkV6k7Vh9WCxj-ij_9HamfFsah7HHKM8L3_bhnh-ld-agIQ>
    <xmx:BT4kYPq-VUDmN3LPreWoDlk6ATYGLg7A6gVIFOA8LWh_zdWuup4rmw>
    <xmx:BT4kYMqw0oTfH5mTZdxpfqKApEc2a4V0scNrJgxgHPeYwr8nYj4POw>
    <xmx:Bj4kYNfiO1sCYd3XE62DX2InTZFd2XQ9I29rISJlZUKpeBgjfe64hg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CAE01080063;
        Wed, 10 Feb 2021 15:11:49 -0500 (EST)
Date:   Wed, 10 Feb 2021 22:11:45 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Netdev <netdev@vger.kernel.org>, roopa@nvidia.com,
        idosch@nvidia.com, Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] bonding: 3ad: Use a more verbose warning
 for unknown speeds
Message-ID: <20210210201145.GA316147@shredder.lan>
References: <20210209103209.482770-1-razor@blackwall.org>
 <20210209103209.482770-4-razor@blackwall.org>
 <CAKgT0UcZzdo2PBMW-hG6XAwjjFgJpYP8815KV_PQUKpx-8iXjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcZzdo2PBMW-hG6XAwjjFgJpYP8815KV_PQUKpx-8iXjw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:44:31AM -0800, Alexander Duyck wrote:
> I'm not really sure making the warning consume more text is really
> going to solve the problem. I was actually much happier with just the
> first error as I don't need a stack trace. Just having the line is
> enough information for me to search and find the cause for the issue.
> Adding a backtrace is just overkill.
> 
> If we really think this is something that is important maybe we should
> move this up to an error instead of a warning. For example why not
> make this use pr_err_once, instead of pr_warn_once? It should make it
> more likely to be highlighted in the system log.

Yea, I expected this comment.

We are currently looking for patterns such as 'BUG', 'WARNING', 'BUG
kmalloc', 'UBSAN' etc in regression. Mostly based on what syzkaller is
doing [1] (which we are also running). We can instead promote this
warning to pr_err_once() and start looking at errors as well. It might
uncover more issues / false positives.

[1] https://github.com/google/syzkaller/blob/42b90a7c596c2b7d8f8d034dff7d8c635631de5a/pkg/report/linux.go#L952
