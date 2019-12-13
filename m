Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FCA11E906
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfLMRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:14:59 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34813 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbfLMRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:14:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so5590pjs.1
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 09:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=xGfkgHFOiwzu4bSfkgFVF67O8wpT6Z/ekwvnkfqDuzY=;
        b=cUYdO6uuG/TiXeqwUvZcAm2hBzDMImTYy4ODdcn/fMcmh9JgLu1CLGGVX+KIvvSvO0
         o8aWIqxEx/ptb+/MPjY/Yq579KsJr1o9RPqaiCllSSleXUTWrLmcI5RrEd+/Vrfu6Flu
         CWYAgQa0ZlDt6LHKcaWNRNJjJC1lmY2DyL0S80riSCKaUdLoml+I2lmjv4MSWugYx9o5
         s6JunedYMjjRe7k0maLrsIspTN1iGgwZbO2xjk7eeLOQ9oZ/D3yt0WyYvo0YErpvSsqV
         QnY53A7SjfDhKpy53r4//AfCp08E65blD6Nm/gIFCLH23SXnz4k/U4az1r298eO7WUUq
         FlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xGfkgHFOiwzu4bSfkgFVF67O8wpT6Z/ekwvnkfqDuzY=;
        b=MfRojymgIjSvzUaT4CyiepprCt2hNuuP0GN8TzV7yhA3C8zG4ZGwdPTYORlhl9gBC/
         PWns2wg7o5Frs8TwZua2muU+xVE6plXEjDEvTPhEydqHeyVAp3DtH+gIwthFzHBOpTLg
         nB+yJsAceSlDAWtoo1MVzY2BPgia1sOmzYazWnBvowHOC/kmwhrEIkyLAES9VIF0fGYX
         UhSSWiC8orHiV4UDb+G9hR3x78ijTAOVv7x9lHav4+Jhp2r0AnwQvcu+8/V9kK9MKzFW
         LzUqvQjMIGKzmZ/YyAS4TDes8/Ee7XPOK7tQSDgnPwf4stjuF4aDABz6/Y65QmawFfyi
         VWgw==
X-Gm-Message-State: APjAAAW/XlxwywS8gI0Z2GOPn8zyNnwqAvkEOBIIxVAjddY2KEbDw5UU
        NO5iLgWjnTjP8pqLaWaUTFdeJQ==
X-Google-Smtp-Source: APXvYqxNp9JqbsXiF34gHi5lFrYjYb8YF87UwVb6GpItvh6TUJ6QG94Jp9JFz8MrAz7ABEyxzH6tHA==
X-Received: by 2002:a17:902:758c:: with SMTP id j12mr431734pll.14.1576257298141;
        Fri, 13 Dec 2019 09:14:58 -0800 (PST)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id n188sm11426933pga.84.2019.12.13.09.14.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Dec 2019 09:14:57 -0800 (PST)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Guillaume La Roque <glaroque@baylibre.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, nsaenzjulienne@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] bluetooth: hci_bcm: enable IRQ capability from devicetree
In-Reply-To: <20191213150622.14162-3-glaroque@baylibre.com>
References: <20191213150622.14162-1-glaroque@baylibre.com> <20191213150622.14162-3-glaroque@baylibre.com>
Date:   Fri, 13 Dec 2019 09:14:57 -0800
Message-ID: <7ho8wc87vy.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume La Roque <glaroque@baylibre.com> writes:

> Actually IRQ can be found from GPIO but all platforms don't support
> gpiod_to_irq, it's the case on amlogic chip.
> so to have possibility to use interrupt mode we need to add interrupts
> property in devicetree and support it in driver.

I would reword this slightly (leaving out the amlogic specifics):

"""
Add support for getting IRQ directly from DT instead of relying on
converting a GPIO to IRQ. This is needed for platforms with GPIO
controllers that that do not support gpiod_to_irq().
"""

Other than that, this looks good to me and now it's clear that it only
affects the DT path.

Reviewed-by: Kevin Hilman <khilman@baylibre.com>

Kevin
