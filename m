Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7747F6C5
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 13:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhLZMku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 07:40:50 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43753 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233403AbhLZMku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 07:40:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 36B083200E31;
        Sun, 26 Dec 2021 07:40:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 26 Dec 2021 07:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=z+JceY
        vdfvR0RgDE6hmjJ8LFe6rnbhZ3zsFhnZhJrTQ=; b=ga6uRauX6dP4zDSJZTSwWR
        Z3v0klwRqI4NRbjk5iYlysHoOboqRWyoEsDowdxDSZ/mr8CYpD38eYY58KHuhPYn
        5TsY4rmDIgYmPx3P9T+/Czd5S00JkQqvM/peXAj8N0ntn+m/07QjpsiNTQ+nDITS
        olKjFO3nMbrtwwQyUMtluLiq1slGZn3Ir82Dtcj0fCDd98sONo8hZ1t86gpRkUYf
        LpSn1N71OY7Bw7UBYmMY1mniQg1XQVSQ0hMap60LuqEN8ZCVL1cV+psb6pIN7Eo7
        yN41Fkeb2/Hy6Fh33drU46SMPBm888eSx2kPEFtPM5A1IU3WojDmTcaLhNelB+7Q
        ==
X-ME-Sender: <xms:0GLIYeK7LqYobwZL8DatTY_hODcBY2-iwqgYH_pUs8pRhbFc2H9lnA>
    <xme:0GLIYWInATf_PlUZUBM7wz3vUDzZG4MvPKkOUVoeoeUXIUf-6hVx69aBIwG8s8orh
    AIsuhgVrt7ag8I>
X-ME-Received: <xmr:0GLIYesomLbb1wsN-YHMj-yGAS3Ef7VluQ-sUW1mh9DzOVm3r2Kpr-LZunj1QhC6v_7piAcBpW1ioG0CFgzzc5rGV0MTNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddugedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0GLIYTb6EzvG05JHTKBOH-ZAbsLIfezXRiLJdgsjx03AzRypC6btfA>
    <xmx:0GLIYVbRWdRTMyDQ9DGdpQHNA6XApJxC_tvTd1cJeYYZlcl-nmAhbg>
    <xmx:0GLIYfABgCwlkjXIE04Ravwd2nsjOFlImM8fJmtR7R3AjsYub-ED4A>
    <xmx:0GLIYZG1DHtDJMfFRrUacOIZcKaa-bSkChGCmgMwoD6APQJnVelA3Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Dec 2021 07:40:47 -0500 (EST)
Date:   Sun, 26 Dec 2021 14:40:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
Message-ID: <Ychiyd0AgeLspEvP@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be>
 <YcYJD2trOaoc5y7Z@shredder>
 <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 12:47:51PM +0100, Justin Iurman wrote:
> On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
> > Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
> > seems that queue depth needs to take into account the size of the
> > enqueued packets, not only their number.
> 
> The quoted paragraph contains the following sentence:
> 
>    "The queue depth is expressed as the current amount of memory
>     buffers used by the queue"
> 
> So my understanding is that we need their number, not their size.

It also says "a packet could consume one or more memory buffers,
depending on its size". If, for example, you define tc-red limit as 1M,
then it makes a lot of difference if the 1,000 packets you have in the
queue are 9,000 bytes in size or 64 bytes.

> 
> > Did you check what other IOAM implementations (SW/HW) report for queue
> > depth? I would assume that they report bytes.
> 
> Unfortunately, IOAM is quite new, and so IOAM implementations don't
> grow on trees. The Linux kernel implementation is one of the first,
> except for VPP and IOS (Cisco) which did not implement the queue
> depth data field.

At least on Mellanox/Nvidia switches, queue depth (not necessarily for
IOAM) is always reported in bytes. I have a colleague who authored a few
IOAM IETF drafts, I will ask for his input on this and share.
