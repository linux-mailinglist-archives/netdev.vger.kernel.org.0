Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288EB19F8E2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgDFPak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:30:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43913 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgDFPak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:30:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id a5so13113390qtw.10;
        Mon, 06 Apr 2020 08:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=9/Lib8Nq4WE3nzqxkLUu8jj6vOsH3bpD+SC3KKN41nc=;
        b=pFCBH4F2G8fB7fwOgWqeggA8ElmT6bE/jQq4+FqBZ76KOjPAnwjx2gYjZq31SNxnlC
         ZWmkgoeZ12YbyySRVw4EvfgBjdK3BQWFy1W01y5OzW14SCCasU9x4xzgDc1QHAgztanC
         RRsneb/6MPVBFwmus96LGEZWNKSvikRIEwlaiD+5aJx5kE8ZxR/wkLxkRYYcLzwpWkVz
         Htg9x6X7GIy5+Ja2ZHyo37kXYHSeyrGt5N9XaSf07KezhHK7OkAqgjYMsYrHm3dk03Xx
         u0m1gcL4C9QqpfACjvRZLqPPWj+oYawwNlD3fFIdO/QL03ZLJdA5sWc1XEqZ1b28ECuj
         bmjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=9/Lib8Nq4WE3nzqxkLUu8jj6vOsH3bpD+SC3KKN41nc=;
        b=SaA+cBrKf7TjG/yYpznDFeKtes0KwV5GnyzRRk/2dEgDAsmc4VXxKNldT2LvJxIR9+
         nF+alQ7WPeBZEfDI9ojBxLOXgc3FkksUVs/0o4w5Ef2X5eqM21zUngi+XkhMgNIZS3EL
         gA6/2GfPnMpSgzfor6JMRjio7PG12/DngWG+GOshumMjQlzWngwc1osHYzCoUmvWnUSM
         8lc2oriUyCfGaWdt86SYhH42yqvkwDP0qfbz5ak05ei63m8NkwnPAbc5Yt+h53M5A3PD
         7Pzhw8w4d6HAaMqtaDnSn2p0jgBfQNWYH1BDjHS2IhxaT9zh3Zws059Sd3neAwITqq8h
         aPHA==
X-Gm-Message-State: AGi0PuZk43ITmVojlXPLLIiNMFn7Y3lw+A9GZR97TjsQpysVL+RDo9Hk
        3j+NbCWceHwfK8F/Ddj6Wts=
X-Google-Smtp-Source: APiQypJEA17uSHU7j8QjRM33A4/KndAa3GCr50fugSNB45LZ2dRFE57vuQ3xsDxXQ3pdaJFiQ933RQ==
X-Received: by 2002:ac8:6686:: with SMTP id d6mr21391251qtp.149.1586187037912;
        Mon, 06 Apr 2020 08:30:37 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j15sm14752351qtr.40.2020.04.06.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:30:37 -0700 (PDT)
Date:   Mon, 6 Apr 2020 11:30:35 -0400
Message-ID: <20200406113035.GB510003@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Do not register slave MDIO bus
 with OF
In-Reply-To: <20200404213517.12783-1-f.fainelli@gmail.com>
References: <20200404213517.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Apr 2020 14:35:17 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> We were registering our slave MDIO bus with OF and doing so with
> assigning the newly created slave_mii_bus of_node to the master MDIO bus
> controller node. This is a bad thing to do for a number of reasons:
> 
> - we are completely lying about the slave MII bus is arranged and yet we
>   still want to control which MDIO devices it probes. It was attempted
>   before to play tricks with the bus_mask to perform that:
>   https://www.spinics.net/lists/netdev/msg429420.html but the approach
>   was rightfully rejected
> 
> - the device_node reference counting is messed up and we are effectively
>   doing a double probe on the devices we already probed using the
>   master, this messes up all resources reference counts (such as clocks)
> 
> The proper fix for this as indicated by David in his reply to the
> thread above is to use a platform data style registration so as to
> control exactly which devices we probe:
> https://www.spinics.net/lists/netdev/msg430083.html
> 
> By using mdiobus_register(), our slave_mii_bus->phy_mask value is used
> as intended, and all the PHY addresses that must be redirected towards
> our slave MDIO bus is happening while other addresses get redirected
> towards the master MDIO bus.
> 
> Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
