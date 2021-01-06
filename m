Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED92EBC06
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbhAFKBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:01:24 -0500
Received: from mail-vk1-f170.google.com ([209.85.221.170]:33746 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAFKBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:01:23 -0500
Received: by mail-vk1-f170.google.com with SMTP id q66so665036vke.0;
        Wed, 06 Jan 2021 02:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TEfLYCUzeJevfSc/AsYSKGX5y878J2YSKlJ2d3Yw/qw=;
        b=BRSqz2DRD7ZZ01BGbMRUietDHG8u4ZvnPFU2od8uqktZpCi5mdGXDqHn81Zy7wYSyQ
         5ZbmkIVrXEaojMo05EtzJbbrlDY5UPdtaml/KGerFHubJtF2u9pQSHmkWjV2bK0rBaLP
         8FFZ9Af70Ao2gEkc6+xoslBSiu2EvKzatBkhXvJgM1R8yOcMqTe1ve6O0O6ezW/sv1QQ
         eouY8pReajaX9LWt7xsbn+RYJ0N6cWrwIE7HOycW88M5OTTUB6hjoTZMU4oMCEfYrcz3
         AJaqMeTuLRjjXXH3MhndRDnMzylMBHKXIA9kGWGNJPSlG3/8wuOPJiZTEX8ae97gu2JY
         kfvg==
X-Gm-Message-State: AOAM533SmtCLxcdT53Gp7ON19LYi8TvFhNnOVlFuQbi3LHv/2fAbUtA0
        GLIZc3aX8iwDdOfuwRdpdLJ5pE6spWG98w==
X-Google-Smtp-Source: ABdhPJyPVkRJiZndN+5bNQpg2d2PKOWiuJ2w+1NuUsV0P2M6US7EVixhKKphP5CqJBt1vZRc+J3BGQ==
X-Received: by 2002:ac5:ce9b:: with SMTP id 27mr2830906vke.9.1609927241550;
        Wed, 06 Jan 2021 02:00:41 -0800 (PST)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id i45sm270744uah.11.2021.01.06.02.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:00:41 -0800 (PST)
Received: by mail-vs1-f47.google.com with SMTP id z16so1496696vsp.5;
        Wed, 06 Jan 2021 02:00:40 -0800 (PST)
X-Received: by 2002:a67:ca84:: with SMTP id a4mr2493967vsl.2.1609927240484;
 Wed, 06 Jan 2021 02:00:40 -0800 (PST)
MIME-Version: 1.0
References: <20210103112542.35149-1-samuel@sholland.org> <20210103112542.35149-3-samuel@sholland.org>
In-Reply-To: <20210103112542.35149-3-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 6 Jan 2021 18:00:27 +0800
X-Gmail-Original-Message-ID: <CAGb2v6526A++R8bXypAJW6TOrmQrBRTrfeW+rXG6egXXMLfsjw@mail.gmail.com>
Message-ID: <CAGb2v6526A++R8bXypAJW6TOrmQrBRTrfeW+rXG6egXXMLfsjw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] net: stmmac: dwmac-sun8i: Remove unnecessary
 PHY power check
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
> sun8i_dwmac_unpower_internal_phy already checks if the PHY is powered,
> so there is no need to do it again here.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
