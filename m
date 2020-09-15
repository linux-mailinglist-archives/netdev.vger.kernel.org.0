Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6568326AEE7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgIOUvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgIOUtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:49:50 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2BC06174A;
        Tue, 15 Sep 2020 13:49:42 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id k13so1125692oor.2;
        Tue, 15 Sep 2020 13:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npbAlOQH4fp/qA72XjZiB29LRy6oKwDgsRkYJHjairY=;
        b=r4OgvBkDGe0LFJcimKQuTJVk7vZkikBjSnue/GC/q4TgxNS9RPkIFhENcOWYWhtIzv
         8n5in08IPIZVzgzOZo1gMtmMGGp74iceRsMkdgGGpLPpQkV6xndBc/P7DDpGRPj3jXCj
         zJI2x79/XGHOfCHk5DPNq6e0taLOJGDX1Sx6aeTB3l9IQ0Psbs3Yir5yXcVAtwwwA+nG
         wS0dG3LEyuz/QJu/k9CGWtVhWK3aDvfMn8rEbM1nuQCJGxNvUNSBlWnvT/tvUVGQOMh/
         T0tKcMF8k+ffYuA0pP/3pgEsuToGd24Wzm9efa3RWLNYkd3GD9HmGZkINmkfVCOGYgVJ
         JEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npbAlOQH4fp/qA72XjZiB29LRy6oKwDgsRkYJHjairY=;
        b=aX0VGD9nhaOKnubQreBTHiiowqBt0Sxor3TgRbqjMAb8pHtrmi+2E5/wB3XNetnoUU
         qzQ8ZCMKXBUl8t+7rIFMXkLnrVxMJ177YQFFVFRpljCC8QwNOqpxpWF31UGFXTytNXQ0
         hYuh+fL40ETl/rCBmQjQebuqa0+2H2Eex5V4q0mzRf2vuQnZuuxYfPVxs1Vgl9jTXHB1
         zG5KBdsT/3jaA/dbvVB0/8DrZWy6sjj4a77vffmpSAyqoQEtl+I0+uzDNokgdGEf1Y8/
         /g9oIS0cgRti1VIwRfS6sehYFslQIz06skg4ZsLXwHMd6l2P7xlNd6u3OePG1rJX9nfA
         pwxA==
X-Gm-Message-State: AOAM532lAHPtDDJTsgPc54pUConD6Ws1w7wItcMa8LH08BggZVDjn7gs
        IxZ0/TnkUl6g7UKrblcOfh4zTWvK4d8NgNaR+P8=
X-Google-Smtp-Source: ABdhPJzWhuyZzcHauiMX4CaJks2BuzudJklG0MrZObs9vp+FG9p1LGFXDn9JamG8q3al1rKxC4s+Lo+SP/k7yrH2bnU=
X-Received: by 2002:a4a:d509:: with SMTP id m9mr15693308oos.77.1600202981428;
 Tue, 15 Sep 2020 13:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915.134252.1280841239760138359.davem@davemloft.net>
In-Reply-To: <20200915.134252.1280841239760138359.davem@davemloft.net>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Tue, 15 Sep 2020 23:49:12 +0300
Message-ID: <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     David Miller <davem@davemloft.net>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
>
> From: Oded Gabbay <oded.gabbay@gmail.com>
> Date: Tue, 15 Sep 2020 20:10:08 +0300
>
> > This is the second version of the patch-set to upstream the GAUDI NIC code
> > into the habanalabs driver.
> >
> > The only modification from v2 is in the ethtool patch (patch 12). Details
> > are in that patch's commit message.
> >
> > Link to v2 cover letter:
> > https://lkml.org/lkml/2020/9/12/201
>
> I agree with Jakub, this driver definitely can't go-in as it is currently
> structured and designed.
Why is that ?
Can you please point to the things that bother you or not working correctly?
I can't really fix the driver if I don't know what's wrong.

In addition, please read my reply to Jakub with the explanation of why
we designed this driver as is.

And because of the RDMA'ness of it, the RDMA
> folks have to be CC:'d and have a chance to review this.
As I said to Jakub, the driver doesn't use the RDMA infrastructure in
the kernel and we can't connect to it due to the lack of H/W support
we have
Therefore, I don't see why we need to CC linux-rdma.
I understood why Greg asked me to CC you because we do connect to the
netdev and standard eth infrastructure, but regarding the RDMA, it's
not really the same.

Thanks,
Oded
