Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A451A3089
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 09:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgDIH5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 03:57:05 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33373 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgDIH5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 03:57:05 -0400
Received: by mail-ot1-f68.google.com with SMTP id 103so3207676otv.0;
        Thu, 09 Apr 2020 00:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0f4UuAAx4hIuJKySyghpF7OzUKmbFLmG9H4TAp0Cki8=;
        b=PzGAaOsKoJoGE+f6Yt3GL0AjuWLFopHdb7shNN88k4QgMtvu2BChzkn5Py+BC6dW99
         rVoNUitCrLN0pBAEJW325K4d7vmuqoI3a3OL1H4mQTawZH1UroKJSb2Tt26n/ogsnjFz
         fOJhLFm11J9ItMM1AYNWOFIz6im8anbAQx8jg7tCtAA70IPg2uOn9N+2UWnPdnTuaaNB
         5dOaWZMtxUvpAOMNaO26vJ00PeBuZBIBLC++fGSn2WLfuyt+wGvQvu4SCI6FhDuQ2A5f
         rgwH888mogLMfqNg+G9hu9W3r+Pyh8ZDbOQIoRuzU8caVPJzUovMSTYTNO6F9J9hCGn5
         UTIQ==
X-Gm-Message-State: AGi0PuZK53ABn7ep3KHpzD/Y8Yl5zIlx/T8sg1T9TrSH9H1+E7OLnF4j
        OClaQjwC9+v3pgJeNzGJ9G3XZZCljo03qZSPKzs=
X-Google-Smtp-Source: APiQypKtonrSbAC4hFuRltdRVj7wsaGlVvb0sciuoyNeIcBJRyYXuZxSmXG/HQm41ZUqfxCBbhnCmk6QPP+LpIAFifw=
X-Received: by 2002:a05:6830:1e0e:: with SMTP id s14mr1804617otr.107.1586419025363;
 Thu, 09 Apr 2020 00:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1586359676.git.mchehab+huawei@kernel.org> <402922bc26fe9b340dff8693bab57142820f1fc7.1586359676.git.mchehab+huawei@kernel.org>
In-Reply-To: <402922bc26fe9b340dff8693bab57142820f1fc7.1586359676.git.mchehab+huawei@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 9 Apr 2020 09:56:53 +0200
Message-ID: <CAMuHMdX7b0uhXwzRByx3vtdbOEwUCQ0bYsZxu78b_ADUdwTEnA@mail.gmail.com>
Subject: Re: [PATCH 30/35] docs: dt: fix a broken reference for a file
 converted to json
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 5:46 PM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
> Changeset 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> moved a binding to json and updated the links. Yet, one link
> was forgotten.
>
> Update this one too.
>
> Fixes: 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Yeah, Rob dropped that change from my patch to avoid a merge conflict.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
