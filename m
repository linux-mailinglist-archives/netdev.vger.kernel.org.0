Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2731AF9A
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 08:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBNHbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 02:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhBNHbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 02:31:43 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5951BC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 23:31:02 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id n195so4002375ybg.9
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 23:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0NFRMoCIBg17R5WvEqGuR3xkawgs31RwTgIaRPst34=;
        b=dsVHVGbtHkov8jBqlz2FSgwta/3qkQr6mHHhp0x69Z8ZWLa836pVL8+eHt72/hhcBI
         l+jCG8n09/sfS/dqnWaokD2BJ7D+zbExgeaKGimKDz+ttZTyFiRTxZa4jqbDBOoetZ/8
         DNKS29n8PNjoFFS7iqxjQzopUSZXVemprP68662kBW7GlUn33sWPVD7kjqB51fpLs5Os
         fl1Oe1+aWci/OwxY/xl4c+A/I8yJlwmUyNwkNzsMN5oD5Jv+wuhmYp3+B6xPrOe08DGb
         dP5XymjiwNuVpZBoXxalcbzzYkD2x53HEPSr3iUwK73hWPjPZElEYsDzHJx9XhIuX3Ai
         2USw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0NFRMoCIBg17R5WvEqGuR3xkawgs31RwTgIaRPst34=;
        b=BSpfrpTk2Ik+QVBYWbyZUHPxaWW1qtDwD6wOnHkZrn4eqzXHn6yBwiNJ0ACAIHKM+8
         OFoFN3/PHso2zIoxhohrGjUpsofW4j54KyblFWLYWrE/WsfnXv/TXVUPgIL4v+ZSh9t+
         PPzzR1Xz8MRczkBAM0ZGEH/fwtX6VuF9HzCcbfn2q5pmiMEY66Y90Z/bLhjjw8fynO09
         AWFkbVMYeV6KDpEfc6Lr6YSIlGMckXaqkGJIGY3RGoU2/15c/+2Hrrn/u5K+0+HTnNDh
         1SA48VCVgVVTiybnjee0wWU2yzWfhiyDVScufi0Jz2219MiA/2vONb5epdHC9RNb3ukv
         5oMA==
X-Gm-Message-State: AOAM530NXPlOctxxHf+x7Qt12gzRqr9K6OJJ+hSzmak/kzkiZmNf4DEy
        uu3aaeZqbSPJVg3p/iuNRmuIpNc3jSgaCOA8kY0=
X-Google-Smtp-Source: ABdhPJxayp8Zt2wT/Mw2a6//3LBN8nDdADL915m2lPMX3ay1vpCHTqgiHlVD8f/oTBxu3HVrM1XFDyxjxRle/57GQUA=
X-Received: by 2002:a25:ae14:: with SMTP id a20mr4110229ybj.129.1613287861584;
 Sat, 13 Feb 2021 23:31:01 -0800 (PST)
MIME-Version: 1.0
References: <20210212052031.18123-1-borisp@mellanox.com> <a18aaeec-049e-72c1-f981-3e18381b0f49@nvidia.com>
In-Reply-To: <a18aaeec-049e-72c1-f981-3e18381b0f49@nvidia.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 14 Feb 2021 09:30:50 +0200
Message-ID: <CAJ3xEMi0574vgmHMt8LCe36RhH0XJg=LoTU2Jdx+W7+FWMmkBQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 21/21] Documentation: add TCP DDP offload documentation
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 4:11 PM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:

> I got interested and read through the doc, there are a few typos below.

thanks for spotting these, we will fix them
