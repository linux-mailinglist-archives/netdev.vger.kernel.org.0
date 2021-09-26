Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9899A418D25
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhIZXrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 19:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhIZXrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 19:47:41 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FACC061570;
        Sun, 26 Sep 2021 16:46:04 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id z62so16191090vsz.9;
        Sun, 26 Sep 2021 16:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8c9UaZuAUrwYK0IVWso5zeXCprrmv1nwvjOP+NENb/0=;
        b=ZkkgY6mAM1Kl6WSZUu5+KTBzdYRb0wrq4acUSpP3j3ITAhR69Hs8Dmd83BFKNgJ/XR
         hNiAVKhOMKwimdLAL4JxYB6P8bmw8f/fKdcu1W61LHUOlcWlCQ0HTsH1nOY4/SbMGeoQ
         3XGxfyP5+5Or7LfKeLUu9govzXoEccSyy+pXlvvmsgMZjSdgXAsByg1VePlf7VOws0xV
         nynb6x3U6RUa1lvu8imdu9eZGsLts9LGVo1cIaoQ1/5ePULgcAxsb7J+pQD1nAYZfbX4
         zRIpmoGFD6GrYtZu9SF/DwLp8cUj/ZRKzCNNh5KwnV8kqXIcbXpGxxK5EgwLXHvxKjrW
         iUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8c9UaZuAUrwYK0IVWso5zeXCprrmv1nwvjOP+NENb/0=;
        b=DLOsyRZsV3p0sHAiVrnRK50ACO3LUfKd0I238NqpCoffSmf08S0TZGZLOmkcj1y+yW
         6+u+r8CEAbdh5gRS5tHc8p0/EER4nVboCvBW7Q60QdPlC72hm4pic0BgiLITdzJFU2a0
         teyBanno2Pq7+hg6uNiVHixjH5OJY3669eZxkwfKvFzKF0HMvTLcULnF58Jr6oVOcRlK
         Fvbz6dQH56TtwYB3Rrr363/ecxjNEyImql816jsIko58TfcrEnNbm0zDfHAsLODr70oh
         X/k5NXvgcB+e6bfCRhTIRvT5pAIiR/UTgqXerM4DMsBpRiwSlkSNiQXcYaPnzVwPkRrA
         UsSQ==
X-Gm-Message-State: AOAM5322ofXrovI20e3zUgg1rmr3s3tEAVttwQEBuLKDuUXhRzXQiGb+
        dCaMHdJZjBBmovkEHLg5ZeKiUGEvx6pkL+UL6k2tlcUj
X-Google-Smtp-Source: ABdhPJzIhZ27ZvekEPFk06fEY1qJM/EFhpzbe0YoNntTaFo/FqG5wbczXQ1KZFQxIrZyjRNNNBTCps3XZoQlxjckGh4=
X-Received: by 2002:a67:2e4f:: with SMTP id u76mr17483265vsu.39.1632699963186;
 Sun, 26 Sep 2021 16:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210925124629.250-1-caihuoqing@baidu.com>
In-Reply-To: <20210925124629.250-1-caihuoqing@baidu.com>
From:   Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Date:   Sun, 26 Sep 2021 16:45:27 -0700
Message-ID: <CACG_+vJC-V-n68XWY-6zb_VBTfRTv57xsaC-Fge1s1-dJf2BYA@mail.gmail.com>
Subject: Re: [PATCH] net: cisco: Fix a function name in comments
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Christian Benvenuti <benve@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 5:46 AM Cai Huoqing <caihuoqing@baidu.com> wrote:
>
> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Thanks.

Reviewed-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
