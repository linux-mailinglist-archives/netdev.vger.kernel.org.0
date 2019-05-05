Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28F14264
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfEEVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:04:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37033 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfEEVEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:04:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id a12so4569717wrn.4;
        Sun, 05 May 2019 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vMH6xa5vG6EX8XBbkBtYslMnAs8BsmMKlqexgkDh3Cs=;
        b=j8faVjn6syF+DgTvcVgaIDAdVkn3kt2ga79YG6xUEfEFy7/IuqkS2r3LXCH6M2Tdni
         vWcShVeoYYblirt7e2oD8i+8WQu6vONcLhRCKxZb7fJECezRixXdTfbs7qk/ah26kScC
         jZYIpudnlqSqcHksltZUlvRo9sZ6qd25zLQmbCgpnY/06MO0CCt0/SPoh6LK7hPRZ8Yb
         duKE5eDstjAcVDdzi0vs1jPupE/z89eXDFGoaF745ZOQDsQowauDnw5L7sF4FKCwd9dU
         0YR4AOYWDI56WP3fx0eD1e/3oRxGCCc6tKluMaSpcpfgkMJVOZhmZlDBIDgV8w421Uw6
         aFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vMH6xa5vG6EX8XBbkBtYslMnAs8BsmMKlqexgkDh3Cs=;
        b=R11AW+2WIaWxPqUL6ZUXeV0rs6cuI/OBg8KgrvS3s7tC6YzA+AvCGwSSCsYoA3x+iW
         eenkEzw9aIRZ5lJPJ6Kv0Wk18dw3x1t4IgGtOBmqB2ieRLqCzOs6OCKUCa5irbupiQR9
         781DfqfeuRl+lufzEusT5M51RiXC6Ud4XHneS2p3JPd+DFuHw0J/5D36hilrRpPynpeS
         2r89w8sqimAkSy23NZ/pw2jKYu0LSerguyCKuBQvVur6PdV2fPQYIEDaUKWscFCXYx5k
         R9JrADI3mw0rKyTvbBieMYqBX26CMXS4GKCRCEvipaCDOXoQVQtFleGGo2UQ0620SJ5S
         JN4g==
X-Gm-Message-State: APjAAAUUMlZl7NyMi4tcEctH48U1Z2wEhK/wJCh5/z/qoUFrUQa7b+fu
        L0uYmum/rto4qkPRESKtegQS0srK/4g=
X-Google-Smtp-Source: APXvYqymDn4fVEB+cwMS7cUK24mGREV7v/jmrInqcZtfqPTQeDh/HqGXGn8YEoadCIsftPLvfLg46g==
X-Received: by 2002:adf:f349:: with SMTP id e9mr6890179wrp.71.1557090243564;
        Sun, 05 May 2019 14:04:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id 15sm12990276wmx.23.2019.05.05.14.04.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:04:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: phy: sfp: enable i2c-bus detection on ACPI based
 systems
To:     Ruslan Babayev <ruslan@babayev.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190505193435.3248-1-ruslan@babayev.com>
 <20190505205140.17052-2-ruslan@babayev.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <468586e7-4ebf-1156-ed61-4c5dca0c0e63@gmail.com>
Date:   Sun, 5 May 2019 23:03:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505205140.17052-2-ruslan@babayev.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.2019 22:51, Ruslan Babayev wrote:
> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> systems similar to how it's done with DT.
> 
> An example DSD describing an SFP on an ACPI based system:
> 
> Device (SFP0)
> {
>     Name (_HID, "PRP0001")
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "sff,sfp" },
>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
>         },
>     })
> }
> 
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
> Cc: xe-linux-external@cisco.com
> ---
>  drivers/net/phy/sfp.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
If we have a patch series touching more than one sub-system a typical
approach is:
- Send series to all persons / lists being responsible for the affected
  subsystems
- Maintainers will agree through which tree the series will go
- Maintainers of the other subsystems will ACK their respective patches
  of the series

I just received patch 2/2. The complete series (cover letter + two patches)
should have gone to i2c and phylib maintainers + lists.

As an additional hint regarding the commit message:
I suppose you added this code to support a specific device. Wouldn't hurt
if you mention which device it is.
