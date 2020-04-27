Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD81B98AF
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgD0HcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:32:19 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40248 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0HcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 03:32:16 -0400
Received: by mail-ot1-f66.google.com with SMTP id i27so24569802ota.7;
        Mon, 27 Apr 2020 00:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKq5bHj+gJcCq0DWbIGl/RMpJOtD7oFM2RAdMfG2Tfo=;
        b=oUFTfi3vmqA0evbUtRFQyaphUxyO5GSVb7cA6lqsq78epJjbQqQWox9Zm95LqA6LiL
         sfuj0GZY2RhxAyRQQ9NOFL/a50T6s3f30lNU8hMc6CKbNnEaj8j23JBGLd7iq/zOP0tB
         ekSgZlBpSwUWnQZBmMJDyWLgvUpxeNEhFfAjvICTvJ280NjGBj90sA3Qud/cA1jiYDgk
         1HwhW3ldLy2wQF3qi5mMEw2hw9oFZuWAjXEIVr2jk9fLsA5CxwN9W67JFElYZ9Y4FRf6
         r1QjwI2uZL1cgwD1XBZpFmaGCfooY02vp5RJuKZrbeaQ+jaiue7v/P+j9ahAK6UriqZ0
         kNiw==
X-Gm-Message-State: AGi0PubBT2NvkgI6Jj+8qK5nlH497Lum2mXwB1oFAnCWx4Dzyc5ssEUg
        CiKAVUauvU37IK8iqDgR+NLo9HxiHe03CaYFPvqroA==
X-Google-Smtp-Source: APiQypL3QcioqYTKFP1r0tIlSEbZTrYK0QqoozWyux1wj9AxMj3fQJ8ERZUNF1oqGnQfOSsv3Uwoffs1NgBG3rQNc6c=
X-Received: by 2002:aca:d50f:: with SMTP id m15mr15054400oig.54.1587972735523;
 Mon, 27 Apr 2020 00:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Apr 2020 09:32:04 +0200
Message-ID: <CAMuHMdXm=Dcmj3j_W3hqWzHDnnMQvfALiuDsxFw6crZujHPWSg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: sh_eth: Sort compatible string in increasing
 number of the SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:38 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Sort the items in the compatible string list in increasing number of SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
