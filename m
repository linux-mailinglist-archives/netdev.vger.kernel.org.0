Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE82FEF00
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbhAUPgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733034AbhAUPeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:34:07 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56DC06178A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:32:50 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id h11so4690533ioh.11
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 07:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CH3/T/1qbA8QvWLg/IGGjMWgJS/A9i8IB8381eT87w4=;
        b=TCtJnv2QO+nzK17RsN5WisQ4z6WG1NWku9Syf4DfSqLd7B1qSfMBLSNp5Wy+QzKZKi
         ShtY6woNtqVacWPi2vEdsgZHS1P9RiJm0EmitKzPIWXkADNi1O6ZulUaPgwZF2dFsc2R
         yagg9pvIIkOP7FBL4Q5l5F7HY7WoTRFcO2FI9Hm0AWAA0SWSqBUaY3JiYkbnlubLCxF2
         6FG7hfnDER1dhsfk0gt8068t6xwEpNcms/lrSYeG0+BIHIBh3RnVrvAvn80mQOVHe0Xe
         BdBxiXGaII0vPTp3CgjafFVkpIUTRS1EbFJIZztnD+xCwP6zfRgPyyLGxY9IPzZQRNQl
         8olg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CH3/T/1qbA8QvWLg/IGGjMWgJS/A9i8IB8381eT87w4=;
        b=JSJPnHm7dx19rq4BBnJ4qMjcu9/ImDiKhQ4tTQVbtxieVu/QgiiJtYq+83eGwAtn65
         oY7bu7vrTtLg9rHlwGo0pizm67r/cqNOElel81pwcRx7q0/UFXxymKf6ZkqKy2hW0ywZ
         h/Drir/H8UJRpLjP8RerSavzYspu7OQ9Co/1ToEtT5Yka7SH2LQODwrxC2i8jH/tH/uo
         uKPjkWIk1bipHynXrk6xMgB34vlDByXPVi3SZTxx2jC3AlU02eBDt3L5dvCbkE7sPFAc
         sZITDydiw7znciKNdWGrTLyqoN+6O3D52xfBekx3Yl7r45de2wzMKJEgAA26NMCcWWYi
         wYMg==
X-Gm-Message-State: AOAM531GgtY2ZthJx284jOS9kqK936hCqU2B76gBJvf3wbRwW6Y98HD5
        w2a5HhVK7MiNQcqfE6idTjkLl5qNo/VVaqQv4Z22Gg==
X-Google-Smtp-Source: ABdhPJwi0OM0/YeNwpEv+GtSEdNUotwqNR596rm7rYsm8bNn5F24g31B2FbGAW9Ina/RJCOzVq2lIkgoDo3AMGMm0Og=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr208132ili.205.1611243169795;
 Thu, 21 Jan 2021 07:32:49 -0800 (PST)
MIME-Version: 1.0
References: <1611239473-27304-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611239473-27304-1-git-send-email-yangpc@wangsu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Jan 2021 16:32:36 +0100
Message-ID: <CANn89iLbOqbJKMbC5UWiBSuuK1vQ-tzGj9fTWrL7hqdK7qGogg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: remove unused ICSK_TIME_EARLY_RETRANS
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 3:32 PM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Since the early retransmit has been removed by
> commit bec41a11dd3d ("tcp: remove early retransmit"),
> we also remove the unused ICSK_TIME_EARLY_RETRANS macro.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---


SGTM, thanks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
