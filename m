Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4101460639F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJTO4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJTO4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:56:14 -0400
X-Greylist: delayed 2654 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 07:56:12 PDT
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E3A491E7;
        Thu, 20 Oct 2022 07:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iYZGKo2r/D10Kc3WGxW6zEism6QXYhH2VU1htaM1CLQ=; b=ix7CQyJHDT6ecZglnVPBW+pahc
        DRvjeNPfsSKMN012azIjvTGtyR+Y/PtRVCTYwiiAr5yEXT2Wi0lcnCO78P2oZdP27dR9BehPEN3cW
        ePbMcxdMizVi2o5QB0VIV0y8D9eP+N0JSCfkohXyYStG7doTt2KEqIXqfC39rNTtK6C0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1olWGq-000Cfo-Ri; Thu, 20 Oct 2022 16:11:40 +0200
Date:   Thu, 20 Oct 2022 16:11:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <Y1FXHDHxD4w7v3d1@lunn.ch>
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 07:23:26PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/19/2022 1:35 AM, Yoshihiro Shimoda wrote:
> > Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> > ethernet controller.
> > 
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> 
> How can this be a switch driver when it does not include any switchdev
> header files nor does it attempt to be using the DSA framework? You are
> certainly duplicating a lot of things that DSA would do for you like
> managing PHYs and registering per-port nework devices. Why?

Hi Florian

It is not clear yet if this is actually a DSA switch. I asked these
questions a few revisions ago and it actually looks like it is a pure
switchdev switch. It might be possible to make it a DSA switch. It is
a bit fuzzy, since it is all internal and integrated.

  Andrew
