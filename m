Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB6358BC7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhDHR5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhDHR5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:57:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF09C061760;
        Thu,  8 Apr 2021 10:56:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a12so3030073wrq.13;
        Thu, 08 Apr 2021 10:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3APVCcx7fE+D9GYENXAouefDpITXGsrwB4m0dA805sU=;
        b=pADVOi6j11mDz66kWpbS5a17RJ8aO3Touen4E6qY4ChWsz0LW/kynwxWBDpYuhMMBC
         NyozR5jT9AmooAYlQs6cCgYM/YG7+UCiUFVwFeKY87pTdhl495+LeBXJeqPugjtDuSi4
         dhhdf2IvkJB7Lx3pXxtyozA88dzmoQ6CQR3xu95aUEHnn3Ad5zwgpTurEXyK3hnLiCr1
         h8FJB07NUGWrEXVCPLSe/W5VghWJFLel+p/yE0iU7Ae99WV+C5NZii6YRZ+cHGb63LtB
         p4hwKKkIuhibBukT94lEFg0nzKqkHkeFxSVotKdQwznd7IOsb7YnjtciwY609hrKtaqm
         oYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3APVCcx7fE+D9GYENXAouefDpITXGsrwB4m0dA805sU=;
        b=XcekHw4qEM2vHbTnDJ1js/kpKgk3V0tQfKjCRoy9qrxilxfUgu9QJQDsa2qEy7PQ6h
         X/7TuuhHem7PsR3OXE2JM4jQhonWnCPzYLPOy8g4bfkF6+VsCTlJPtA3arZSxHJjZDTr
         BrPgPm57ijTaS+OSGIpEiJOdNt6vdmwfoPOlXS2no6+whMMPFzh8jcZLmhzDDK7Y57ML
         PFX2vyyl52mkffe6OKjagstgoEGFaO0ORcYqDndpFDaRTAjOqYgyVdmkNWFPphGbzZ3q
         F2LXfCflV3nZddJnkGbnVO8Spo2nWlx9KQz9QkXpErBzMab7EyE9aIlwRhQEfySpq2Y9
         taVg==
X-Gm-Message-State: AOAM530hjOambUjjDV3a3jR7oMGjyznA0BzdTSj7x46RVVUX4m03uR2P
        5h8tarcAJju2fuCRYunTvflA7Fajpcl1/xMuXSWmjGO33bU=
X-Google-Smtp-Source: ABdhPJyxCaHrKAboIduXS/GhOhig9gyR1LCsTCIJgdAkoV1rmfshPUOMdv5pFnSIlYJF2erCwYoCVZBQ1BkLmZBV0wM=
X-Received: by 2002:a05:6000:14f:: with SMTP id r15mr13313275wrx.166.1617904613457;
 Thu, 08 Apr 2021 10:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <42bca8b7-863c-bc2d-7628-075ca18157af@gmail.com>
In-Reply-To: <42bca8b7-863c-bc2d-7628-075ca18157af@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 13:56:42 -0400
Message-ID: <CAGngYiX=9su1dpXPHzhT6sABDahbfEb_538J+j_MnV=Mj8PkDw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Thu, Apr 8, 2021 at 1:49 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Can't we use frame_length - ETH_FCS_LEN direcctly here?

If the hard-coded "4" refers to ETH_FCS_LEN, then yes, good point. I'd
love to find out first why George and I need different patches to make
the driver work in our use case, though.
