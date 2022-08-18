Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A84598A79
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbiHRRbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244502AbiHRRbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:31:32 -0400
X-Greylist: delayed 104301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Aug 2022 10:31:30 PDT
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF73B69DB;
        Thu, 18 Aug 2022 10:31:30 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0ED321BF208;
        Thu, 18 Aug 2022 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660843888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4Sx8YHiIBk8CDg/pgMG+ASQ6ZfIgiFp1vi8DJgM4Kg=;
        b=iUuy3ghhB26M8dgMWyv6KJtesBVwkIUhOS+cXciT02owrrRbx89Vz5CiQSXLtgt54DTy96
        rbjjbXOYOOAXA9rOZN6o0NASTuEx3hv4XcuCiY455wPktWuXCSeXvSHjOHhGBedeK4/fZZ
        8apXYHi/dOJiKvLBw45ttAQHGCOHXU+SieD+mLT4X+Pd4PNSdMqwUIYxPlE0+zOVDrVgIF
        Zc40pOZLDcZf735Z682VtUaRVvhuuc1fBCSknWKwb/ryvZy4O4WZpnipTznUr4fk1Kmhvq
        pbTLK9PWp1wq/ikXGBd5iu1SopNwr60pvQTG6doKllmreZMu1SsI0PDDYJCM1g==
Date:   Thu, 18 Aug 2022 19:31:25 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Richard Cochran <richardcochran@gmail.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: ethernet: altera: Add use of
 ethtool_op_get_ts_info
Message-ID: <20220818193125.41f08bcf@pc-10.home>
In-Reply-To: <20220818102656.5913ef0d@kernel.org>
References: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
        <20220818102656.5913ef0d@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Thu, 18 Aug 2022 10:26:56 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 17 Aug 2022 11:57:25 +0200 Maxime Chevallier wrote:
> > Add the ethtool_op_get_ts_info() callback to ethtool ops, so that
> > we can at least use software timestamping.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> 
> I think our definition of bug is too narrow to fit this. It falls into
> "never worked" category AFAICT so to net-next it goes.

My bad, I actually meant to target it to net-next, that was a silly
mistake from me...

Do I need to resend ?

Best regards,

Maxime
