Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA05059EE9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfF1Pbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:31:34 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43641 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1Pbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:31:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so5144468qka.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=CLgwoX/FPodf5FxD4M2fSoj+hvpslu4dnyVtaVZWoUc=;
        b=lAYEecr4RlbqSg1LuOyMD+EsKoR1IJ+74r/Q4Ozq7/fDxJKd/yg930LCgb/lym2oFu
         f6YNeSiJIUSjCm0y9H9fGZaKDB9Lc05uf9RgI+gX5GCh0tuLupuyTkq7FLwkIj9qlBfW
         Jvc5uIx0DGuNCPPrR+hlipsEev1k+ZT/fBFxkPIJ4kuckz8ycqopyTZtSoJkZ5DGIRQs
         6Uqbd6p5kRatPSaSu1OuMlQXwFeu8gexLa+x9Juvgyl9n93sapzUqAyKBDd4xoe0Mc18
         dkV4GbGDkkqoj846CwomN3YOBO6IrcveDrbebmXKpT2G0LsWe+ymMDzj+BBRJ4svu/vt
         RJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=CLgwoX/FPodf5FxD4M2fSoj+hvpslu4dnyVtaVZWoUc=;
        b=FDFhM31VCB50jd861KM1xyIeUXvC9N7JKPm2eVNFYT1s8Q04v1L+Zvt6SNh8QQT3Tb
         E5Ta6PDqTyCcX1GaJNAm7AUjT/ppojasaBpku4Fg4nZoAYXbC2GKSd98nx3z97rfekfF
         KjdnIG7G6I7X3PZNVxOmQpRwZ3+8by+pqruayYWILmt0Rl+kPjHIDAxnsxVN15oZOvTr
         zYdewblbsqnyuoGLKLp9fb9ZCkz5gNmVAyH28bUDSDOv0zKwiQaDaUrkNzarc4DjtzoR
         vGUQZyecyaemHDN73DmpmBxtaSrM+sCPDVMcxs98/I6vNxNdCSoDdDar8XyW3YzUolov
         nqvw==
X-Gm-Message-State: APjAAAUmm5YtIp8ssyY8nDGOGiFsWQSeK65dj/YbM+X5ORTtUuyzuLpG
        XkOI66RS5m0dk5CkJbZj+cc=
X-Google-Smtp-Source: APXvYqyNq+W009A2urblprf/n327W4ZNxNVWxP33tZ3xzGIGYeS5X+mWUEPx+I8xrCtcVGFhi/4/Rw==
X-Received: by 2002:a37:a094:: with SMTP id j142mr9352988qke.2.1561735892895;
        Fri, 28 Jun 2019 08:31:32 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d26sm1099217qkl.97.2019.06.28.08.31.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:31:32 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:31:30 -0400
Message-ID: <20190628113130.GB14087@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH 0/5] net: dsa: microchip: Further regmap cleanups
In-Reply-To: <20190627215556.23768-1-marex@denx.de>
References: <20190627215556.23768-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Thu, 27 Jun 2019 23:55:51 +0200, Marek Vasut <marex@denx.de> wrote:
> This patchset cleans up KSZ9477 switch driver by replacing various
> ad-hoc polling implementations and register RMW with regmap functions.
> 
> Each polling function is replaced separately to make it easier to review
> and possibly bisect, but maybe the patches can be squashed.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <Woojung.Huh@microchip.com>

Please copy me next time, as per the MAINTAINERS file.


Thanks,
Vivien
