Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89224196A8F
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 04:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgC2CD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 22:03:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46494 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgC2CD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 22:03:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id r7so6536530ljg.13
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 19:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u03hiLa6D6J07QDhydnufhNxwBtzijqVkMSzsbsgPcg=;
        b=as2skpujRBiJhR1RMukMPT2675gVAHBZWsQSLw9qUJMJpNQG0uIleCXAEq/ODLAvkn
         uXxbuTLQ5gmiQp9q9wpNSDladZo5zBu5miiIRmq8L7C/DkS+ij3f4UJpqpX4OMDQKEqw
         N8TiJk/pxJnaU+01UPLSpcIKLKQqxGW9b2h/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u03hiLa6D6J07QDhydnufhNxwBtzijqVkMSzsbsgPcg=;
        b=nzfhpPcnqGUTMgNP443eLE2+txJxa+s8PKUA7YP7AOI1VQWy68UL9ld2T0htr5W9Pt
         qLiCi9jgvFbKy4ub9S4ASaOVFcfFBae6i1mxmL9CTqvP3friOiQAtG6jE0cep/N0rE/+
         t0g6ruKNG03L/iaQsv17xd34fevsoyj7x5KZ2+6a/ittCIU1Clq8GLvmPQyFqyhj0768
         4wl/GreFUqWRmtNqj5fnhNmBwyW8sRUi7+Rn5jzvcLoS81BOuaMnD0tGWF61uTQV3VLV
         e+Qabc3ZHUpIEvzh5qaj7l8ZZATqeTF94tgIkQvQCgEDxd+nWHhYO+tUbIGSFgk9CDRw
         YQqw==
X-Gm-Message-State: AGi0Pua2FeSQiNrtM9/jy0Da9zwpuZrHuklBsizGhGMBmpeM4FNgAmuU
        G74zLASlUicQpexIslZEdqlA55QZp6k=
X-Google-Smtp-Source: APiQypJ1FIJ4baNrB8fTDonPN0ZMkVtpMvY4gYy1RPYdKd/gK9tdaOANc9IIKXWpA8GMvQkcZp4vhA==
X-Received: by 2002:a2e:9b8e:: with SMTP id z14mr3531585lji.150.1585447403660;
        Sat, 28 Mar 2020 19:03:23 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id q1sm2217939lfc.92.2020.03.28.19.03.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Mar 2020 19:03:22 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id t17so14196366ljc.12
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 19:03:22 -0700 (PDT)
X-Received: by 2002:a05:651c:50e:: with SMTP id o14mr3401881ljp.241.1585447401666;
 Sat, 28 Mar 2020 19:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200328.183923.1567579026552407300.davem@davemloft.net>
In-Reply-To: <20200328.183923.1567579026552407300.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 28 Mar 2020 19:03:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgoySgT5q9L5E-Bwm_Lsn3w-bzL2SBji51WF8z4bk4SEQ@mail.gmail.com>
Message-ID: <CAHk-=wgoySgT5q9L5E-Bwm_Lsn3w-bzL2SBji51WF8z4bk4SEQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 6:39 PM David Miller <davem@davemloft.net> wrote:
>
> 1) Fix memory leak in vti6, from Torsten Hilbrich.
>
> 2) Fix double free in xfrm_policy_timer, from YueHaibing.
>
> 3) NL80211_ATTR_CHANNEL_WIDTH attribute is put with wrong type,
>    from Johannes Berg.
>
> 4) Wrong allocation failure check in qlcnic driver, from Xu Wang.
>
> 5) Get ks8851-ml IO operations right, for real this time, from
>    Marek Vasut.

Btw, your pull request information really leaves something to be desired.

You seem to have randomly picked one thing from each thing you merged
(eg that memory leak case from the merge from Steffen Klassert).

Hmm?

            Linus
