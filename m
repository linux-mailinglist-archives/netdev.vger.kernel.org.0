Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2250821923
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfEQN0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 09:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbfEQN0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 09:26:46 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C8420833;
        Fri, 17 May 2019 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558099606;
        bh=L1T/CjI2CXrURC2xwi9wBISFCiQw8PtNr3cvrnKls5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TIzksbOW7giCcM+++rVfSgWMogXCiWutl93YyWFUw5XmIPxqpco5nySQVyAlrYERV
         SsNVuubXH5KuDqNkMyQiftrGolKjit6RlWB2p40xlxCyfweUGPROqLX0iDD8fC7IIR
         WGvdBE0GY12X5Cq+P7nl1KaF8bVxkMFrCwtLeNEg=
Date:   Fri, 17 May 2019 21:26:02 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Introduce the NXP LS1021A-TSN board
Message-ID: <20190517132600.GD15856@dragon>
References: <20190506010800.2433-1-olteanv@gmail.com>
 <20190517010450.GT15856@dragon>
 <CA+h21hos=kHRGq089=3Js2pPnW71BBv02rqiMqPcZFe_bzBUHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hos=kHRGq089=3Js2pPnW71BBv02rqiMqPcZFe_bzBUHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 03:05:59PM +0300, Vladimir Oltean wrote:
> Hi Shawn,
> 
> Thanks for the feedback!
> Do you want a v2 now (will you merge it for 5.2) or should I send it
> after the merge window closes?

It's a 5.3 material.

Shawn

> The "nxp,sja1105t" compatible is not undocumented but belongs to
> drivers/net/dsa/sja1105/ which was recently merged into mainline via
> the netdev tree (hence it's not in your tree yet).
> The situation with "ad7924" is more funny. The compatible is indeed
> undocumented but belongs to drivers/iio/adc/ad7923.c. I don't know why
> it lacks an entry in Documentation/devicetree/bindings/iio/adc/.
> However I mistook the chip and it's not a Analog Devices AD7924 ADC
> with a SPI interface, but a TI ADS7924 ADC with an I2C interface. I
> can remove it from v2 since it does not have a Linux driver as far as
> I can tell.
> 
> -Vladimir
