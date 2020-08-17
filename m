Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745BA245ECA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHQIG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgHQIG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:06:26 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B13C061388;
        Mon, 17 Aug 2020 01:06:25 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so8953519ybp.7;
        Mon, 17 Aug 2020 01:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RvZPDrvmfEiKC4tHNx7HHIStbbhxJ3KZNZoKmceVCt8=;
        b=iLdjt5aGTDR2TjfH/YM/zYjVgquCAFjTonvBSjNebP+JplL/9szjGBHNCoIw4A3kzT
         FlDKeVeq3h6yAVKSRKIfMqF4IxNmb7EwJVykI2N2weat8Qj6zSQbCwHmU/q7S8rjBA7s
         SSVLIopj6vA9mUZehH+uhO4juamYi2ym5judzl6lFE4/PtBvGnR3iy7WQgf2XYiImavU
         Sw4kRLnLb5ylIvhXRLrnajIO8p0VG+n3lbl3wodIIq4TUSj+vyvDIWWR3Xhcfgr1zits
         mck22Jyqro/lL3uFXyqdLPDHK24SxnUx00feSoPus3RGKkO1Q7Dyeq/SOVKoL/L2rxOX
         SS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RvZPDrvmfEiKC4tHNx7HHIStbbhxJ3KZNZoKmceVCt8=;
        b=kVl9CodUWHHbdIjPefjrfda2C7i9Mxv7mm8nfZcTt5pl4QMyJV3Y2I0UZrYss46A2r
         2lFIu9AZxX40m5IJxGcTtWuHDXybMx26T7L5wQXXioUz54v/ZhvN5dZXs9VYXJ57w/XM
         FTUJUY237oMEmOnl9BUN1gH0fmg0/CQG8KrbUcNtomDvBnvFSxG/yldMBaDe8sXAiPXo
         SZR3DtO56PELQm6QVTTdAvQofr9EZtv3R3rZMaT+RwbSkqW0mE2eZyfg0vYWcY9ZyhLy
         dGSrRiYkonxeQPE0L17ETi7UvQM4y1UwuUNav89k3M30eisjPI0LtWROcwGnoTkjimQL
         VQXg==
X-Gm-Message-State: AOAM533qgO08LbzY2OpP/PphglE1foFanrXURRZ831C45W9w2WTHd6+5
        rb/wZ7JeeVs6ESvWmf8Bfg9OAfitPUd3nNd+VzQ=
X-Google-Smtp-Source: ABdhPJwuEiUsH+Vvl0Yk+PNDQ+Y5+7C2mO55RV8fSgIhUwox27zfL1LyVmevflabpOJiY5DM9KPz97anKR2APR5znb8=
X-Received: by 2002:a25:df92:: with SMTP id w140mr18569600ybg.455.1597651583753;
 Mon, 17 Aug 2020 01:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200814113933.1903438-1-lee.jones@linaro.org> <20200814113933.1903438-27-lee.jones@linaro.org>
In-Reply-To: <20200814113933.1903438-27-lee.jones@linaro.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Mon, 17 Aug 2020 10:06:12 +0200
Message-ID: <CACna6ryNNyyVftEFNFEwouKc3O21oPaeqie+bjJR4L_Cf8z2BQ@mail.gmail.com>
Subject: Re: [PATCH 26/30] net: wireless: broadcom: b43: phy_common: Demote
 non-conformant kerneldoc header
To:     Lee Jones <lee.jones@linaro.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Michael Buesch <m@bues.ch>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Andreas Jaggi <andreas.jaggi@waterwave.ch>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Martin Langer <martin-langer@gmx.de>,
        van Dyk <kugelfang@gentoo.org>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020 at 13:41, Lee Jones <lee.jones@linaro.org> wrote:
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/net/wireless/broadcom/b43/phy_common.c:467: warning: Function parameter or member 'work' not described in 'b43_phy_txpower_adjust_work'

Why you can't document @work instead? Should be quite a better solution.
