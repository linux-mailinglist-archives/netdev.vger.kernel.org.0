Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B2162A1C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbfGHUHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:07:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37422 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731646AbfGHUHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:07:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id g15so8230203pgi.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Adk3Sp4omK3tII22cu91Argw+pw324+uMJZd/RcTnI=;
        b=M76wxX/tvbAll81joQN1cX2dmf5uHqy3K+qfYhgIyOCaR4E1iHoBNWO+dUwsFK3pR9
         MN17vaD7bQSjxErvFtUFSRAGjB7NX/srUvHyXUn19OeHdftt9niKFDRXQ9e8fIcBWwoR
         fRGSlrPPkJQQkIiUGTzpBgVNLLVc1NETwj1Gw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9Adk3Sp4omK3tII22cu91Argw+pw324+uMJZd/RcTnI=;
        b=rQtEUxJvAr7jsQvxZzAqfJxCY07b4NA0ffjffP/nTulpXJfsjjWpCkyy2SBI46A0x0
         cgLky/YLoAUKoDvp0mM6TQguceSym/CkgNrBpkyx8750gpkhfOmaShoOBgNVAASmmxq8
         hJk1I2N8CuP9ELPSpjc9fmbf8tCMS8e/0xE+UTthRLkz2SliKGMdbfQrtBziAnJF8XvM
         AbzngtCkp1SS7VwVWYKBBN/3aXqePpBRHN9o5YbKcEQ1JqxN4E2IuXx5Q5D6OHxv3RQo
         HbGC8gAidAc1DBxNulx3t4w/uNDnfxBsIqARxbXEC5SHJJTjrWLXTWLtMXJ8seN/+R8+
         47UQ==
X-Gm-Message-State: APjAAAXc2D16+XXQg7WogCoLfu+RR97sX52pSaSrFK42C4i9rXefpke/
        FNuBXakSiijHtqVQ357q3ix96w==
X-Google-Smtp-Source: APXvYqzVaazt1DJiY1ZMsZNK9/WExCcA8j6aGSnlEsUYqdPT0vu+CbjMH5BCOUFNvjpOMCNDw6RSrw==
X-Received: by 2002:a63:5a4b:: with SMTP id k11mr26108786pgm.143.1562616427462;
        Mon, 08 Jul 2019 13:07:07 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id 3sm17335443pfg.186.2019.07.08.13.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 13:07:06 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:07:05 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v3 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190708200705.GN250418@google.com>
References: <20190708192459.187984-1-mka@chromium.org>
 <20190708192459.187984-7-mka@chromium.org>
 <20190708194834.GI9027@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190708194834.GI9027@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 08, 2019 at 09:48:34PM +0200, Andrew Lunn wrote:
> On Mon, Jul 08, 2019 at 12:24:58PM -0700, Matthias Kaehlcke wrote:
> > The LED behavior of some Realtek PHYs is configurable. Add the
> > property 'realtek,led-modes' to specify the configuration of the
> > LEDs.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> 
> Hi Matthias
> 
> Humm. I thought you were going to drop this and the next patch?

It wasn't clear to me whether not introducing a generic interface is a
definitive NACK and tought I could at least post a version with the
review comments addressed. If there is no way forward without a
generic interface I'll drop the two patches.
