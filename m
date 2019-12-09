Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59647116D51
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 13:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfLIMwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 07:52:18 -0500
Received: from mail.toke.dk ([45.145.95.4]:40043 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfLIMwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 07:52:18 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2019 07:52:17 EST
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1575895421; bh=G2z7odAkzR9JBaN8/WVO3+Ty2ThT2Yl0JDnr6Qd9/3I=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=tTOFyL+4Uq96ckD58Ao7++kcXavR49vsruUVidd1AWa3B3mMrusmA/Kf2sj7T0VLR
         MIB45bx893aJpl0rlU5nLL5wBCBIwd0wdM5P5ErLaWpIsvYZIbQrkrASKx96weO14U
         BPscEF/vpdc9oe59QoywhtTGzio9Oc9Z3pbleWloCfHO65opuYFzUtaYJRdzKv2UIu
         WLajaFfafKyzptp9t8JseIDFMp7ioWTKKYCyykaNXcNJ/zLb9/b/FbahlEyHMtkGJs
         mPyo/YftS7nKcsxfyFdCsuKO2VJ0rj39JWPgWiza2p0sRVOsrmcm2wFn67okvLw6eJ
         pMpIq6zN8wN2w==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: organization of wireguard linux kernel repos moving forward
In-Reply-To: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
References: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
Date:   Mon, 09 Dec 2019 13:43:41 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87d0cxlldu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> 2) wireguard-tools.git will have the userspace utilities and scripts,
> such as wg(8) and wg-quick(8), and be easily packageable by distros.
> This repo won't be live until we get a bit closer to the 5.6 release,
> but when it is live, it will live at:
> https://git.zx2c4.com/wireguard-tools/ [currently 404s]
> https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-tools.git/
> [currently 404s]

Any plans for integrating this further with iproute2? One could imagine
either teaching 'ip' about the wireguard-specific config (keys etc), or
even just moving the 'wg' binary wholesale into iproute2?

-Toke
