Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC9442745
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 07:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBGvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 02:51:21 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:45162 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBGvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 02:51:21 -0400
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id DF21B20164;
        Tue,  2 Nov 2021 14:48:41 +0800 (AWST)
Message-ID: <49f5ecb1ab4ba4b28c875ec1d40aa57991907b0f.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 6/6] mctp i2c: MCTP I2C binding driver
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 02 Nov 2021 14:48:41 +0800
In-Reply-To: <5650511d-f6aa-97a4-ce82-060c2c51afb5@infradead.org>
References: <20211101090405.1405987-1-matt@codeconstruct.com.au>
         <20211101090405.1405987-7-matt@codeconstruct.com.au>
         <5650511d-f6aa-97a4-ce82-060c2c51afb5@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

> > +config MCTP_TRANSPORT_I2C
> > +	tristate "MCTP SMBus/I2C transport"
> > +	# i2c-mux is optional, but we must build as a module if i2c-mux is a module
> > +	depends on !I2C_MUX || I2C_MUX=y || m
> 
> I'm fairly sure that the ending "m" there forces this to always be built
> as a loadable module.  Is that what you meant to do here?
> 
> Maybe you want something like this?
> 
> 	depends on I2C_MUX || !I2C_MUX

Checking here it behaves as intended, this gives mctp-i2c built-in:
CONFIG_I2C_MUX=y
CONFIG_MCTP_TRANSPORT_I2C=y

Setting CONFIG_I2C_MUX=m forces CONFIG_MCTP_TRANSPORT_I2C=m. 

Though I will change it to your suggestion since that's more concise.

Cheers,
Matt

