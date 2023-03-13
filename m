Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717426B84D5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCMWgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCMWgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:36:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931462D93;
        Mon, 13 Mar 2023 15:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA75761529;
        Mon, 13 Mar 2023 22:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C31C433EF;
        Mon, 13 Mar 2023 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678746955;
        bh=R62k9wBVKwi0o0KcsGDEp2WbFSlossckJX2NwULi5Wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EIlH5Asqt96twj4Et5WF/rSPdir75+VQdOZyLzQQFW29dDovVka1X/redgaMCrA2j
         ++oBA4f7HWjKzE1XYJA6YN/zG7dZhoNBsqq+b4u+Ld8S5MYilvGwu7Cs+SrtAT2PMy
         BwE92I2LdDt/2IsKky5i1xiXJYpKjXtwxli43HJ+uz9cEXYGw7Ghau4DgxgcUvYsG0
         lkAAJLNyOxArH79UbXj58slnAYPErjrReoK40Wmd0LPKMnboQnxQIdeszMp74nyAGS
         cXLRYJDwOqAIeJ9eb8VQINX0KlPmKCgm5i8oQ4gOiNb9vabw5/pGQHpIqvKChW1FL7
         wZwiiUNQTI7tQ==
Date:   Mon, 13 Mar 2023 15:35:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v3] net: phy: micrel: Add support for
 PTP_PF_PEROUT for lan8841
Message-ID: <20230313153554.712a537a@kernel.org>
In-Reply-To: <ZA6LGJZ2nWunT1xE@hoboy.vegasvil.org>
References: <20230307214402.793057-1-horatiu.vultur@microchip.com>
        <20230310163824.5f5f653e@kernel.org>
        <ZA6LGJZ2nWunT1xE@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Mar 2023 19:31:52 -0700 Richard Cochran wrote:
> > Richard, does the patch look good to you?  
> 
> Yes, looks reasonable, mostly hardware specific.

SG, thanks!
