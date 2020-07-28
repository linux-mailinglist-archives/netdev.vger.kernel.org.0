Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21D82311DA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbgG1Sjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgG1Sju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:39:50 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0201C061794;
        Tue, 28 Jul 2020 11:39:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id x69so19708126qkb.1;
        Tue, 28 Jul 2020 11:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o/6uYiVxRBLvjte5hmpYmxTDf5OttB8/QGuV4Pd34jo=;
        b=fr1oZSmqgpJ66N54EakcrzBJsqjtB/2fD7rV9bpszyORd74/XLLk6ivv2oYXStoLgd
         gInLJ0KuJ9EAYf9ztO4qj2+xiPFU/sMSqL9vwFdDsTy1iDIYAsxUGt9sou0vIxgYeLT3
         JFvJ7VOSW5k1iRvc3yMbhYUm6nbL+G8Ai22u7In0qIp5QUVsDHLychjT8VGHwM0U0I0D
         PVTcJczdrSHK+hcCzZBOlUGQRWHe4wPVHcJCqWJu/1FIjkXhRExAtGbAdQeg/uqpM2tw
         3i/Z6y95WwwZv24kPyQupdkbN9WXQ/qfNuRm+4P9Kc+Fo5+etn7tUTdel8xlyZsEHDXw
         yxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o/6uYiVxRBLvjte5hmpYmxTDf5OttB8/QGuV4Pd34jo=;
        b=eqtowweEYwtQglbTNjJZKbd53R01+afPHQBVVo24K5J86x+isbPyHFb77aOv+ypwcj
         +/0YHmv/Ch6mkRg9f9C61UYQsilbGACzPlL5yhxZhoyYD/gpHIqUsRXtgIVUZ5yg3bge
         8U6IgRh6dcGQHIZcUjndyGfU2leDs7zyy2MvU/0JFd3xTyne6LstDrDlVkcrvWJ3fLdc
         3g2kVRmaZx6ymTYDdOnz3VTCjFv88EOLztCaWYNCpd4gzMLqvMT5FoF1OFXryiG8SnIS
         8IZgjD0Fai90t0TfQbvpf8wu7FqOcOncYaB0MyYSSY/+c/gcFjX/oqwQF6QAbeczg6fx
         7sRg==
X-Gm-Message-State: AOAM5337gg8JjG0nLMeI9MwFH7/AkhxMpDDjPOPp/SrL80iqxEhPwsPQ
        JqddppIMKYrPhVW00JR3vjOY74NiRQDEbV3vCS0=
X-Google-Smtp-Source: ABdhPJyQHKEUOb6+EWdritYo3lOBBI95gbgh2RWPyhg12odwGf2RbbQI/ffowW7yx/gmdzcd182heR+Yn2/IDEHsG+E=
X-Received: by 2002:a37:afc3:: with SMTP id y186mr10251973qke.36.1595961590033;
 Tue, 28 Jul 2020 11:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
In-Reply-To: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 11:39:39 -0700
Message-ID: <CAEf4BzYVb1NY=GxBCqTWS1e7_+pbOXg3GsM+JXsGNZS30MGyQQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf, selftests: use ::1 for localhost in tcp_server.py
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 7:40 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Using localhost requires the host to have a /etc/hosts file with that
> specific line in it. By default my dev box did not, they used
> ip6-localhost, so the test was failing. To fix remove the need for any
> /etc/hosts and use ::1.
>
> I could just add the line, but this seems easier.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Makes sense.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/testing/selftests/bpf/tcp_client.py |    2 +-
>  tools/testing/selftests/bpf/tcp_server.py |    2 +-
>  tools/testing/selftests/bpf/test_netcnt.c |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>

[...]
