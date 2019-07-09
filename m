Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4F63E44
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGIXKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 19:10:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35274 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGIXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 19:10:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so516023wrm.2;
        Tue, 09 Jul 2019 16:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mVzABAaLZPttRpLpfx8AbBdhRdMXPPyOU3lhjijb9ko=;
        b=NiQcOAkdF16fWhs2ZknhmulLdhJX0NZmCruIwDdoAvC3NBRiVPJTaTh+nOMoWo/isd
         qwiBFOjDyo09xwrogq8Gs3wt9jdpMn9MkdMxhuy7Z6GQqa4i4B6X3JYSAum2CxE5ttNG
         DYBQcWNuldMx5dDBVBDk4IEbgZQl5m2D1+doO0h0M6SrxEcnZk2Hs5i+H8/fjNu9Gxez
         Hu2LC5naSfghB1bT45yOOOjORj28vIQ4nHfxAIF5xfQiU8Uc+LDZacMifcRdjN2307VQ
         0PSWEFBBbG/MnTqTJM6D/9U4KI+n2VwNmJeVHq7vhQ5ylfE9GagvTHxfxIfwLO3ENd8N
         R8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mVzABAaLZPttRpLpfx8AbBdhRdMXPPyOU3lhjijb9ko=;
        b=SlPSRZ3fSMfYGPYUeyIBtrSiADIn0MbcX10fqgCmdRXkop3dOT1jEIwdiID8tfm358
         20ITgZhtSK/mb4mAGsORue9Bh3ef2sVexb7KTukZAQAVpCAtVznqFffJGVH3yaPsBZL/
         9H+JDktotRqYhjFu4Zd9disdoDfEGrU/ywB776dArYCxyOJ095lrbe7LjiVKSJespY2+
         iADFOYCWnVJ8T+uwN2DvhLZMHfmLqEEX//c/2BK6R1TSvrwjKesoVXrnIYlv+DnigVgK
         9Ye6Fgwy7bVIKOCHmmn1Pe5l7uqjN3HR4jV8PEjn63eoSToMb3u41YDh3FGv4xxuIYKz
         XA4g==
X-Gm-Message-State: APjAAAUhNnutirr8Jb37e5V64ge1LgQDSJ2bSXd6rznrwt+prVKHAIZx
        hccYuDHdcJhP5NuebxmOyAw=
X-Google-Smtp-Source: APXvYqzhURMOcsvp/8T5JJ5w1FsWX+QkKQXLR7zUXXu7AtvU6OJIVLFJDmoNYbWPZDgKxCEeFShKEQ==
X-Received: by 2002:adf:8bd1:: with SMTP id w17mr6901359wra.50.1562713826986;
        Tue, 09 Jul 2019 16:10:26 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id w7sm221876wrn.11.2019.07.09.16.10.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 16:10:26 -0700 (PDT)
Date:   Tue, 9 Jul 2019 16:10:24 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] net/mlx5e: Return in default case statement in
 tx_post_resync_params
Message-ID: <20190709231024.GA61953@archlinux-threadripper>
References: <20190708231154.89969-1-natechancellor@gmail.com>
 <CAKwvOdkYdNiKorJAKHZ7LTfk9eOpMqe6F4QSmJWQ=-YNuPAyrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkYdNiKorJAKHZ7LTfk9eOpMqe6F4QSmJWQ=-YNuPAyrw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:44:59PM -0700, Nick Desaulniers wrote:
> On Mon, Jul 8, 2019 at 4:13 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > clang warns:
> >
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
> > warning: variable 'rec_seq_sz' is used uninitialized whenever switch
> > default is taken [-Wsometimes-uninitialized]
> >         default:
> >         ^~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
> > uninitialized use occurs here
> >         skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
> >                                                     ^~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
> > initialize the variable 'rec_seq_sz' to silence this warning
> >         u16 rec_seq_sz;
> >                       ^
> >                        = 0
> > 1 warning generated.
> >
> > This case statement was clearly designed to be one that should not be
> > hit during runtime because of the WARN_ON statement so just return early
> > to prevent copying uninitialized memory up into rn_be.
> >
> > Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/590
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > index 3f5f4317a22b..5c08891806f0 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> > @@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
> >         }
> >         default:
> >                 WARN_ON(1);
> > +               return;
> >         }
> 
> hmm...a switch statement with a single case is a code smell.  How
> about a single conditional with early return?  Then the "meat" of the
> happy path doesn't need an additional level of indentation.
> -- 
> Thanks,
> ~Nick Desaulniers

I assume that the reason for this is there may be other cipher types
added in the future? I suppose the maintainers can give more clarity to
that.

Furthermore, if they want the switch statements to remain, it looks like
fill_static_params_ctx also returns in the default statement so it seems
like this is the right fix.

Cheers,
Nathan
