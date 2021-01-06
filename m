Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6445A2EBC0B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbhAFKCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:02:25 -0500
Received: from mail-vk1-f173.google.com ([209.85.221.173]:43330 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbhAFKCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:02:25 -0500
Received: by mail-vk1-f173.google.com with SMTP id t16so648893vkl.10;
        Wed, 06 Jan 2021 02:02:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v2GPyCfexmLEiZ+8ddHhwuP5Idb606RB8tnSnxFsK/o=;
        b=PYIy8tru6yNAQYw2jlbPFPmrp1oSXdLGb/3p62+HvCz55Jfp4N3pqh9fhVu/UqajZa
         wIxuGaej+br67rwexv2E/5DsLfo+GSKcIdnZMCZPDfGBkGNx5F/Yee1GYa4KsAdC4lHW
         TJ1r01leWSsAPd4jw4BNJIUjizD0sWEvnXTEpN9alffibc7EMLTYpDhfTWkYAkdkNteL
         hNWuksWM40Dp1ovn8KXweeEpzkML5COArA99YSB/I3Ym/9MU0SoU1+0StGhrZXaf//kq
         452i1sbhN4saXPGtfo1eG6D7IDCbE87oYrl5Uc4gxtqKSseLCF3hzaaPfTHlbMaTbz3n
         oJDA==
X-Gm-Message-State: AOAM532fzJc+4cdUdV8vHT9p3QRDANIBIqZIYxbqnVK2PN35GylCUP1i
        pG/z4SyohFUoDWmFWZfd/VMduLbcQTxyDQ==
X-Google-Smtp-Source: ABdhPJy7bwh/KRwKoQ3B0Wxcd+68LqIvCtm98/cYwie+LbL1PPa4JthKdL+zHOC27xNDvPSUXZyYLQ==
X-Received: by 2002:a1f:4393:: with SMTP id q141mr2871445vka.12.1609927303260;
        Wed, 06 Jan 2021 02:01:43 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id z10sm291164vsf.26.2021.01.06.02.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:01:42 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id t15so889355ual.6;
        Wed, 06 Jan 2021 02:01:42 -0800 (PST)
X-Received: by 2002:ab0:7654:: with SMTP id s20mr2794287uaq.23.1609927302342;
 Wed, 06 Jan 2021 02:01:42 -0800 (PST)
MIME-Version: 1.0
References: <20210103112542.35149-1-samuel@sholland.org> <20210103112542.35149-5-samuel@sholland.org>
In-Reply-To: <20210103112542.35149-5-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 6 Jan 2021 18:01:30 +0800
X-Gmail-Original-Message-ID: <CAGb2v64xwyXS7rK2L8Y7qGiOXfa1uj1wTJMnki+xs9g_NHzLcQ@mail.gmail.com>
Message-ID: <CAGb2v64xwyXS7rK2L8Y7qGiOXfa1uj1wTJMnki+xs9g_NHzLcQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: stmmac: dwmac-sun8i: Minor probe
 function cleanup
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 3, 2021 at 7:25 PM Samuel Holland <samuel@sholland.org> wrote:
>
> Adjust the spacing and use an explicit "return 0" in the success path
> to make the function easier to parse.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
