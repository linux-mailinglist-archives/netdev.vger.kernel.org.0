Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA02FF0BF0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfKFCQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:16:06 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:33621 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbfKFCQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:16:05 -0500
Received: by mail-qv1-f68.google.com with SMTP id x14so805218qvu.0;
        Tue, 05 Nov 2019 18:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDoO+eB44INg+B2f3uq2drUntvKmeUffBr0EsVZjjH8=;
        b=Hh3mLsTCi1UBf7abDc4KvKiu7DaFrsNXTwwxWV/2ttGgeUN/tiPFt//rRFfS36T84o
         KwEKeEb+0LAzP70QNwcPEoazEKvYtezPSCcF/GfCzisWpONUw7i2w0T9y6ZDhmpn89gE
         uSmvFvJi2rg+sdLIU2ApnOQoe3yUpzFkIlBdOe49qSykDkxfrbLOZLiC5Ov2tj5L+n4n
         CCcJ7L7DwmZw4ezDgEzZ+LH3WE+hggR3O9EhIDZiRVRJ+Yw0phKAFiCsBFYbxcsVbj7l
         dT1oEdbcZYysIYbLX0ZU3fgDA+ULe8Mo/JzlDADUroo65PpvT3C519nNOs3GgntzlACc
         jVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDoO+eB44INg+B2f3uq2drUntvKmeUffBr0EsVZjjH8=;
        b=HJr+Qe4zSsoSwRe+QgvXbH4rRFawEjHKO+SdxvD8/0rCspAfcC1vhURRb+kDQOPRb0
         ohn6ZwGcnklMWnrIjRnzztergKA/3Sx1riD9AlP8RAeDz3qu7XLEmQuSnGttkvri38hR
         AQr38KvN1RSUtpqE2EjlpRg4zrsEXmf2Tq7G7PgSU2u/XhTP1SLKCKrCDo7Wcw4Rv7Yd
         ETWx+AQE1/inrVsVC4LrnqeXJE0UNuAlWd87aVXi/Q/ymChgXpbo36BWTVPZDixFukhu
         MiEYJ2bk2fwJRQvNFbZimWaRlIvRY+9/Obr8z+t7H44RgfGjC3ddORHHbzuBUamW7QR4
         x+6Q==
X-Gm-Message-State: APjAAAX3IU3NW2bR2rkdlct3+0jfyYs8e4KbK6LccPqfSh0YykjmsuuW
        JLQ13bfmOb9gTb+C0fVBZUydO8p3aw+vb95CCCw=
X-Google-Smtp-Source: APXvYqzusm2hJYGA8uYmrBdi/16zMNPXYwyX35OHGv3rpFIKRs5Ng6/QvYFB5dcwFA4fa/2vUINAwth52FhSoUew6Ec=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr208068qvb.224.1573006564529;
 Tue, 05 Nov 2019 18:16:04 -0800 (PST)
MIME-Version: 1.0
References: <20191105225111.4940-1-danieltimlee@gmail.com> <20191105225111.4940-2-danieltimlee@gmail.com>
In-Reply-To: <20191105225111.4940-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 18:15:53 -0800
Message-ID: <CAEf4BzYreS_bAOKZMsCpxh1sCbJbaVY3DmmmPUUwkYgNK4wjKQ@mail.gmail.com>
Subject: Re: [PATCH,bpf-next 1/2] samples: bpf: update outdated error message
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 2:51 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, under samples, several methods are being used to load bpf
> program.
>
> Since using libbpf is preferred solution, lots of previously used
> 'load_bpf_file' from bpf_load are replaced with 'bpf_prog_load_xattr'
> from libbpf.
>
> But some of the error messages still show up as 'load_bpf_file' instead
> of 'bpf_prog_load_xattr'.
>
> This commit fixes outdated errror messages under samples and fixes some
> code style issues.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
