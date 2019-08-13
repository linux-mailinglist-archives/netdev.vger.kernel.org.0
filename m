Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727E98AC1E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfHMAnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:43:05 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:39895 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfHMAnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:43:05 -0400
Received: by mail-ed1-f42.google.com with SMTP id e16so12172062edv.6;
        Mon, 12 Aug 2019 17:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=o6t6FqBYVqnLLllbUNCZj5Tf6QnbJNhZyMYRoftP8l0=;
        b=fuNZybKF6mAIvCzeTazqIU4c6p7SNRQmtm4QmVAfPYzOVtbE9zvdtuCqHf3Sq84TPA
         8kqfTec8Oiclke0WpW0mb0/6bAvTqf4MgZ/kSUuWmUX6wHmxznpQIjJMhGo3CwhvHXae
         Vc++4as1F++Ujtzh8deNRA8IIipuUGWcNLGElc3yiSlKNf8BR0HHG5toz44OIuhQDgUd
         baRyR8M9hYkabTrEzpTEZ/EqM8GalvmIdbPcpMCML0QX93AkZ/H5I9pU8ZynalytQZ5h
         Pk7dN/YmbiYcWiKGwMyMRuUDpC4ASu93ynQF567pt5+j5CkrPPdkt24B47WjTEF+NsgX
         m/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=o6t6FqBYVqnLLllbUNCZj5Tf6QnbJNhZyMYRoftP8l0=;
        b=Ebr4yQ3I5sxrV2waOepGqOS/tQ8szXY7sPgRomuz6TASa6CEC5aqepPhMRp9hlj0AE
         ObEIxOnqIPHmr3aJw6swVzgoR7DlegbzqbmWBG9rP70hHfSG5v26BN4FmgUCbhLSOKxv
         MI1GQv9M8Ym4i5uGB0DvLZDOaGp6f0NANVWqHm/xMj/JeIna115hKWxvmCH94qBez+jo
         voSyE+ufD1lCu3DYWLadJRbhEiBCQhlGswv/SbccUzmTHATO05wjuYi8qYaq3KzinMXw
         Ex9vv2q4BiQ870El/ueppLsyLNyNAdAH+G04YxCRX06iQh/haJAwazdop/8gyTOzS/LG
         hhkQ==
X-Gm-Message-State: APjAAAWbRDS/Irudd5GC3Z2Ek11aUow/1q/txI9n/8wPxhMQBBttjp9h
        Y45mD8uQJiiSd4wwYk4yP2WxCxgIZh47JQr70iDT2gQ6t5s=
X-Google-Smtp-Source: APXvYqxfJWqIxZF0nElIiuBKf7I9Bt1XmPgprpxcCH+lWECSjhQtefsY3/LVjDc860ovI9L7S5hiuMaUME6LilOjAqg=
X-Received: by 2002:a17:906:4ed8:: with SMTP id i24mr1341883ejv.312.1565656983444;
 Mon, 12 Aug 2019 17:43:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:2001:0:0:0:0 with HTTP; Mon, 12 Aug 2019 17:43:02
 -0700 (PDT)
In-Reply-To: <f7de98001849bc98a0a084d2ffc369f4d9772d52.camel@sipsolutions.net>
References: <CABVa4NgWMkJuyB1P5fwQEYHwqBRiySE+fGQpMKt8zbp+xJ8+rw@mail.gmail.com>
 <CABVa4NhutjvHPbyaxNeVpJjf-RMJdwEX-Yjk4bkqLC1DN3oXPA@mail.gmail.com> <f7de98001849bc98a0a084d2ffc369f4d9772d52.camel@sipsolutions.net>
From:   James Nylen <jnylen@gmail.com>
Date:   Tue, 13 Aug 2019 00:43:02 +0000
Message-ID: <CABVa4Nga1vyvyWNpTTJLa44rZo8wu4-bE=mXX1nZgvzktbSq6A@mail.gmail.com>
Subject: Re: [PATCH] `iwlist scan` fails with many networks available
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>I suppose we could consider applying a workaround like this if it has a
>condition checking that the buffer passed in is the maximum possible
>buffer (65535 bytes, due to iw_point::length being u16)

This is what the latest patch does (attached to my email from
yesterday / https://lkml.org/lkml/2019/8/10/452 ).

If you'd like to apply it, I'm happy to make any needed revisions.
Otherwise I'm going to have to keep patching my kernels for this
issue, unfortunately I don't have the time to try to get wicd to
migrate to a better solution.

On 8/11/19, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2019-08-11 at 02:08 +0000, James Nylen wrote:
>> In 5.x it's still possible for `ieee80211_scan_results` (`iwlist
>> scan`) to fail when too many wireless networks are available.  This
>> code path is used by `wicd`.
>>
>> Previously: https://lkml.org/lkml/2017/4/2/192
>
> This has been known for probably a decade or longer. I don't know why
> 'wicd' still insists on using wext, unless it's no longer maintained at
> all. nl80211 doesn't have this problem at all, and I think gives more
> details about the networks found too.
>
>> I've been applying this updated patch to my own kernels since 2017 with
>> no issues.  I am sure it is not the ideal way to solve this problem, but
>> I'm making my fix available in case it helps others.
>
> I don't think silently dropping data is a good solution.
>
> I suppose we could consider applying a workaround like this if it has a
> condition checking that the buffer passed in is the maximum possible
> buffer (65535 bytes, due to iw_point::length being u16), but below that
> -E2BIG serves well-written implementations as an indicator that they
> need to retry with a bigger buffer.
>
>> Please advise on next steps or if this is a dead end.
>
> I think wireless extensions are in fact a dead end and all software
> (even 'wicd', which seems to be the lone holdout) should migrate to
> nl80211 instead.
>
> johannes
>
>
