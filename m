Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB111E7F8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfLMQTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:19:04 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37299 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfLMQTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:19:04 -0500
Received: by mail-lf1-f66.google.com with SMTP id b15so2374429lfc.4;
        Fri, 13 Dec 2019 08:19:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Spg0GfwWFlnRUw0lvoa6ReBLhxIzcCxpK224qhBQrwk=;
        b=fS2w9fx2/qyRZCSQ7ld1Lck5W9YGKEyko/GaYYX6zDuKFTKxUOCu6aHpYPM6/ts8A1
         ul7fUEDNoCcdtsiQ973+hkTLseRh5wv2ZkeDw8YIXdSXWuuYuZUSAMJhvzUzuOO/zsLm
         Akr89PDzpaRXp4ZB1mtf9yAGE6gi4vmouWVNWufSAfxFI0BqZYx7ogKVR85I3YL6MNWQ
         b35KglaacnJtkFnNl0XKLp6wHNfQ7L51T5Q3TuleAMkidmYaAl+ytGgw/SsI+FUWRcrX
         he4K41jJPHcdEfOP4sC404HHTi8VyA7hAAqGyxelvVh2yGjivw4B051wGzzM2refoJKd
         E+RQ==
X-Gm-Message-State: APjAAAW3GMI8WnEDkOixPA7WoyKNLgiX4I2MXt8cYeJ72Eb69awT/SEL
        3qZojReauFarRlyqmFXAOn8=
X-Google-Smtp-Source: APXvYqxnVkGEyfViuTjx4mMxFXlrRlIx6//9d0OuQRcfhBx2KniHpTnXbEebHTcjKF/40vT+3FGIaw==
X-Received: by 2002:a05:6512:21d:: with SMTP id a29mr9741453lfo.186.1576253941800;
        Fri, 13 Dec 2019 08:19:01 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id x13sm4778590lfe.48.2019.12.13.08.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 08:19:00 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1ifnef-0000iF-Bd; Fri, 13 Dec 2019 17:19:01 +0100
Date:   Fri, 13 Dec 2019 17:19:01 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Guillaume La Roque <glaroque@baylibre.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, nsaenzjulienne@suse.de,
        linux-kernel@vger.kernel.org, khilman@baylibre.com,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 1/2] dt-bindings: net: bluetooth: add interrupts
 properties
Message-ID: <20191213161901.GZ10631@localhost>
References: <20191213150622.14162-1-glaroque@baylibre.com>
 <20191213150622.14162-2-glaroque@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213150622.14162-2-glaroque@baylibre.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 04:06:21PM +0100, Guillaume La Roque wrote:
> add interrupts and interrupt-names as optional properties
> to support host-wakeup by interrupt properties instead of
> host-wakeup-gpios.
> 
> Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
> ---
>  Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index b5eadee4a9a7..95912d979239 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -36,7 +36,9 @@ Optional properties:
>      - pcm-frame-type: short, long
>      - pcm-sync-mode: slave, master
>      - pcm-clock-mode: slave, master
> -
> + - interrupts: must be one, used to wakeup the host processor if
> +   gpiod_to_irq function not supported

This is a Linux implementation detail which therefore doesn't belong in
the binding.

I think the general rule is to prefer interrupts over gpios where we
have a choice, but here the current binding already has a
host-wakeup-gpios.

Not sure how best to handle that, maybe Rob knows.

> + - interrupt-names: must be "host-wakeup"
>  
>  Example:

Oh, and please keep people commenting on your patches on CC when you
submit new versions.

Johan
