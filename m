Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08A6DB0C4
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDGQhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDGQhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:37:39 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762B3E6B;
        Fri,  7 Apr 2023 09:37:38 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5AE5B20005;
        Fri,  7 Apr 2023 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680885457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cs38AWZaXvov2hg66QXSDXAK60hBBJ7tzduNIYCbxXk=;
        b=PloRps2aBCFffUPMPIHCgUyLu3UeaXja2P4Wl3TvZSFvEGjJ3U/KqqK0kcLVlas3fKU18O
        7uV1js3n7PIfZVNkhojAp6B9CXr7WhbXGsobqEE1eTZ9lRhxbJxbvses0/Fw7WosWHTGCN
        q+iOAO3FBCKBbiJIE6u/Br5i/FkbTODyLqmGIxOYwIgpImiF3ZffUk/5NNfYIgJu4nGa0t
        QOoFuaNCn2/hDkzyYYmbnzMORyHJGlNXtY1cnxXLOwbFX6rM9qdHo5IQjECpxzq4AIxObS
        +6h5NwPhU/gAO+Rh2iWWZ4BjktmyoYqoUs+r9IkFZXwJaZO2YAcPGMl0BiwoYw==
Date:   Fri, 7 Apr 2023 18:37:31 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] regmap: allow upshifting register addresses before
 performing operations
Message-ID: <20230407183731.7c59a518@pc-7.home>
In-Reply-To: <ZDBEFvPKj9A+k+Ag@sirena.org.uk>
References: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
        <ZDBEFvPKj9A+k+Ag@sirena.org.uk>
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

Hello Mark,

On Fri, 7 Apr 2023 17:25:58 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Fri, Apr 07, 2023 at 05:26:04PM +0200, Maxime Chevallier wrote:
> > Similar to the existing reg_downshift mechanism, that is used to
> > translate register addresses on busses that have a smaller address
> > stride, it's also possible to want to upshift register addresses.  
> 
> There were some KUnit tests added for regmap, could you add
> coverage for this there please?

Sure, I will take a look and update the test.

Thanks,

Maxime
