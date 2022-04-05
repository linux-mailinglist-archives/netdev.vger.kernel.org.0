Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78B84F4560
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356953AbiDEUDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384246AbiDEPOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:14:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A0E1AF3E;
        Tue,  5 Apr 2022 06:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mGMxaI04fi2rfMsZ7XkzQpBo/JY88ZvlXCI1clOCHlY=; b=E36doV9qxOO/pwTzU5pEA7irOI
        tJ1JtQF9Y1F8a0dDxglHRE1OaiEO3lOuLAwxewZ2ROjyYTOo9rU5PVK2qvEGK/6IXC6IRPr9C9aVx
        cWQ2mdwVvAomiwtAudK3UtKhhDLprdYHhdeSs4DZN3P/sBGXD745znUGFtm0LfOr5qc8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbjF3-00EFiK-8s; Tue, 05 Apr 2022 15:29:05 +0200
Date:   Tue, 5 Apr 2022 15:29:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Michael Walle <michael@walle.cc>, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <YkxEIZfA0H8yvrzn@lunn.ch>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc>
 <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
 <877d83rjjc.fsf@kurt>
 <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc>
 <87wng3pyjl.fsf@kurt>
 <defe77d9-1a41-7112-0ef6-a12aa2b725ab@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <defe77d9-1a41-7112-0ef6-a12aa2b725ab@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Yes, the limitations described above are exactly one of the reasons to
> > make the timestamping layer configurable at run time as done by these
> > patches.
> 
> Seems like PHY TS support belongs to HW description category, so could it be device tree material,
> like generic property defining which layer should do timestamping?

Maybe. Device tree is supposed to describe the hardware, not how you
configure the hardware. Which PTP you using is a configuration choice,
so i expect some people will argue it should not be in DT.

   Andrew
