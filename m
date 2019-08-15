Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287F78F769
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731980AbfHOXIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:08:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40226 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOXIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:08:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so1641869pla.7
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 16:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aydK5txxUKs/Myho4MGL+0JtlzQ+F/Oe6VcJAGtEVeU=;
        b=DGqNtkq+QZbNJ8gLondZzsqW5sfWkZZyqXZuaQesFqbpmHMjjCC1buNdsi1eVFQn/s
         Y42H2QqIDR4pa+h1PNCzYxtr5/KkLcit8ZAlBpuu9SRACodtWA2Yya8g4K2L/+f4RVCC
         mx4xNbhBU6NMX5+GHmEraA/XvkAhAMMIikvjxo2+wXGD9rInnZVSj+519NNPpuZ7dtuR
         tbZyI+AVY2MIJFzeBK+F/wdtmnNcs7q2t2yy/+lONBowFTokItCtvQFMTNVkPFyx86S5
         LD7cTx/iNZd6Q65agb4RVxAKcep+Tf615EL+WMF0MsXSPKb8787c7oHIq73ziFp4rHzx
         ud2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aydK5txxUKs/Myho4MGL+0JtlzQ+F/Oe6VcJAGtEVeU=;
        b=TspamiAyfWyq3Q3sR7bcdZmqVlFAkDH7iT1gyd2T5NvJabSXZlcdSULvarsAa59Pcl
         Ec9rZ9izZ0EQTdahVDnfruiMMXFTs2ybi/KnPyidLDYT7nhuyGRGEcJQGeHcDoH8C8CC
         tRxKDtJa7fnHsyIzufyzTEoSBjo4Fys6MjePjmbkbKN+b6xtgpZuO5Ycxoxsg+wDGChZ
         nn9vmnh38EzayGKp0dsx+dLSvSnMfYDaprDoH+Aw5R0bAQtVaBUi6VJCVaR31/xCvDok
         XpWFWU8fbhdEHPhsHoZoOQf5pmpNR+oYOGetqhXyGYrEiGSN4oBMT3qGIZ/sRLmq/Y1Q
         lA3w==
X-Gm-Message-State: APjAAAXhDKchpXGAcoJNQZ1t2cVkhnVmzQrAhzKiw72WZSqG5x4gR8w8
        YEvo2usQsPeE/ltDbyCxASk=
X-Google-Smtp-Source: APXvYqxBJbqu6PU+ekObxHTVO6iBL59dqOGTkhvcisMXVL/qiQjVqC0R5jXnjnBl2YtujIuIzDSb3Q==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr6362363plf.131.1565910526277;
        Thu, 15 Aug 2019 16:08:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id f72sm2328244pjg.10.2019.08.15.16.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 16:08:45 -0700 (PDT)
Date:   Thu, 15 Aug 2019 16:08:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v6 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190815230843.GA1334@localhost>
References: <20190812144537.14497-1-antoine.tenart@bootlin.com>
 <20190812144537.14497-7-antoine.tenart@bootlin.com>
 <20190814.124939.490620650140226969.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814.124939.490620650140226969.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 12:49:39PM -0400, David Miller wrote:
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Date: Mon, 12 Aug 2019 16:45:37 +0200
> 
> > This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
> > switch for both PTP 1-step and 2-step modes.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> 
> Richard, I really need your review on this patch.

I had acked the v3, but it seems that Antoine overlooked that.  In any
case, this looks good to go.

Acked-by: Richard Cochran <richardcochran@gmail.com>
