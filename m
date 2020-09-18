Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F389270167
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIRPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIRPyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:54:47 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4311C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:54:46 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n22so6592044edt.4
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1I1ECJPGCkCa5/9JeyVOe5qKBo9cnMKeRzMsHJ2l/+M=;
        b=cyYd0rQ0Wqpq5crH2RGsvTo8snAMV61CqC5xjUa934X/NZkujy47TtrldzV7ItmyNS
         JORtgDGPYPrMtP/hz0+5JcW0ifVkvCmrCbM3HUY/F1G0mhFSxG8+d3tQUQxDXOigTxdE
         cV2OUmCP1RDI/BZ63WKBrFr3MQRXpBH4D2+bCNSEDIQdcMsdEeDXzA/i+cmeqx5SPFGU
         I1GomANVrXiFiKTiW6mte+jqDk4uJ4LlucUs02pfT7i6BMpWqZl2Ktt802xpYf3meXu0
         JQHJJj77xJcels6WykfyM/Y59ckMnmfbR7s13LGgzJ9k2gT4fVoSJZ+deiiZsx7eCo1d
         tRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1I1ECJPGCkCa5/9JeyVOe5qKBo9cnMKeRzMsHJ2l/+M=;
        b=O59+Em0rJ1dm2iC6QmFNLUl2c0IUQZ6yNyg+QgmBT460E9KDvxa+oW/Lkkyny+JKnD
         +6j+CxrRRwVfsXsuzmNfeEsxBVQrFfkmWM1w7DPU18Ir0TAb6MJ2xUQ3XBHw77ITdQE8
         c0wehw2/jedZumzualqZqXBl5BhMpOyeFwGr9Qv4X+t8aRmeBEIoRgb2xL4tN+UpGj1D
         0Li5lwYlOXgU8CTIBEuGBdCpaQVXpXk54+RIQCqMN5BauLHjU7HipS6+XSYr1w83emcI
         KVZA96f0r22ffvliWfJDnt/uzDBnlCdFXWAFYYW6z/xIU63hqsdgLpn76nutpYQP4rnC
         IHZA==
X-Gm-Message-State: AOAM53153xRaiKqLE2YIl5HDKtwhtAZ8YE6H/DIvim8K8YkqZGmqHK6u
        GdqBlzsfeW7VQH1Sxy71GwE=
X-Google-Smtp-Source: ABdhPJyNt2dntZ3bNHAZYD0iHyhg8uyztVU2DOdl6HoTw8iqTVR9VjXKXCy5XQ8djcvWU/JYVIZ0JQ==
X-Received: by 2002:a05:6402:1717:: with SMTP id y23mr41035880edu.112.1600444485447;
        Fri, 18 Sep 2020 08:54:45 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id j8sm2488470edp.58.2020.09.18.08.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 08:54:45 -0700 (PDT)
Date:   Fri, 18 Sep 2020 18:54:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 05/11] net: dsa: seville: remove unused defines
 for the mdio controller
Message-ID: <20200918155426.rb6mz72npul5m4fc@skbuf>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-6-olteanv@gmail.com>
 <20200918154645.GG9675@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918154645.GG9675@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 05:46:45PM +0200, Alexandre Belloni wrote:
> On 18/09/2020 13:57:47+0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Some definitions were likely copied from
> > drivers/net/mdio/mdio-mscc-miim.c.
> >
> > They are not necessary, remove them.
>
> Seeing that the mdio controller is probably the same, couldn't
> mdio-mscc-miim be reused?

Yeah, it probably can, but for 75 lines of code, is it worth it to
butcher mdio-mscc-miim too? I'm not sure at what level that reuse should
be. Should we pass it our regmap? mdio-mscc-miim doesn't use regmap.
