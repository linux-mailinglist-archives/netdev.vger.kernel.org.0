Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D2D5C503
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGAVcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:32:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40574 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfGAVcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:32:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so7172641pfp.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C0X5jiAvybtGT/loYYHyiQvKoV7rqikrQaBhLQSGbp8=;
        b=jjoJbGBa9GzeNgQ3WKQDcqFI3qHbmDaSRISWXWi5agU39APN5qW/NevphRSzkpKX2K
         LW8ntAaMTXlZgX9NTCrRCgjUyTd4lEDag+fWRV7IHVSxIIsNBbo7GspgUQNh+U0UpBO0
         gt5zy8Ym4peEewD43T2gz6Gy0WIlf/jYhN3ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C0X5jiAvybtGT/loYYHyiQvKoV7rqikrQaBhLQSGbp8=;
        b=EhP4P2pbD6Or0byokz7+n/7CVSGF41/BjP1SBy2SAXPZtPMP4s3QNej4GAs0C8HfNz
         3XXZrXBe/GPij7RTFEEBJhNfmhotXpy0PmCUUjEqxM4g3QsGr9G9qGJdg1Ko3gUPoyyK
         +5PyP9dqWEKy/G8AsbZJMpj9wcc9uMwQWpdXbehq+O1QxiyUd+3tr/QEy6o86D+vjXr6
         nE4WwXTbfy3LX172M0YMp1cT15+F+BQDNjZ+UPXp/sZyUAc7PLNGV28LAf9YOw9xxuUY
         1OvOmrbh9sqGw8pjN4aZeJPjBm6y3rkSnaF0GJhNnQE2noemmUoMPwTokxml9Y8s+wpj
         tz9Q==
X-Gm-Message-State: APjAAAW9zdv75Zjg8orNZJ5sdHha6WgKYq9Ym78raRlybX19QC4y8sAy
        C8pcMHBaZOzUKSyTNsNHe6I6gw==
X-Google-Smtp-Source: APXvYqwkzkzcV9PbHxj/QnYdd5yERCuo0JSsX2rAk8NaM2SJlwiKj/eA3KncDCGFLbDSAnHU0k+Kkw==
X-Received: by 2002:a17:90a:b78b:: with SMTP id m11mr1548372pjr.106.1562016758601;
        Mon, 01 Jul 2019 14:32:38 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id q19sm13254119pfc.62.2019.07.01.14.32.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 14:32:38 -0700 (PDT)
Date:   Mon, 1 Jul 2019 14:32:36 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190701213236.GB250418@google.com>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org>
 <d2386f7d-b4bc-d983-1b83-cc2aa4aec38b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d2386f7d-b4bc-d983-1b83-cc2aa4aec38b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:43:12PM +0200, Heiner Kallweit wrote:
> On 01.07.2019 21:52, Matthias Kaehlcke wrote:
> > The RTL8211E has extension pages, which can be accessed after
> > selecting a page through a custom method. Add a function to
> > modify bits in a register of an extension page and a few
> > helpers for dealing with ext pages.
> > 
> > rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
> > inspired by their counterparts phy_modify_paged() and
> > phy_restore_page().
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > This code might be applicable to other Realtek PHYs, but I don't
> > have access to the datasheets to confirm it, so for now it's just
> > for the RTL8211E.
> > 
> This extended page mechanism exists on a number of older Realtek
> PHY's. For most extended pages however Realtek releases no public
> documentation.
> Considering that we use these helpers in one place only,  I don't
> really see a need for them.

I see it as self-documenting code, that may be reused, rather than
inline code with comments.

In any case I'm looking into another patch that would write registers
on extented pages rather than doing a modify, if that materializes I
think we would want the helpers.
