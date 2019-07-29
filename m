Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9F79AB1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbfG2VL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:11:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35502 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387510AbfG2VL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:11:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so60963423qto.2;
        Mon, 29 Jul 2019 14:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAlu/DSDjqnny9LMOFVGSre2FoZw+C7NFbLKCDs4+UA=;
        b=qD87UbqvqKesvmQED70E+8asoZOaNuG7XJKbQaKN+mDlNiQ2Am/6CcVMFItsZCd/MX
         KUaEF6pm0oL4YmIkVcu+BUfzFMsFm8AcW5Ub74IKwW9+MYKqu40vQKk47aPAgqofKY2b
         qIJ3gIG27Rn56Ozb7dA15tDzrEHFo3KsRsrprvWYDn2bkMo+RFLDEA36ph1chNg5hDJr
         qkQ4iVfCpNcj77j2jqenchj7VkuAiIpBdXjlvGPg5uUmr0oyHzF12dmH9evNzdqZQRGJ
         bQ/nYnQWm0oo5s2sgoGDvjoivaPwWolZDaMhCtR0g/PYoImZ4KzeAK2jbGx6h4vu7pEC
         kVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAlu/DSDjqnny9LMOFVGSre2FoZw+C7NFbLKCDs4+UA=;
        b=e9pgoYA3DPI1Y1uC3o7dKrL7XdKbgIebvYc9Jt4Hq8KyqnOe1Cscw4HgZoJpbP4FLy
         VJu4PMquDe7uxTCnpejfQB8QMyPmEOmw5TZiCwbtlhaJeGJ0oDW+n4wUxUeun6w0NP/3
         KyTIW78NsiIE3fkTltw1jAsnJil+s2Qf2dkRuQtwZJfbhPuXMQAm9ZrUKXdEXoX7w0Ny
         SCsZSJ4cIfzQCR2nY0rhCzMvjMBcpkBWr2gPWZ+91awdroDEnek4lx3aah9MMUig187y
         HUsfTwx1n648aD2kvWUvlRVUznr+JqRbsJwT7wE7cOAq52VtP6w0tdicBskkj/Pv5AgX
         SfOQ==
X-Gm-Message-State: APjAAAWpDo5y7k83bskIw7Mm6DZNlYZrfyX9bbPDklIRPbtE3j6wDeiy
        gRVMkYDq7DoQWC7f7v8x8pVueKtxSjUfd6wdw1c=
X-Google-Smtp-Source: APXvYqxsDqAxf+hl9minXU65NE3q4KdN11fE8jQeWMjiawbJK7YStfpzo21VDKhRILwVN7tnpz/oa7z9PdsAcuuVOEM=
X-Received: by 2002:aed:38c2:: with SMTP id k60mr74433614qte.83.1564434716626;
 Mon, 29 Jul 2019 14:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-9-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-9-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 14:11:45 -0700
Message-ID: <CAPhsuW4N_XuuoOc+oJ49GJZizBtes8iQg8oTyoYxAC38WFN52w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/10] selftests/bpf: add CO-RE relocs
 modifiers/typedef tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:30 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add tests validating correct handling of various combinations of
> typedefs and const/volatile/restrict modifiers.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>


Acked-by: Song Liu <songliubraving@fb.com>
