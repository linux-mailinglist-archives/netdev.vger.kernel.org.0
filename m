Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC682E754D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 01:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgL3AMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 19:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3AMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 19:12:33 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C07C061799;
        Tue, 29 Dec 2020 16:11:53 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id x16so20111590ejj.7;
        Tue, 29 Dec 2020 16:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIC/2qIdJeGBQNWxLU5IRoKvRyuZw5pGh6L03h8axVM=;
        b=ZXoYaTF9bdee6/o+D9RUWWvQtRtNTYdwAItnxc5kAGIMUCw7lNqKJ+rZ0UHgq6bCXs
         6dsBeUb2CoojB6ZeH+53yL0aKdp+OFLOFmxOj5bW0pWbToSoObLYfxG9AY9V5xGyJto3
         CjMvYrIjsYGKXU+7zPfHelpCusMmEVYheXIDPQDHJg8chMZ0v81Sv+LUiR6aJV/4wgPA
         IJ6kSZjV+HD+MTgEwCkcNQQwEOrcAXG1JtWGWsTahbpLHBkSHJrJukXd0O1ivxzXEjVk
         fN66t7QhuzUtHFfFv2yOjXu/n9+usKyxVy0dYuewW1mrbRV3cFibpBIZ2HwnLaBKOOAE
         POAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIC/2qIdJeGBQNWxLU5IRoKvRyuZw5pGh6L03h8axVM=;
        b=ATuKa4rJzavAXWdHBPYD0fUasYLYiorthrc9LqMfZYf6NWClYH6LZ4ZxThVtAReHxD
         +QejA/Y1kwFQopnsrR3nXE57gHRAntxM4B/6ZiG1SGg9OmxDqAVjBUXPwXzlCLShO6iV
         sdX349vRIiwUzMHMI3WtrmA/I3le5a68Vj8ZaWJh39/8rRAmtR9ltwIV67HOopxSXXzG
         aQm0Fc59fyneszrU+jWAsygjbjiC2OkVbK0McMAY+Ifkb4LsT8DLngG6zee1CJQ1cJFQ
         MohfJlM722fjS93sVOXO34gQgrT70fgz6zgAtGrktZkr643Ze72TDQ/Ik/l5WuzwpVyl
         1hRg==
X-Gm-Message-State: AOAM531KAq8K9bBPJSmX3+uocYdtvGq0R2V/s2OVCYeNyA9kVcT4Ls9q
        Gqm335LFObxTAETd7LZdozWk2/6Vo6G8xzJk3g4=
X-Google-Smtp-Source: ABdhPJxAo/edRUUxpOPraaqjveLTeoRRb5rrdRwWHdyI1u852zzcnS6mVRrCRKC/Cls55s6FCcSBPu9Xu4SkdZwl2Wg=
X-Received: by 2002:a17:906:447:: with SMTP id e7mr46945242eja.172.1609287111922;
 Tue, 29 Dec 2020 16:11:51 -0800 (PST)
MIME-Version: 1.0
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com> <20201228123744.551d1364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228123744.551d1364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 30 Dec 2020 01:11:41 +0100
Message-ID: <CAFBinCDM+bPgwquZAG-H=iMZr4+0rW9CG=WafRys5_HdeBkzjA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] dwmac-meson8b: picosecond precision RX delay support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Dec 28, 2020 at 9:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 24 Dec 2020 00:29:00 +0100 Martin Blumenstingl wrote:
> > Hello,
> >
> > with the help of Jianxin Pan (many thanks!) the meaning of the "new"
> > PRG_ETH1[19:16] register bits on Amlogic Meson G12A, G12B and SM1 SoCs
> > are finally known. These SoCs allow fine-tuning the RGMII RX delay in
> > 200ps steps (contrary to what I have thought in the past [0] these are
> > not some "calibration" values).
>
> Could you repost in a few days? Net-next is still closed:
sure
I also received a Reviewed-by from Florian on patch #1 so I'll also include that


Best regards,
Martin
