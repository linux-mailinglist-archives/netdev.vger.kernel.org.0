Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35D14FA22
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBATPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:15:18 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:38669 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBATPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 14:15:18 -0500
Received: by mail-io1-f65.google.com with SMTP id s24so12160228iog.5;
        Sat, 01 Feb 2020 11:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ABSzJZF2QYR/ALyZkNAl85pSM5jELEdL6aovxi8L7cE=;
        b=tiX5hS+X+OIb6PO1/fhdQqhPLTr2LlITGfcVmBT4xzT9/q7rjMUzcKBJsqP2f4vpkU
         8Ce8N70yUizJwJQmZhmbYL0Ip63US/v5mI9LAwXz5jibH57eDHUOgRTtiXbh4K+NcANC
         6RiQ6GQlv1jZ4Uj+g1K6Hb3gBLrVtMa8lsHicbmVenpWagPv7bYiHlpfP37+8BAonfrM
         7xrb5gHnUfMOyA9z6Ee9mXhG9XWBKmar0dfRElM7q6ZQ4JjXtM7cibnx0P1x/tS+v/6O
         1XgYSSG+2dlkHG3mW5hrl/hU8M4i4WTPmzT0LkdStpTYSR9k6VG4JyrJil5BQnBrYkBX
         qqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABSzJZF2QYR/ALyZkNAl85pSM5jELEdL6aovxi8L7cE=;
        b=EeVU12hQ/S20cylP/A92Fu7Sm1rD0WtQHhD3ak5643T1n0PVJauu8jLdpLAbl05YKy
         bozZXuXAcb40tqz9D/19uqZGPmTi5nDnBXyCSRp5+UZQhcY3mvL1OaZsXyXZJqlEQ6c6
         yyqEnQ4ONrfj/hq5PU4R9dqJpxGUWDDUpC9r1Y6u/Y85DimbS5up6lCb3IVPwiEjTmcD
         jYUDZtYGOlm0xjV6eaiQ83Q6m4jyN+JrtMFxRaE/gcbJMjxxmKTS3tucA/VB7FHhhTeE
         sTmoxQ3gza0cVCHY5y1fflpsOG/DhoSRA2igCtVNjJAnlHvklYjf2VKYpBiWZagE2zFK
         Plug==
X-Gm-Message-State: APjAAAWFXEVRGk07usGKozEOXh89KS9rsW3QAYOaiqsFRNahY1jqnIoS
        erbaDdaATCAipfeNl4ofdg+Kfc7fsO0ed8ntQoo=
X-Google-Smtp-Source: APXvYqzYHRKWvt/fN5SVGoaSRf3+7IkzXvcaXyETfYFLOAYzaZSIIdHFjJVSkspqA2OJohkrU9ggTqMpqru8uvsfiGc=
X-Received: by 2002:a5e:860f:: with SMTP id z15mr12605068ioj.64.1580584517329;
 Sat, 01 Feb 2020 11:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com> <08d88848280f93c171e4003027644a35740a8e8e.camel@perches.com>
In-Reply-To: <08d88848280f93c171e4003027644a35740a8e8e.camel@perches.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Sat, 1 Feb 2020 20:15:06 +0100
Message-ID: <CAKXUXMyToKuJf_kGXWjP1pu33XbiMD4kpBcqUhJu==-OBQ8TQQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
To:     Joe Perches <joe@perches.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 7:43 PM Joe Perches <joe@perches.com> wrote:
>
> Perhaps this is a defect in the small script as
> get_maintainer does already show the directory and
> files as being maintained.
>
> ie: get_maintainer.pl does this:
>
>                 ##if pattern is a directory and it lacks a trailing slash, add one
>                 if ((-d $value)) {
>                     $value =~ s@([^/])$@$1/@;
>                 }
>

True. My script did not implement that logic; I will add that to my
script as well.
Fortunately, that is not the major case of issues I have found and
they might need some improvements.

Lukas
