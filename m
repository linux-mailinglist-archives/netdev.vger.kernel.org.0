Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDBB30A1
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfIOPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:08:51 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39797 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfIOPIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:08:51 -0400
Received: by mail-ot1-f66.google.com with SMTP id n7so33472682otk.6;
        Sun, 15 Sep 2019 08:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C6EkUSBGxn1R7oOH+qnMGCqOv8DTwH83uwm3gCMUPek=;
        b=QYQT3Yfoiek3WOafMrUzEHG9mCwIXDfsSsvNHrmuA7pRI5NxstrJtjyARcui1TKN3U
         3CkBFFXJt3QEgsZK8jpUC7jpwSusZCNYjbVw4gV/Av3mJuB6k7o+n2b1mETBOu2ahkF5
         hOnDDMwyp5fTabqleQ56+lpvr8JyWwnCTraAb7sRbtkbw6M36qfZTQde3/QbzQbMXDov
         kIRUS0qsuFzLJ+9TNdC8AakgoMLMijAmNmXLkwnQzaB+PVC+8eZYD79gdr2MQ1f0VqQv
         sgHUo4fcO63fFkubiOPeYe844nmU+fs3ZNVJlaXNmrqT11hOhccymXyeQhrCLYb8WQxG
         JEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C6EkUSBGxn1R7oOH+qnMGCqOv8DTwH83uwm3gCMUPek=;
        b=QESUxS+DCfk4c4eZ0GSZQUD/u6L0UIwYnuB7wPxffOetfcj6vKWCv54HoBfAlB5UKr
         THvem/DP4A6QSlF2XC/Clb6G7Y9T72V4Hug2OMquheVIbcWFOWATulYLbgXuBkyqLpj9
         LKkVPIhRBM0ZFsDWkecuY5JSXNciK33oAcXnAjaoPEiITPnzdnM3zuNZENU4WmIzH+ah
         LUcRipvRK212R+HyvXu0MTFOqKzPm9jAhlbYNgdPn/bmRtGLPAerKUADOb7Z/B8+us+6
         R+1hfNMM6TBQIEYdP4dnJZpmqGiL+QxsblHCXVlGIT0ahQ66X4/yzLxPvuHM8pkuBxIH
         5bzQ==
X-Gm-Message-State: APjAAAUCQ6jrVcl/QzvAegddocVBKPGcA1E8EbuZD2jpNM454Ia6C+ik
        52xdJdf6z820EQolM6xmnpKHvg+PsDY=
X-Google-Smtp-Source: APXvYqxNK/G4wvb1N6PsJVqrzZkYqUcIz0TOc2yzecmrjXP879iKpc385XO5a5BBPTYV/DRkMMbWgg==
X-Received: by 2002:a9d:5e07:: with SMTP id d7mr5434316oti.88.1568560130295;
        Sun, 15 Sep 2019 08:08:50 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y137sm3073723oie.53.2019.09.15.08.08.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 08:08:49 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch, mkubecek@suse.cz
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
 <20190912162812.402-2-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <3d8855e9-4ca5-d17e-0a66-6c2e0f20fedb@gmail.com>
Date:   Sun, 15 Sep 2019 08:08:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912162812.402-2-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2019 9:28 AM, Alexandru Ardelean wrote:
> The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
> this feature is common across other PHYs (like EEE), and defining
> `ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.
> 
> The way EDPD works, is that the RX block is put to a lower power mode,
> except for link-pulse detection circuits. The TX block is also put to low
> power mode, but the PHY wakes-up periodically to send link pulses, to avoid
> lock-ups in case the other side is also in EDPD mode.
> 
> Currently, there are 2 PHY drivers that look like they could use this new
> PHY tunable feature: the `adin` && `micrel` PHYs.
> 
> The ADIN's datasheet mentions that TX pulses are at intervals of 1 second
> default each, and they can be disabled. For the Micrel KSZ9031 PHY, the
> datasheet does not mention whether they can be disabled, but mentions that
> they can modified.
> 
> The way this change is structured, is similar to the PHY tunable downshift
> control:
> * a `ETHTOOL_PHY_EDPD_DFLT_TX_MSECS` value is exposed to cover a default
>   TX interval; some PHYs could specify a certain value that makes sense
> * `ETHTOOL_PHY_EDPD_NO_TX` would disable TX when EDPD is enabled
> * `ETHTOOL_PHY_EDPD_DISABLE` will disable EDPD
> 
> As noted by the `ETHTOOL_PHY_EDPD_DFLT_TX_MSECS` the interval unit is 1
> millisecond, which should cover a reasonable range of intervals:
>  - from 1 millisecond, which does not sound like much of a power-saver
>  - to ~65 seconds which is quite a lot to wait for a link to come up when
>    plugging a cable
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
