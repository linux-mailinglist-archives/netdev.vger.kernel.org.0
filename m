Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127252EBC08
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbhAFKBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:01:40 -0500
Received: from mail-vk1-f174.google.com ([209.85.221.174]:43311 "EHLO
        mail-vk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAFKBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:01:39 -0500
Received: by mail-vk1-f174.google.com with SMTP id t16so648462vkl.10;
        Wed, 06 Jan 2021 02:01:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mq/DDtuDIt7Y0LLrAtRcePlAZGcQuvjTkAcfILcZQYA=;
        b=GnkHR2WjKuFMi+Fm9TasRj+tqSy/l+hcw8u7ZUTdhd9sYbrIRdpgF6ctFduqPAGuvS
         GWXk8oU5qPwDq3VpebCtVgkB+ihx6/Uv4qFBWbCQDfe/vGzcCNNo3FRRKRjl/VEsTuw/
         1P3SHDThzeJDQ7j1F9jsfH09BfKYd25gEX5k54xIyhezJbkx1lJYMLY33zwmqMls8wTg
         bZutpdtDWCKhK+c3dGdSzaTspi1QqEDEO2ICT3hQLi11WkW+b8f5mI/XVDNSPBpVTg4E
         jMxKo0TYcugoyKzpDoSZtRhdFGrNbwwb3jTB7YD2VrIvcHg7yckytJodg4WOd+vOR1wn
         3QKg==
X-Gm-Message-State: AOAM532kJpVMlWXFye0k3+EiFrBcJxzumpoB28vJ9YXabpFcJflz5U25
        Va4UeX2j8kInUvvgbnrCxjI40HWgHKXs1g==
X-Google-Smtp-Source: ABdhPJyuHhN40IOZRObGsDiPiTVjs65QA1+7W/Jubwmn031DKD6A5tbd6XShpgn8N1UoRH1Qr4ulgw==
X-Received: by 2002:ac5:c3d0:: with SMTP id t16mr2822517vkk.5.1609927258006;
        Wed, 06 Jan 2021 02:00:58 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id r23sm294461vsj.17.2021.01.06.02.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:00:57 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id e20so1471822vsr.12;
        Wed, 06 Jan 2021 02:00:57 -0800 (PST)
X-Received: by 2002:a67:7102:: with SMTP id m2mr2674144vsc.30.1609927257263;
 Wed, 06 Jan 2021 02:00:57 -0800 (PST)
MIME-Version: 1.0
References: <20210103112542.35149-1-samuel@sholland.org> <20210103112542.35149-4-samuel@sholland.org>
In-Reply-To: <20210103112542.35149-4-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 6 Jan 2021 18:00:44 +0800
X-Gmail-Original-Message-ID: <CAGb2v67p-8cp-OkKzkVrfL9tpCYrUQEjkYy-OUuaUhAgDEtscg@mail.gmail.com>
Message-ID: <CAGb2v67p-8cp-OkKzkVrfL9tpCYrUQEjkYy-OUuaUhAgDEtscg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
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
> Use the appropriate function instead of reimplementing it,
> and update the error message to match the code.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
