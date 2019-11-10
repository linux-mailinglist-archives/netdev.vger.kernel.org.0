Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BFF6AD2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKJSfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:35:38 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35155 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKJSfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:35:38 -0500
Received: by mail-qt1-f193.google.com with SMTP id n4so8601983qte.2;
        Sun, 10 Nov 2019 10:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAi4MHvKoC/qoYpWGaKycEF7gNGDDWdJ5Bg+6jdpebo=;
        b=phawDoK5z0oL0Iq2xkCY/FL0A4wSVlHADg6Y4hpCGPkOBUkRv6luRZs9nQeW+EIfzB
         8yIfoWmrgjNxgF6fIkVdqFLSqRqUQu2qHkKV/Tz3uih6qfH5Sthh9b+lzu1rkg55itb3
         SXTizMg4dszm7u7RkglCGczEiSWt8KtSrGZYI+i/YgnLrSQ69j74BJisJ/5EM9tT5gcC
         VbmRyb/edoiYVVj+uUQXABLjrr2NH0trSioPI9gw3DBv6aKO03PH4sH/cwNNyx56ntcW
         GqjvO6a9je9c+roQoJipY0efYHYd48ucr3rU9gHEEaK3fVoNG9gErrbslZwdNmt+o9lL
         8ylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAi4MHvKoC/qoYpWGaKycEF7gNGDDWdJ5Bg+6jdpebo=;
        b=GXBJSwQY4YGlhZ1D7QH6jTUQ3fUPc5XuS25tUMppaKvAvRWniMk17n0+oJp0f0t72S
         0tAZFo0SMNB/wgGmeFH8qrSBpDVfKQzuE7z3Bke8W79OqdoWj/Gfni5CQIw/xuGv7ojY
         kK7gEUwyUfglnMxgpQhHFeTcUfkhTIi8todadEs7Azp6MiJNce3jw0JgocrVuiixZdsL
         5uoQJXdTRA0LNXqdoM+78BV0P6cJKPJXVZOgWtP5jBHAmCfy+70I2FAUDKRfpqn2YXnP
         bHSZyV8Ic3WIeFHjzYEGqhpzpnIFoZpCzWq6aZnXsjGumS/4RNstnq0Ne8P2Wtl3K07M
         WxEw==
X-Gm-Message-State: APjAAAV3wUHKAwyA8AVOjP5UzbJJDtLYGNwO1H85KDwszqXURECpju8t
        Otl98EmW4dWtyRoxt26R7PvhrfBlqwenpxIvH2Y=
X-Google-Smtp-Source: APXvYqyvWV1/poB/jX7CzhiUZJgVtlUIOdKPSs67gh5ROt63qorpCip+ejnDwG5HTZ/TiOa8er7Wz3jbhuBd5CKxbEQ=
X-Received: by 2002:ac8:6f4e:: with SMTP id n14mr22304934qtv.309.1573410937339;
 Sun, 10 Nov 2019 10:35:37 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-5-git-send-email-magnus.karlsson@intel.com> <FC0465CF-6F62-4FEF-88CF-B5496E9E4881@gmail.com>
In-Reply-To: <FC0465CF-6F62-4FEF-88CF-B5496E9E4881@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 10 Nov 2019 10:34:58 -0800
Message-ID: <CALDO+Sbo=ROFGGZO_CJxLxK3NHMCUQPRG3=Gfvx5zFW+P+_Rhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] samples/bpf: use Rx-only and Tx-only sockets
 in xdpsock
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 3:02 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:
>
> > Use Rx-only sockets for the rxdrop sample and Tx-only sockets for the
> > txpush sample in the xdpsock application. This so that we exercise and
> > show case these socket types too.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tested-by: William Tu <u9012063@gmail.com>
