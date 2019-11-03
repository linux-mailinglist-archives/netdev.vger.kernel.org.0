Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291EFED1A7
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 05:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfKCEB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 00:01:27 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34695 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfKCEB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 00:01:27 -0400
Received: by mail-qk1-f196.google.com with SMTP id 205so13067151qkk.1;
        Sat, 02 Nov 2019 21:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=SRkLd0edVxqGevzqPBW+HuFTjKCt6OoYiAcmt6g2Zw8=;
        b=bvoCC6ViHEr7oWLqc0Kk9v7kH4HqLubeobIvqXpYyOZgk9CNf6ZaMyKj9wKWfwPuPZ
         xHqtOEg5U/CPpkQsAp6t7lb1lSvOSfmXyVd3/Vo4VLM1RAIKpTdxZdw4SDINZT0JlUIo
         txNX5+zdYqpLdXQFfmwVZEhFZHDFVwIPywcpHUab3FEJGpnNU+9J+WkDq7nkdF503ASy
         H2uQZNagXSAv9kqBJeweMgNbWsFkz+KzeXS/NfoP7OoPo7L6LUYbJdxPLwfkKEbRF/LI
         /aK7cMp7a1DyEgqKVjY9b+UCfHWLlHwtlqUxErOo43EabOjQ7iXPtFJWoReYAkb3Q6ID
         lWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=SRkLd0edVxqGevzqPBW+HuFTjKCt6OoYiAcmt6g2Zw8=;
        b=aJa3J7HD95TP1WJb/t9LX8JbOO2pwKORv/bmTGhuogasopDs/Xj2u5hCWzMtd+W/2D
         A/wfrOvah2TKF4ooFS77Sg8eW5IND8NDl/jqies/rmYk1DcVDrjyP0UHdDubWvU+AXUV
         fuYd3wn9Xu41/Ggy5ziTTWggFMXfhOEAHduNKTVmNdAPixOMBhXhFXmRzXFv2OE7UChH
         Jq5JNLKpPAkkRMydALr4f3DvF8yJ33GhOY0p/TJX63vSIbOlIS3moHooa3kWLzUqCW6x
         QjIg92hchyBNsZUxpsK9B85/Bs8nP/GQgjp7RUJimKE4XZgLf+4Up9et19OoJZjPyTcy
         69EQ==
X-Gm-Message-State: APjAAAWq5Jr/ztZaFNRYnzrvk38GxF76tFT25c7zNOLNX80OW/rKze0u
        lxFNKIPc+IgJ0/pg6WEUlwM=
X-Google-Smtp-Source: APXvYqyg2/eX9fpF5xDs7vmVbzRpqR8gExT5qqTu/eWZjh29Vb6TTMt7U46XK9ePenHEB8knaXERWA==
X-Received: by 2002:a37:a64d:: with SMTP id p74mr13363739qke.285.1572753684708;
        Sat, 02 Nov 2019 21:01:24 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q34sm8434905qte.50.2019.11.02.21.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 21:01:23 -0700 (PDT)
Date:   Sun, 3 Nov 2019 00:01:23 -0400
Message-ID: <20191103000123.GD417753@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix driver removal
In-Reply-To: <20191103031739.27157-1-f.fainelli@gmail.com>
References: <20191103031739.27157-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Nov 2019 20:17:39 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> With the DSA core doing the call to dsa_port_disable() we do not need to
> do that within the driver itself. This could cause an use after free
> since past dsa_unregister_switch() we should not be accessing any
> dsa_switch internal structures.
> 
> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
