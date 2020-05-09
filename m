Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45A21CC4B7
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgEIV3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgEIV3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:29:10 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3DC05BD09
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 14:29:08 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id n11so4852332ilj.4
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 14:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/r+mneobwGheJFxkeH99ObM6GjbUjQh3TKRKScwkSHE=;
        b=DS//8w5QxBS9p8LFqc/CK79rczOOiOteVXP3u/qUQUV8Kn8BNjE+ioWkGw03RGIgHy
         7vzzHd0sx1H1Fd/Iij56UWvjV8zVOhU2KjcqnMpk/RhLhJD/Khy9qfWhSgHcjLu9P2yG
         GvIsSkI7hXb0keuWDGLWhD/15WqJYhXQ7IbO8YtGLzdpuIgu4dbqriH9yaXwjvPW89Cf
         vu7jHisinXwQpHGQSUHF8kZY345vq5EMvIYUluC3GSkNgom3VpKwoSG6SxQVDfqLOnWl
         1sEAR6x8Wvo1EDoSGfvgyCgL0VtMXaxjLL/FPYYS8J64aXOJCjssE3NXI7A/MJWFEhSY
         IEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/r+mneobwGheJFxkeH99ObM6GjbUjQh3TKRKScwkSHE=;
        b=eDGT/pytMsLBsk5nugrhK5R+Tgs0akjM2sakLsT6M0gHhhKF41hxuJujC7rvLCDnh2
         ES7/Q1aRsWO/oAdPnw6xugwf3Xl9jwo3x4GaRnvj/ItUwohV+ObuR36EN8jHgtJGgJNa
         7uxqRN1NEeCAoVW4hrwIrc5aCz1GvRuK0+fH+Cirpmiz/rtzbzRloubTu01MY9CqZfC/
         1yM0geHKKZwnWNM0gWnGB9ulvfh5qZF1h4ea9HOhOo+aTByV+MLDf96yTAyzBK9+exw4
         RHsoWzdxk3yrWhEq7s0dvVWUNN66VrXZCznhrpZAnOCE/FSEpEHgw/BWJzWTtOK0H1gs
         tFGw==
X-Gm-Message-State: AGi0PuaCqUJ/U+Dx/KvVdqj+wX0iwk+P5L6rlkp1F4l9hDZX09+IvgoK
        sh5l3bKEShubwEhFk1ywl7C0U/gKOnYBJyVc2GczXg==
X-Google-Smtp-Source: APiQypKup595uKk5SGg8Thg2wE/gnspaYFn9WOvzGSPAYkzwqUoy16ANh2vBrhqbQc9918q9bfTzwrMZOkIq0FsD3OQ=
X-Received: by 2002:a05:6e02:4c4:: with SMTP id f4mr6158424ils.278.1589059747871;
 Sat, 09 May 2020 14:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
 <20200509211744.8363-1-jengelh@inai.de>
In-Reply-To: <20200509211744.8363-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 14:28:55 -0700
Message-ID: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
Subject: Re: [PATCH] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I *think* that your talk of 3 packets is not needed, ie. the initial
delayed packet doesn't have to be a retransmission.
It can be the first copy of that segment that gets massively delayed
and arrives late and causes problems,
by virtue of arriving after the retransmission already caused the
connection to move on.

Other than that this does seem perhaps a bit cleared than what I wrote.
