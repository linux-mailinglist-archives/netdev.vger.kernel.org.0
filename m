Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDFEEA5B9
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfJ3Vuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:50:35 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41006 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfJ3Vuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:50:35 -0400
Received: by mail-oi1-f194.google.com with SMTP id g81so3366083oib.8
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 14:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=96XMMtdJ245IEwl8JA/QwitEsK6iJbDAKrGxck2zsvI=;
        b=YmI5ezq8Ab8to17yW7PbMNdi53SB5CAGrF5WdxL7YDg5iLGksFsn1X3ekdybKGCdom
         GalNNGq9HWkxNO8KdpP7FQno0k5NoPuzsHNiIVl63sMmLpzLpDXIBUwwRa37oRTGb7P0
         Bb1Hdf0pppOU1GdOxnoCqKgE2ei7PDpY4UKvBfUpyT3guy9Sggsm8UqyzAbgg1kEV096
         HbcVT6xzQ5DP7vRyCxiRYoBQSnAoSPLKWuds+2Wl1FCsy2G33+Gh9gLD7oDmku7wQASZ
         jd+KkttY2Xn0xg25svsRyjIfHiDhewF5ksVurMoKnKAAmUqf9ZOSWFJK9TC3mNtidJYn
         n9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=96XMMtdJ245IEwl8JA/QwitEsK6iJbDAKrGxck2zsvI=;
        b=KZF/aDQMa418HKC1fa7zb7tVSCXnzDMcDE7kmKsRK1bxk/zCXxp4N3MT0iO26vINZ2
         DvukVGG4Z/7dsnMcLNYTBn0fvjInVPz7cpZ9+NE8x5817Fc0K7xtyS8S+8K4ohkFXA02
         Ieihju5nrPWb7KFWX+A8SQwqeD3UqMAJUrgvnj3HE4tPe+PXNSXKOxU2himZJNsMw+Hw
         mpBWfgRicm5sV8YjyerB3qY7xB/EZNkk+arnkwrlfBNmFs4SkeTYyc0Llbcm8Aswv1FA
         E5SCmcHVSQQ8IHn75uIlqYDRWiCg5Jdout+m+gvx8eLUgObudFfEd0NXnt4W/s6kg5/J
         pKgA==
X-Gm-Message-State: APjAAAVqmiEEJgdO3kguOVAR7ADUo1eBITXKdvW0y6XHRLSMUP+9pwHh
        LQw513xbOo2OmFuJGYmT8XcRX+e07vLFs2MCr/LKig==
X-Google-Smtp-Source: APXvYqxbDcOvEYqUTB/BGSklp4tzoF82IbfkTtKdAa/v6XOYWI89ByMNV1DhgvsEKlxibtDLvwrZ2RnIDoAdE5w2MjI=
X-Received: by 2002:aca:4489:: with SMTP id r131mr1242344oia.60.1572472234045;
 Wed, 30 Oct 2019 14:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191028182309.73313-1-yangchun@google.com> <20191029081851.GA23615@netronome.com>
In-Reply-To: <20191029081851.GA23615@netronome.com>
From:   Yangchun Fu <yangchun@google.com>
Date:   Wed, 30 Oct 2019 14:50:23 -0700
Message-ID: <CAOPXMbm-rtONc+HLvVc8tuo1ftdkfkKX83DK0sFhb53aujrwWg@mail.gmail.com>
Subject: Re: [PATCH net] gve: Fixes DMA synchronization.
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 11:23:09AM -0700, Yangchun Fu wrote:
>> +static inline void gve_dma_sync_for_device(struct gve_priv *priv,
>
> It seems that only priv->pdev->dev is used in this function.  Perhaps it
> would be better to pass it to this function rather than all of priv.

Thanks for the review. I will send v2 patch with the fix.
