Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E141107A32
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKVVtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:49:02 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43714 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:49:02 -0500
Received: by mail-vs1-f66.google.com with SMTP id b16so5828266vso.10
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G62OPFVZIkBw55KC5/i/oEsvxB7myzhATw37jvrwcgc=;
        b=kmKi50nUtbizrYMKlVYwM7YMGAwXvfkyyo5Bm1BOfbzPF9NBHUXY35Ev8ubE0cF4cO
         QDSRLkR9+F50nai293m+QESDXbMNaePgcpDf8kVP7ntgb1oheHANKcBTh4fBrLK8t7gW
         LgvK1lmbXdSH8KbuuFYUd1509C/tqnQWu+gfmc5t/P9uROcCmnokh16BzuBFzVyTnn+O
         kOB+BCPnTppzXEF8Eg+d1HaY+5nqaf4HNblmhj/EPMe+0PNLl79uV4v3rOZqooYpwZO7
         SKubBMtdZJ25CzICx2DtGXmpAq9lPwjfORxkw257f5A/PAJ4+jvcTP5xKDMT7JkcAJdK
         QFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G62OPFVZIkBw55KC5/i/oEsvxB7myzhATw37jvrwcgc=;
        b=U6A7ZwS9tWyRub5Umny0JktAGbgox/ccjxaseau8vUYST/N3lUe/ji/KEvgnvLIw1+
         o0sgKMw4aPUF/5gMl0s25+qg+njGFBG6UVE8mYFywfJzbHUnEDdAOvfIA0UxpGoaJZ54
         ELFJXQeH5kGdS4CL5Twf/RK/obCz3l2/k17cMbUXBvQXSias2Xp3RBkhdyeMnNu7M977
         1m/RGN7ODQCrwrdn4TAZLjJIumvv+TsIVncxyKET363UhIFCkFNyU7zCxM3CXKvBbeng
         +H6Z+dOEgpAcdhHLuSU0LXqad2hsCz0g7kIBtVsuFDnnCUNLL8whl21g9bCYKEHmkTRy
         PYEg==
X-Gm-Message-State: APjAAAVetrP/tRSF9mxPHJW2RLAO6CtuNRxsL5yVNBRBgyMlG/N2WtzP
        St2qkOz4LZAxLgx6bCKP+6PaML4QmtK3IohvwCQ3CQ==
X-Google-Smtp-Source: APXvYqzNnBQIPAg/ocMTNUo5QgZ4nq3hCTU3+CAWIlSCTCLSknSOApdpocEtL/woEuCkmrPosIy358RRow6UJs3y7io=
X-Received: by 2002:a67:e9d6:: with SMTP id q22mr12165017vso.231.1574459339332;
 Fri, 22 Nov 2019 13:48:59 -0800 (PST)
MIME-Version: 1.0
References: <20191122072102.248636-1-zenczykowski@gmail.com> <20191122.100657.2043691592550032738.davem@davemloft.net>
In-Reply-To: <20191122.100657.2043691592550032738.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 22 Nov 2019 13:48:49 -0800
Message-ID: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: inet_is_local_reserved_port() should return bool
 not int
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Maciej, please repost this series with a proper introduction "[PATCH 0/3]" posting
> so that I know what this series does at a high level, how it is doing it, and why
> it is doing it that way.

That's because the first two patches were standalone refactors,
and only the third - one line - patch had a dependency on the 2nd.

> That also gives me a single email to reply to when I apply your series instead of
> having to respond to each and every one, which is more work, and error prone for
> me.
