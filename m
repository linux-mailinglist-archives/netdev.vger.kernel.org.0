Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC3D434610
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJTHrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:47:35 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:39262
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229711AbhJTHrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:47:33 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 571F4402E8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 07:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634715917;
        bh=hn4G6B24NKuuI7XYmyB2qc+VHWq7V63yNRCu8uWR8QM=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=dclNfgrNNjwMsaxAuNfmH/6ouGqq9wnCS2pl/SXvv6dtckG85jx04ddYh6hHt42UJ
         p5GsRRWECvv+yes4oRFBch5EP047RBZrwq5Msqz4OGJA8x+DZs7hvR9kf1yoMH8VnF
         reznLsm/6Qyfc8NcIj26b3K+0cFYb/h8mv0ASwKq+i22b0MR7UwlQG14ilTDDqGYzM
         oJ1Idd8+JbsLhaR62sinhUTwB99XdEwz/o6rXJiGxLurpLfhRAePlPolAznFMjATEI
         rSSyD205qylm4XQzMePQ6wZZGO4EF5CHUXN7JOS5OOCrQXdhCTx+7TScip/MwDe+B4
         vku0QH0E3pYpg==
Received: by mail-wm1-f70.google.com with SMTP id k20-20020a7bc414000000b0030dcd454771so2624091wmi.8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hn4G6B24NKuuI7XYmyB2qc+VHWq7V63yNRCu8uWR8QM=;
        b=BaK8134nh20adI9ZaG09YO6X68rePMHqiNqKlpp05kDUTh22y9mVyXdEAjG6R30zkS
         Qq2lwkgPpLEYzNn9dTVwFNxIskNZU40+/vrZnszBbiZpUIHP5i8sYfyFeScQmCFnhwUe
         YM0H4RMB226wU3Vi7ouvN0VoC6kazFyuitmgMWVC/AN1Of5MoPKrRuYLmdZVWL5rOCD+
         iq0E+1dp25qjKEpI3xVFB3TxmVcm7+mJOhrwNyawj0WQuXG5f/AEYdA7oURpQ79ExZ0s
         A0exT1XCiPFJx+i1l6FOdaCa0xgvPdawCGmWzoH5STusIJXTAlRJX9G6btiRA/btYSkp
         FJlA==
X-Gm-Message-State: AOAM530Yr4d9BPC2svTdHn/5pur+BZBIL8V2minimQU+mC1rlJA7RBmb
        lYNsw8XQpguxiOdS9BZxfFtDryxcK39L2l+OQtcxO+JM2SYYPJFIXmHBULCO5TPPos4ewbplMeQ
        TPGBLpXnnSDso2pzFr5dYwSVP4rNFfOXfrA==
X-Received: by 2002:a05:651c:10ac:: with SMTP id k12mr11579161ljn.296.1634715906906;
        Wed, 20 Oct 2021 00:45:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylw2trvF0ZXu7khnQZx/gnaE1TXWFJT87p6K5VtMB66Foj+aVE5ln4wd6dcSv0cFlFYuFolg==
X-Received: by 2002:a05:651c:10ac:: with SMTP id k12mr11579071ljn.296.1634715906590;
        Wed, 20 Oct 2021 00:45:06 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id s10sm127484lfr.172.2021.10.20.00.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 00:45:06 -0700 (PDT)
Subject: Re: dt-bindings: treewide: Update @st.com email address to
 @foss.st.com
To:     patrice.chotard@foss.st.com, Rob Herring <robh+dt@kernel.org>,
        maxime coquelin <mcoquelin.stm32@gmail.com>,
        alexandre torgue <alexandre.torgue@foss.st.com>,
        michael turquette <mturquette@baylibre.com>,
        stephen boyd <sboyd@kernel.org>,
        herbert xu <herbert@gondor.apana.org.au>,
        "david s . miller" <davem@davemloft.net>,
        david airlie <airlied@linux.ie>,
        daniel vetter <daniel@ffwll.ch>,
        thierry reding <thierry.reding@gmail.com>,
        sam ravnborg <sam@ravnborg.org>,
        yannick fertre <yannick.fertre@foss.st.com>,
        philippe cornu <philippe.cornu@foss.st.com>,
        benjamin gaignard <benjamin.gaignard@linaro.org>,
        vinod koul <vkoul@kernel.org>,
        ohad ben-cohen <ohad@wizery.com>,
        bjorn andersson <bjorn.andersson@linaro.org>,
        baolin wang <baolin.wang7@gmail.com>,
        jonathan cameron <jic23@kernel.org>,
        lars-peter clausen <lars@metafoo.de>,
        olivier moysan <olivier.moysan@foss.st.com>,
        arnaud pouliquen <arnaud.pouliquen@foss.st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jagan Teki <jagan@amarulasolutions.com>,
        dillon min <dillon.minfei@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Ludovic Barre <ludovic.barre@foss.st.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        pascal Paillet <p.paillet@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Le Ray <erwan.leray@foss.st.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        dmaengine@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
References: <20211020065000.21312-1-patrice.chotard@foss.st.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <22fb6f19-21eb-dcb5-fa31-bb243d4a7eaf@canonical.com>
Date:   Wed, 20 Oct 2021 09:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020065000.21312-1-patrice.chotard@foss.st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2021 08:50, patrice.chotard@foss.st.com wrote:
> From: Patrice Chotard <patrice.chotard@foss.st.com>
> 
> Not all @st.com email address are concerned, only people who have
> a specific @foss.st.com email will see their entry updated.
> For some people, who left the company, remove their email.
> 

Please split simple address change from maintainer updates (removal,
addition).

Also would be nice to see here explained *why* are you doing this.

Best regards,
Krzysztof
