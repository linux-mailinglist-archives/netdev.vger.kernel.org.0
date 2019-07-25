Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1315757B4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfGYTSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:18:31 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44753 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfGYTSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:18:31 -0400
Received: by mail-pg1-f170.google.com with SMTP id i18so23510227pgl.11
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aDAwL5Cdh2i3pmbUFIvBo+BF+mpIwQmrHQFud17yoiU=;
        b=KvdIQeU2WyS6Rj3t/8oofxoNMqb33x+F//0Oquki/4v1RGRk66CPLW2JcPQSNb3LoB
         j39AP945iuSEjh/0KnJc7ItgLIB4NYrQQkf+mm9V9hoGN0RJI0vQeKWGg+lsxmN810TR
         X/KUiY77g1CY+6JhePmWhdmXMEdRoHCz8yciY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aDAwL5Cdh2i3pmbUFIvBo+BF+mpIwQmrHQFud17yoiU=;
        b=nyxVkyVO4t9pMrku/Vz6ANWR3ol/mOFEsN+OpW3NEkJX96s86hxQ9vzinRGHdRA5hH
         AQcL7yMPgW+gvcrRn/BSJTxCQL0fZV2/p+k7Kuzxa8sdLkoJvhaFDTcGFX+F1NHL6Q2V
         VreyIbX2LewUtye0lWJaD4lrDtkBDk//nIJXGqCy9vBhbOEjbmroo7pFd6/7kzn3EPkz
         0ZqerPA8nALb3qNv0+P4EppIX1k4QaDQx87T/UaOLHlUF0p8cFkak1eioHj4hPFA5tiz
         9eAeOpRhWGRHiiS9+iLTrf3IYtTYGVqfHPKEdQSfwgaag8xVZFEHJ1/D/4SGyqU3t4fQ
         xYQQ==
X-Gm-Message-State: APjAAAVtGIMMBYQHDpRLOwm/kG/xNeT9spwU3o3cgffQr4guwDZlOhCX
        mMV0gnnTHRnvCmLaWtW1M0W1uw==
X-Google-Smtp-Source: APXvYqyCcBWmg6tvDPsrLgmH0sYeAY28oba+EPqncQmOdGW/32zXvf1WUPg3MaIyYU4E6Pss9CvKVw==
X-Received: by 2002:a63:30c6:: with SMTP id w189mr84852127pgw.398.1564082309986;
        Thu, 25 Jul 2019 12:18:29 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id a5sm43642552pjv.21.2019.07.25.12.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 12:18:28 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:18:25 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [RFC] dt-bindings: net: phy: Add subnode for LED configuration
Message-ID: <20190725191825.GF250418@google.com>
References: <20190722223741.113347-1-mka@chromium.org>
 <20190724180430.GB28488@lunn.ch>
 <20190725175258.GE250418@google.com>
 <20190725183441.GL21952@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190725183441.GL21952@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 08:34:41PM +0200, Andrew Lunn wrote:
> > As of now I don't plan to expose the label to userspace by the PHY
> > driver/framework itself.
> 
> Great.
> 
> With that change, i think this proposed binding is O.K.

Great, thanks for your feedback!

I'll probably post a new version with actual code next week, unless
there is more discussion before I get to it.
