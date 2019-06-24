Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629FA5109A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfFXPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:34:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34826 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXPe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:34:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so14959441qto.2;
        Mon, 24 Jun 2019 08:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=37HHlnX0ko661Qr3W/bCbUQhiUoBQ5T0GwRisjYLBng=;
        b=oV0HwOyaHayzF6PBaHFlgw+N6No5kTP1fBxa77bbHlQGzE+nH7bPAbQYUI6z+bs1iT
         Be+AL0Nin3i52pE63mdC2/jBOZ3ssy/ACra3grOQf7o0tOB/ugNp5/FMo0ih2aMKfl94
         GYKe8MA28Odamxuq2JX/UA7tREMwBpdbnWbRywm4bb8sQTJIC6V/Uip+yu6SqiMzP8lM
         VqK8fmKE2WWT9w9Psu2dA86cWB/14GVovN/oFMg0lxGa47M9B6BngwYcJ2Vy90bl6eJ1
         USm//Nv/Hd0HMIcS7T+7twimC3Y1OZEhp/6xWoIGbNT99PTZNBHpRdaqIh/qxUoIPkOZ
         S9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=37HHlnX0ko661Qr3W/bCbUQhiUoBQ5T0GwRisjYLBng=;
        b=UqzZnlIKtZwAx6hfiWm1n35wQWPEEx+wZDYF439pdYnu+ZfQhf2KZHhYdHRs5Tjk12
         xNo7j+Bl+ylnK49g2TTaO8dD7+6yAzbu9WUpCFxeoYdlezEcZjQJj0HMj6JrzkvnK9Ld
         go+74rOaj+0gaGmHrIPtrrMZbVUkDCT8iF9imFpWZtJW7jE0tzHlwsGz+NDVFSJLPe8z
         Py/rGrMDaknlWlp/ARDLrrA19NF/3nIfK00zP0JZPbNTZf46wZ2ez7sv2peys17eSOdg
         SdPTC72cNa+s5FzQ8Fj7EDnSpu5mqXvS820v7n47BopclPjGLmOQQEGfOin1qQ6PH3rC
         XXlg==
X-Gm-Message-State: APjAAAUetPwCWibYNG6VpbTDmBMzRb9I9LhRL6l/cMnGiEvzc60HMF4N
        qudJHR89Ir+lIN4t2hKvikoO2rDmDReEI+5J9/s=
X-Google-Smtp-Source: APXvYqw/3/UIpGtVW/kZ8Xai0idQYgzr6oTVOpXmvjRsBnHwXljdY01SuGYRuFPT1cAEQx6bTwqOPg8ncrLu8IEryZo=
X-Received: by 2002:ac8:2f07:: with SMTP id j7mr118902221qta.359.1561390466338;
 Mon, 24 Jun 2019 08:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-12-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-12-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 17:34:15 +0200
Message-ID: <CAJ+HfNiSs1jGzqg0E4f8=8EMCTMpAWs6-33m7o9Gw_8L-5v-TQ@mail.gmail.com>
Subject: Re: [PATCH 11/11] doc/af_xdp: include unaligned chunk case
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> The addition of unaligned chunks mode, the documentation needs to be
> updated to indicate that the incoming addr to the fill ring will only be
> masked if the user application is run in the aligned chunk mode. This pat=
ch
> also adds a line to explicitly indicate that the incoming addr will not b=
e
> masked if running the user application in the unaligned chunk mode.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  Documentation/networking/af_xdp.rst | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networki=
ng/af_xdp.rst
> index e14d7d40fc75..16fbc68cac50 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -153,10 +153,12 @@ an example, if the UMEM is 64k and each chunk is 4k=
, then the UMEM has
>
>  Frames passed to the kernel are used for the ingress path (RX rings).
>
> -The user application produces UMEM addrs to this ring. Note that the
> -kernel will mask the incoming addr. E.g. for a chunk size of 2k, the
> -log2(2048) LSB of the addr will be masked off, meaning that 2048, 2050
> -and 3000 refers to the same chunk.
> +The user application produces UMEM addrs to this ring. Note that, if
> +running the application with aligned chunk mode, the kernel will mask
> +the incoming addr.  E.g. for a chunk size of 2k, the log2(2048) LSB of
> +the addr will be masked off, meaning that 2048, 2050 and 3000 refers
> +to the same chunk. If the user application is run in the unaligned
> +chunks mode, then the incoming addr will be left untouched.
>
>
>  UMEM Completion Ring
> --
> 2.17.1
>
