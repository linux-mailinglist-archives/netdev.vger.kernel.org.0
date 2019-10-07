Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D477CEEDF
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfJGWK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:10:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43991 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:10:56 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so14265352qke.10;
        Mon, 07 Oct 2019 15:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UmmMkARY04d9XY3TYypdw/NFG1BZczL71RqDIyTgZqg=;
        b=d306NMf6P2xtII25djqA4Sxsznn/8mNkoeRYxXSv4GBsdt3g4QrB8ydwprWCbMMYBd
         EiuK0e0fz08AdMDn9DukrORlhT/4JGTn/eenQ2VL1hG6HQGxXa+DJzmJR33+eq0Z4tIi
         1ebmaHG6iNC/IzsnoUbgGRdciSDf4g9p2OKjA3b+0ILf5QpF//oK1JoN8/9iRluhQbgt
         AMMeg7/DdtyxmOpSiRynbQ9nt5+hFIYbRxNagyROoQQvMRCyh13mH1VhUEam0Cl4O73P
         n5cIeKqAVlo2anASga97xlNg9xDBR2hEbLjvOZjaIbByOOZawzMvGn1lhAMGZzOJrrp8
         g0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UmmMkARY04d9XY3TYypdw/NFG1BZczL71RqDIyTgZqg=;
        b=UMRmm0UIGXfYxBJ8XiR/MLvBOHwMVol1dPUasDRqbIJF/4CvKy1RhsrdnFByC9B7xM
         87Xg86vHVo0WPEilBVVsv7UXxHIaxVIVge/UnaYEg4VuzsxFWsoN2CocRcH/XanJvn/4
         lv+DwqGF3Qy5qQG7g0GT2SXRvmBc5kqw41Ja9bhg09sR3xPju/IrnyIw5QslF+zUr0zC
         8LCg3UVGKmxtfR0TWfyUe87NJwb4B6F/II18niGv6wgdJZdfZdttjK13P3VHmrfrXZ6+
         HTHzPV0FdOcUcA0tzJb6lXINCegfFVbh0DPgQnEyZbPLOqDBApFO5adt4WhqOu6ZQg5O
         6A6g==
X-Gm-Message-State: APjAAAXm0CWg4KAkoOZCj5tU55TU68pIcxk1KKVtthqQ4LFzDnC6I7jI
        8lhDZhZgAf2Uj/09vnpGZzJCICjc+amj7duj99+1iG0X
X-Google-Smtp-Source: APXvYqxcwVk2QD+4V/KmoNVifDQIC6iSzWKaWmcVArAAdPNKvF83yXuxwTB9Q9vbG7PkCww8+B+hvVIfvQtjG9VKMRM=
X-Received: by 2002:ae9:d616:: with SMTP id r22mr24025661qkk.203.1570486255099;
 Mon, 07 Oct 2019 15:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191007082636.14686-1-anton.ivanov@cambridgegreys.com>
In-Reply-To: <20191007082636.14686-1-anton.ivanov@cambridgegreys.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 7 Oct 2019 15:10:44 -0700
Message-ID: <CAPhsuW7WqwVcTgpHhh8NOpBbeXz9QJganBVTV38Udg1jQdSBJA@mail.gmail.com>
Subject: Re: [PATCH] samples: Trivial - fix spelling mistake in usage
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 1:51 AM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Acked-by: Song Liu <songliubraving@fb.com>

For future patches, please specify "PATCH bpf-next" or "PATCH bpf" in
the subject line. This
one I guess goes to bpf-next.

Thanks,
Song
