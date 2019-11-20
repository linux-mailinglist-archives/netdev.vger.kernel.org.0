Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B4D1046B1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKTWqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:46:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40574 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTWqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 17:46:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2so960885ljg.7
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 14:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=W2Gw6S/BSPVYCKQnY+L7IKOKaWK+tHyuQvA9ZefI5BA=;
        b=iSNqsPQ+O9fPHX12ue5MlvZIF3x0xjh9dtBazOIv3QQtkyUdRuB2KmqgWOOcDx2bcm
         pgWvvwmVlE1KrQoTcPoaH/+cXkH9FY9SOToBl4AQEjUpFv1w5jHJwZ7T4z7l66T4Fv/4
         o+F0Sck3frWbhajzq9lV4Cf+8X8E04NE/SmEP87VQbL/31A7B+7WV64xBT8yi5oJf9+x
         KsodNpfTLAqDl9FlvlXwdvHjp4jm4uh9WTrpzXId81qJCBQyhbb6T5QDSPa+x4rbs2lx
         joCi1ARm4ORDSdDGAJ5uG38iCD1N89hZgCLYCgGAI40lSBABCg7+9CX/3EfvN6H3zcD3
         eSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W2Gw6S/BSPVYCKQnY+L7IKOKaWK+tHyuQvA9ZefI5BA=;
        b=ixnNms6apsNcQQv+enr8YIIsR9EywjvoUlnXgYOjWPKnEVofLhto/oHyyHkkvb18s3
         76FE6ls65dkD+wl7gKvNKETSeDFPE9lKfl3kjH2Q1Grwm5hfSTigAlZo2NQBXSWBABul
         gELwHW5dBzhUzIvfmhafH/LRLddtPRTcUr4qwVtlkTjzzxbXqogp+0y08XuVzzfaIMIB
         AZbH0/uGg1FyH4xIkGL2sdAn0lyo5iYTQZnMIx/EjcZq4vjoH+b7f4OjN8pryU/Z42d/
         vOstp4UNN4J9tMcxKxXSId8iZu14bVh0dPFSwVBgwUjSVvuia4L8mLgGpuZxqxqtUgka
         Z4nw==
X-Gm-Message-State: APjAAAUTmwhuXb6MEGkmdBhdHzZpi8u5uDa+1IMsa7mNa0plFN7YjUn+
        9cqXTI9YivexMzOv2X4LGG3Y7g==
X-Google-Smtp-Source: APXvYqxMD4SWNda4IPMszx8PfscU7od0KazjamxSZNp8y5mxqguYMq00GFrGo83Aqpyxr35XpvEeNg==
X-Received: by 2002:a2e:9d84:: with SMTP id c4mr4556292ljj.187.1574290009275;
        Wed, 20 Nov 2019 14:46:49 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d24sm222563ljg.73.2019.11.20.14.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 14:46:49 -0800 (PST)
Date:   Wed, 20 Nov 2019 14:46:32 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: add some quirks for GPON modules
Message-ID: <20191120144632.0658d920@cakuba.netronome.com>
In-Reply-To: <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
        <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 11:42:47 +0000, Russell King wrote:
>  static const struct sfp_quirk sfp_quirks[] = {
> +	{
> +		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> +		// incorrectly report 2500MBd NRZ in their EEPROM
> +		.vendor = "ALCATELLUCENT",
> +		.part = "G010SP",
> +		.modes = sfp_quirk_2500basex,
> +	}, {
> +		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
> +		// report 3.2GBd NRZ in their EEPROM
> +		.vendor = "ALCATELLUCENT",
> +		.part = "3FE46541AA",
> +		.modes = sfp_quirk_2500basex,
> +	}, {
> +		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
> +		// NRZ in their EEPROM
> +		.vendor = "HUAWEI",
> +		.part = "MA5671A",
> +		.modes = sfp_quirk_2500basex,
> +	},
>  };

nit: no C++ comment style?
