Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3E30B3E3
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhBBAKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBBAJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:09:58 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B21C061573;
        Mon,  1 Feb 2021 16:09:18 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id w124so20893056oia.6;
        Mon, 01 Feb 2021 16:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0TE9ujTMtpgmXpTEN32smn/Hrl3w8ROl+2N6JMyyprc=;
        b=cqUxBx9gLwZ1ga3Z8feLdyW9JR+TYznPB/yYPEbFEMfbTQb8nmxBkIAOqUmXt1Vq4F
         muiUveGAHgUZrZueBk1Y6cg38qjQm/xNIsHfVToqmwurDMa3r3D8O4ZD7nd6UiOS1/Ec
         d+uU1rC1LxErrYbb0J7nMPYr21b1tscfBjoV2crG7p1BT0lDqw1ch3N0YiiMynkBlN9j
         1mHNEpluO9au6Oo6Dx+9MCmh3BHKIyp9jTLL4x/z4HJwp4aOT0OwpXLVKPFqxaBRy32m
         BZ/C2A0gdQZa3fcjUTOQB+79qJj0TLPDc90ktSHihbUl+saHZkqs4PCYAT6ZIdmbxX6g
         yyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0TE9ujTMtpgmXpTEN32smn/Hrl3w8ROl+2N6JMyyprc=;
        b=Mro1vi8kBcvJ4ptzCfFuE65BxO6YE5/1WryXdfQL7pLfFNtYLdh6ilwXlKHd25KHDF
         Q6iwuqYgqohhGsNbkCBLw+9syG/TB47Q9Jv745sCNGBMk5O83H7Q45tsw4spiXa3fO7Z
         Iud3UAgICjt9+CkQtHzOyaef+ZUdcp7WZ6ZswtkGukbTqxZ8aEo8/ltZ/46oX5sk+/sp
         Jjy/G9frDxsXg14iJWxUcMGwxiAbxbMw0K4TDsDIeheBvYptNbMInNv+783KE/GQPq/2
         O0AezT89vE5biuvbM6UXL4n+oek85vh6Eet8wXkrL8NKDXjHrMm0NLBmtUjYIEocXD/G
         Ulfg==
X-Gm-Message-State: AOAM5305nudcmIox/BrEoVD3PjuwxrhJHzy2Lgya0TDXOh3LUws4M1tQ
        iPTBy9PDe/cwP32ssh6J8nM4rD4mkdpP7Pz8ox4o7ZrLOCI=
X-Google-Smtp-Source: ABdhPJzbOjHKI2jQukZqVEU9VKOcIVl9F86oh8s52VIjTvipduBJyKeX3P5fNiznoHjjUqS5OaXGbTO7hhZImI+vlPU=
X-Received: by 2002:a05:6808:1290:: with SMTP id a16mr908421oiw.161.1612224558074;
 Mon, 01 Feb 2021 16:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20210201232609.3524451-1-elder@linaro.org> <20210201232609.3524451-2-elder@linaro.org>
In-Reply-To: <20210201232609.3524451-2-elder@linaro.org>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Mon, 1 Feb 2021 16:09:03 -0800
Message-ID: <CAE1WUT56=3hvwdDjdJP1yAOYM8P_wP2zEGwcV+NDx9ia7xWPAQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: ipa: add a missing __iomem attribute
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 3:29 PM Alex Elder <elder@linaro.org> wrote:
>
> The virt local variable in gsi_channel_state() does not have an
> __iomem attribute but should.  Fix this.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 14d9a791924bf..e2e77f09077a9 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -440,7 +440,7 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
>  static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
>  {
>         u32 channel_id = gsi_channel_id(channel);
> -       void *virt = channel->gsi->virt;
> +       void __iomem *virt = channel->gsi->virt;
>         u32 val;
>
>         val = ioread32(virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
> --
> 2.27.0
>

Seems pretty straightforward to me, ioread32 expects an
__iomem-annotated pointer.

Reviewed-by: Amy Parker <enbyamy@gmail.com>
