Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DFB6DB0BB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDGQgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDGQgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:36:23 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CED35A6;
        Fri,  7 Apr 2023 09:36:21 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E925C10000F;
        Fri,  7 Apr 2023 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680885380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvwaAPHXiDeJ3ZcYVryA8H7RfG5ZYkgToOwvmIB9VWU=;
        b=DsNm9IXZdBoluvPoBb3tVh06QBUWbQ/650eLuEwQ+kI2+u862keOApnH0M5FevOhvOVuFI
        gYkAkD4M0AlgXNan1FiDyBo/xXzP5s6GncHXZjXXqGe1B3to1LYI9YCz1BwcirskJ/I9u/
        rIAoGNnMGPwStScaO7EcqTsM/bBRnByViUyvMCSEFjEHaOnaSE5yJfUMO5D2nR38yD87J9
        MbEHQ4Vm4SLl0AYcp66plRwe8KavXo8d7OoJ5zpBoBxp0OpvtM5qcYj3r1oA0ag+CMkzLb
        BymD2G1zJtoz9F68BSRjnUE41vlKjWvgdo4+y3AdChLMfRPRNYJU7YDG2/wG3Q==
Date:   Fri, 7 Apr 2023 18:36:03 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] regmap: allow upshifting register addresses before
 performing operations
Message-ID: <20230407183603.1243bceb@pc-7.home>
In-Reply-To: <ZDA9vafqY0j0NhT3@euler>
References: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
        <ZDA9vafqY0j0NhT3@euler>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Fri, 7 Apr 2023 08:58:53 -0700
Colin Foster <colin.foster@in-advantage.com> wrote:

> Hi Maxime,
> 
> On Fri, Apr 07, 2023 at 05:26:04PM +0200, Maxime Chevallier wrote:
> >  	.reg_stride = 4,
> > -	.reg_downshift = 2,
> > +	.reg_shift = REGMAP_DOWNSHIFT(2),
> >  	.val_bits = 32,  
> 
> Looks great! Thanks. I tested this with a merge of net-next and
> regmap-next + this patch.
> 
> Tested-by: Colin Foster <colin.foster@in-advantage.com>

Thanks for the test !

Maxime
