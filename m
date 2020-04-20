Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC91B0FCF
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDTPTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgDTPTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:19:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99DBC061A0C;
        Mon, 20 Apr 2020 08:19:15 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id ay1so4068190plb.0;
        Mon, 20 Apr 2020 08:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P2OEB7M0ylUcoE1wgndBCjI9OKWAQ2w0wOIcSTBkJC0=;
        b=WnsVyX2mcf3PDNma6HPk6iHi19XrsshqairTcDIuOLhJzXuFEaKv6GRX8l4zFQ++4n
         yH3nCdXSQ75S2X06tdW8XLmqIc7QzyaXIb1/0ro2W7jv9hIGEblQTj8LfpPp3YPPD2QU
         wF03b/qjU1Q9x9ZstHzq2whZs1EYu+h76LDGMHPFzbo23S8vBn3rSd4ZUe3oahSbGLVJ
         BEg7u3Vf9JKr8s8EUiK+yMQTJlhjzdSikwq1ybt90HRmptUoWm1xyzbzqAqTDI7p8NLr
         +Brngh/Ti2JVvCFgmpiklzkrdfEOAubSUIPsQbdDgLAmSP4USivxeQn7wtkNEtI4kybT
         HuRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P2OEB7M0ylUcoE1wgndBCjI9OKWAQ2w0wOIcSTBkJC0=;
        b=IlQCqb48tCbFBctdqbLy+Jtu0wGwucpF8i3pM9Qt2FAgjq58Tlrb4QkhHzkkofZhI5
         mv9+cPX76Yh8pGal8eZfCjmIGSPaC7kvfqckED60VQuvNYfV20gwt80OoMEBJti1cTs0
         5x38d7R1T/OohwKH5hsMPxQzlFmhYOea+UPaT/8lbeK+8+e5nMdeqAErZzk+VT/LePsH
         lqGfmYu2CdmgLSstnqxPJ9OOiJ201J0TEemHDyy8j9k0BBD0leJx+cRDHjLOlcGN7r/j
         yidys1kngbLm0lL85VRl995UoGX86R9zFgAelxF2zHqrNPkFPsWVjyyDskSAajFdgZMI
         wkTA==
X-Gm-Message-State: AGi0Pua2PDCxGmdLoy2+k3kx0gm/apMONXjGuI/g/wwc9LDw90v61W8T
        +V/jNuKh5QHTgq8TaMQNwNA=
X-Google-Smtp-Source: APiQypLFwk9EBj0++4IlA6Ssc0Aau8vBJ3gw57Ph71HZTR6YzcO4A7JJNLdjenqSVkhVbrt1bXBgcg==
X-Received: by 2002:a17:902:a985:: with SMTP id bh5mr7152210plb.163.1587395955364;
        Mon, 20 Apr 2020 08:19:15 -0700 (PDT)
Received: from localhost (89.208.244.140.16clouds.com. [89.208.244.140])
        by smtp.gmail.com with ESMTPSA id y21sm977980pfm.219.2020.04.20.08.19.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 08:19:14 -0700 (PDT)
Date:   Mon, 20 Apr 2020 23:19:11 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [net-next v2] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
Message-ID: <20200420151911.GA2698@nuc8i5>
References: <20200420132207.8536-1-zhengdejin5@gmail.com>
 <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de>
 <20200420141921.GA10880@nuc8i5>
 <3fd53b73-87b3-b788-d984-cb1c719f9e7f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fd53b73-87b3-b788-d984-cb1c719f9e7f@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 04:54:22PM +0200, Markus Elfring wrote:
> >> Example:
> >> bgmac_probe()
> >> https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/net/ethernet/broadcom/bgmac-platform.c#L201
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bgmac-platform.c?id=ae83d0b416db002fe95601e7f97f64b59514d936#n201
> >>
> > Markus, Thanks very much for your info, I will do it. Thanks again.
> 
> If you would use another script (like for the semantic patch language),
> you could find remaining update candidates in a convenient way,
> couldn't you?
>
Markus, could you share the script? Thanks very much!

BR,
Dejin

> Regards,
> Markus
