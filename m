Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B296EFF67
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbjD0Chx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjD0Chw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:37:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8561FE1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89EF7617E7
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C5EC433D2;
        Thu, 27 Apr 2023 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682563070;
        bh=rUrGk/FeDG3sy/XqWwE77G26Us9cu9ldY2d82Dar2Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iauA7+pX/8SnY+wdILO4CPHwNAx1OaFEyQNgVE/EbklmhkQUitDvs5ubeMarY2TVc
         EwE4VCZMhrIHUlMbBG6UttYK+dspASHSOw02INPiZWHo172guNmiPaDGnNxe40Z9cw
         wF+0QKdvkzqtuMmvNMzY0d0TplinlCxNe+cBQH8pfEx8gvZxNy7oHayhxFM9WqPJ9a
         JySPNSbfpR6Ib/KSxPXLieS9YG9O3uWsfP7RHa+Koh/XXlvZpNlLWzRgZkjQ227lPA
         uZ/8jxgWECBPAe5xRiNNXgnx/1byqsuZoUntwiu4aWMvgJHWr8UFCPfdSjJps947Al
         yybhn6BkJwLWA==
Date:   Wed, 26 Apr 2023 19:37:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v4 3/5] Add ndo_hwtstamp_get/set support to
 vlan/maxvlan code path
Message-ID: <20230426193749.70b948d5@kernel.org>
In-Reply-To: <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com>
References: <20230423032835.285406-1-glipus@gmail.com>
        <20230425085854.1520d220@kernel.org>
        <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 22:43:34 -0600 Max Georgiev wrote:
> > On Sat, 22 Apr 2023 21:28:35 -0600 Maxim Georgiev wrote:  
> > > -             if (!net_eq(dev_net(dev), &init_net))
> > > -                     break;  
> >
> > Did we agree that the net namespace check is no longer needed?
> > I don't see it anywhere after the changes.  
> 
> My bad, I was under the impression that you, guys, decided that this
> check wasn't needed.
> Let me add it back and resend the patch.

My memory holds for like a week at best :)
I was genuinely asking if we agreed, if we did just mention that 
in the commit msg and add a link to the discussion :)
