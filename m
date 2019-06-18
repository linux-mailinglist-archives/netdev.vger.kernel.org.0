Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209BD4AA87
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 21:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfFRTAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:00:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41267 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfFRTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 15:00:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so2495183pls.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eT7kK3k/DGGgofaFnIiFVb/h7MwsbABIk+ml7U8rfOc=;
        b=WAeGOWzC/62xUfoOrp0D84mE+4Ea8G0metTMnVChRZviACt9qPPNHjs9o73B9l8F6c
         q6gSNwFiLPrUgA6t9NsiTiBumEFKBf7i4nt7MhMIMRf32S9puHYXkIdiEjo9G5pMDTU0
         WTJO7Ezk4+qiiuAm7pMPdk4iBrwJ9gQgv95T+2qdiZxPiI2Pv6+uJD0ge3vfqLYJkM9A
         7w13l7IwtRIMisZFZKyoM9pvHuCDu/+uaOxTNoKs+/P6itZ3Gu6/HM6f7YWKR95PtfGC
         cFDJtaqEeq4GXHpw5+YweZjxLEinwiR/k+jvTsfeCb7/w50msmE+6y8h77qr9X4Dsb9f
         ltZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eT7kK3k/DGGgofaFnIiFVb/h7MwsbABIk+ml7U8rfOc=;
        b=QBuI1/J9CCJPU13Ck/3POZziOCYLaMnH07TLRTMx0ouZh7IhHWAcEHc4ycqrfT6D4Y
         i69HUlVXck2p5ExKqo1TsJrpdrZc5AmujiUeN/3qoLcDtzR99d234z8iQPUd0P3CQHjG
         ITjihpV3sJ++h6QdX2sVW1U/9ydtMYURYHh5eHifmUl7Enhh1Ydawq2dcieHsT+5Yu0U
         SvdHudk6Ulkxx3avD7QgH/882H278JVRylIHRoQl+0xroB6m7eFjxx1QNNOGai4QVRO7
         ZabF31w4LqH8jTWYaOQINl5s6/LnURFYsUtG0NcxPLvnF6SZgLxrsBtxrkeDP/s8to4r
         1teQ==
X-Gm-Message-State: APjAAAWNQunrr4l6GuaUF8AcGiy4KuJnCHtYLxtpiDo6eBQIrAXorpVj
        uhoN5ov1kdQh7dIOz6pOTvTH4JO0vGz7WadmBjrbkw==
X-Google-Smtp-Source: APXvYqxtkgfrCMyVOFWD+nhtS1s2hx+NJljuwLvz8oM33DKsEoji2grMTvg4SptxAw7eGcQq4jI4lrottWmX2QHp9Ds=
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr112133301pls.179.1560884411214;
 Tue, 18 Jun 2019 12:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190618083900.78eb88bd@bootlin.com> <20190618160910.62922-1-nhuck@google.com>
In-Reply-To: <20190618160910.62922-1-nhuck@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 18 Jun 2019 12:00:00 -0700
Message-ID: <CAKwvOdnoMv_Fkq02=F+RM8fRi0i4ycUxPe+VLdjHcDvy2DKo-A@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: cls: Add pmap to fs dump
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 9:09 AM 'Nathan Huckleberry' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
> Added a usage consistent with other fops to dump pmap
> to userspace.
>
> Cc: clang-built-linux@googlegroups.com
> Link: https://github.com/ClangBuiltLinux/linux/issues/529
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Looks good to me based on Maxime's suggestion.  Thanks for seeking
clarification and following up on the feedback.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Nathan, you should use Suggested-by tags (liberally, IMO) when your
patch is based on feedback from others, in this case:
Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> index 0ee39ea47b6b..55947bc63cfd 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> @@ -566,6 +566,9 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
>         debugfs_create_file("hits", 0444, prs_entry_dir, entry,
>                             &mvpp2_dbgfs_prs_hits_fops);
>
> +       ddebugfs_create_file("pmap", 0444, prs_entry_dir, entry,
> +                            &mvpp2_dbgfs_prs_pmap_fops);
> +

-- 
Thanks,
~Nick Desaulniers
