Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773CEC9111
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfJBSqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:46:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35793 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBSqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:46:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id m15so45834qtq.2;
        Wed, 02 Oct 2019 11:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q9D4dosTml0l227Zzgv4rTTlL2Je0VeBGCcoUbz32Xk=;
        b=lPO14QscMrkEWS8YmQjhQBWB3VluXmncO15YTQcvVORnb+/HUq1NSLM2cUkZm0Yfn9
         glCYPS//BCxiDQY9AGIHCzNYyz0HpZ22dcintX4FsAxVdWPj2KsPxNpuxk/G4xX4Gzxm
         eJ9Z0x5CNEcGPI9yBqXKziFhYVILRV8DG5gZ6n7FydmqkJ35dQ4R721e/ML2MpvUltMT
         aqoQ41nTR+6swbN+eidSK1qcK+AQc/aRwAwEJv+5nd5kePr6es09GJZh/u/TP73taTGJ
         mtUDyjfpbBEUJeuACLFj94ohK8w8KMaMBRSF3MLrrevNVwGhLUZ1ICHJQsg/JgeUaeVG
         0xUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q9D4dosTml0l227Zzgv4rTTlL2Je0VeBGCcoUbz32Xk=;
        b=QbPUd6LGeIUVwBvpRPEjVnSCCFkma885DTgMlGfEUpSfVoH2RNdNZZXb4Yphbyrq4l
         VntVZSve/GaJagK1Rt7ZGAZqZrtCTbB38h7YUuXE9NZQSJz3kMJQuOZpXC7RljEZ3I/0
         tAflgUEWDQCHkPkvDvJ3v37hlBO1/O8Gy4kfNPzO3ZdziySsZsoJdhOKojsO43cQpcUg
         rbMhwpKiUJJl4ALyYQIU/WqjXExQzZQ7s6savTKrHIYLi8krfzBtybQ8jfF012Pe8HxU
         M+tkRYfz6xChOtY52Iq4YcYklVcy3MH32wtAK+WzlB03hevFjaxacUf0UKmaK93tNhB5
         Q7wg==
X-Gm-Message-State: APjAAAU8RDGRh8SWxZ2JSPfcleeeJWTDoYY5ZNFPWblOPpQ5eSrfybWg
        xMXqDrvL5ihDEA4EF7amjD5y9YQQ6xYtkL9gAbg=
X-Google-Smtp-Source: APXvYqyOpiYjmr+7vXul/WFcnIgMDgO0DSV67S33cFDfGXPdgQMk69fduc6J8NU8dtEi5YWwxtfwQ++7p8qknGZE/z4=
X-Received: by 2002:ac8:1099:: with SMTP id a25mr5670508qtj.308.1570042008317;
 Wed, 02 Oct 2019 11:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191001112249.27341-1-bjorn.topel@gmail.com>
In-Reply-To: <20191001112249.27341-1-bjorn.topel@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 2 Oct 2019 11:46:37 -0700
Message-ID: <CAPhsuW5c9v0OnU4g+eYkPjBCuNMjC_69pFhzr=nTfDMAy4bK6w@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: fix build for task_fd_query_user.c
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 4:26 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add missing "linux/perf_event.h" include file.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
