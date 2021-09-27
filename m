Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252FC41A402
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 01:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbhI1ABg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbhI1ABf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:01:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD78FC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:59:56 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so8875lfa.9
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Abbi1YDLI6HGUgCTF8URgi4hk2fkl+j3tGbmu6eRCA=;
        b=iEeeQO2TXCJbfJYU6+QBNm2sEe9bG4TTYcND23nYjoneJvjzZO55TKwskE+Q0fhPOy
         cQpLjgsG2xg76rdOeVms1q47h3FKE19nveb4p/OUpSZY08qtJa9Wf2GJ0lDxHJL++Ugy
         pSXyffmxQRSSTY/donCeN38L0x/n1DIcqqH8jt9VCwtfD+2c1WWcI9aTPwweipJAim93
         23YmxofgSnJA7ew5dFj2y+FtFTPWF8VyPQPyDBmz/XEoE/3MnyzH8RNd5XY4p7GwoHxG
         BQnYL7TW/IRfEhfpfzlx+3lAAFm5Oyejo4+h79xJ1tPLCF5bOy2DDPdFGBVHOZ2o8rf9
         8A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Abbi1YDLI6HGUgCTF8URgi4hk2fkl+j3tGbmu6eRCA=;
        b=5U2vSXkDnqfC0Z/5d8miXqst0kl9bkfhuztBhgdhWql4erFMAc4vfc+A21Stq6LZ25
         Fd2AkUcl8nC3b1fGyDTrvSdT6Jqz5do/sP3E8FWQKsrFuVYvKIUuTfl0iKt/fl5+wrnF
         57ez6j32fZsngbFi7hdqABkN1CtXvUO81qNRVFzx3bqwVOSNKS0ddmijDScS2hWoQQtx
         cUS6kpUmrGcXgRiB4XsXaaY1Ywk0DGD5tFkGTN/999lyUVBiN8GptXFgFd8FZblt6dfO
         roNd2TuWKfsvzPoYgXDj2WOb6eXOAnKEGOjjr6fGd3Xor5KRMPcprKRNdxPNNOxWR6bq
         JDlQ==
X-Gm-Message-State: AOAM532ck6akb4OdJLuMqVbHziB+1X2kxwQPVNyz3GbDRPIixV2DiyMY
        GKcDYTjO2JLPnwtPXCII8mRPo8zq+ivVK2kfyC9vPkoSmKgvWg==
X-Google-Smtp-Source: ABdhPJzbXRlhcvflyyfAUxBHpJ2LyqJeRR5OxbagbRt2Lp0FLQFQsh6EgHJzjh5ZH2f0enFG8m2xzaRfv/J7GZkUV3U=
X-Received: by 2002:a05:6512:2354:: with SMTP id p20mr2543838lfu.214.1632787195046;
 Mon, 27 Sep 2021 16:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210723231957.1113800-1-bcf@google.com> <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
 <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com> <20210927162128.4686b57d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210927162128.4686b57d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bailey Forrest <bcf@google.com>
Date:   Mon, 27 Sep 2021 16:59:44 -0700
Message-ID: <CANH7hM4Y2gt9PW_1oZbMQfvT6Bih9U-Ckt7d-w4fKkLp2R-rKA@mail.gmail.com>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 4:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Sep 2021 13:21:30 -0700 Bailey Forrest wrote:
> > Apologies, resending as text
> >
> > On Mon, Sep 27, 2021 at 2:59 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > >
> > > On Sat, Jul 24, 2021 at 1:19 AM Bailey Forrest <bcf@google.com> wrote:
> > > >
> > > > Some variables become unused when `CONFIG_NEED_DMA_MAP_STATE=n`.
> > > >
> > > > We only suppress when `CONFIG_NEED_DMA_MAP_STATE=n` in order to avoid
> > > > false negatives.
> > > >
> > > > Fixes: a57e5de476be ("gve: DQO: Add TX path")
> > > > Signed-off-by: Bailey Forrest <bcf@google.com>
> > >
> > > Hi Bailey,
> > >
> > > I see that the warning still exists in linux-5.15-rc3 and net-next,
> > > I'm building with my original patch[1] to get around the -Werror
> > > warnings.
> > >
> > > Can you resend your patch, or should I resend mine after all?
> > >
> > >       Arnd
> > >
> > > [1] https://lore.kernel.org/all/20210721151100.2042139-1-arnd@kernel.org/
> >
> > Hi David/Jakub,
> >
> > Any thoughts on my patch? I'm open to alternative suggestions for how
> > to resolve this.
> >
> > This patch still works and merges cleanly on HEAD.
>
> Looks like fixing this on the wrong end, dma_unmap_len_set()
> and friends should always evaluate their arguments.

That makes sense.

Arnd, if you want to fix this inside of the dma_* macros, the
following diff resolves the errors reported for this driver:

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index dca2b1355bb1..f51eee0f678e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -590,10 +590,21 @@ static inline int dma_mmap_wc(struct device *dev,
 #else
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
-#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
-#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-#define dma_unmap_len(PTR, LEN_NAME)             (0)
-#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+
+#define dma_unmap_addr(PTR, ADDR_NAME) ({ (void)PTR; 0; })
+
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL) do { \
+ (void)PTR; \
+ (void)VAL; \
+} while (0)
+
+#define dma_unmap_len(PTR, LEN_NAME) ({ (void)PTR; 0; })
+
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL) do { \
+ (void)PTR; \
+ (void)VAL; \
+} while (0)
+
 #endif

 #endif /* _LINUX_DMA_MAPPING_H */
