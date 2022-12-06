Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A653643E30
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiLFIOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLFIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6099DF08
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58050B816A9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5511AC433D6;
        Tue,  6 Dec 2022 08:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670314441;
        bh=TYNvRkpMznW+2aT1yJSGMMVnhzimhbp2xqCEZcUrvAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZKCQgZrKbBlsTTvyUDzGfcxTnaMIb9QBBSarzirscdjdZeWRzS8ib/Oc9w7j1CVn9
         qBCfgf/ZW9P6xNqTdagZIyXbaq8hqCF+p/+liGe3CPjoIJWNMxAzochu1eTEUVZ2PK
         V1MjblL4KqSyap/1cqI7gUWHsWzpW/imJS/EH0ednTeYk17InSvJuYj3Dd3/qNil/K
         NYLfGKCsqCK1HRRB7OJHzcBXo3TR+lXozwwO5QhIGvILAJW4n142oUpk5I2rTJy8Pc
         YO2Xxn7IKddYWiJPogoRm+uE19S2pf61HoLJcRq0Zc/km2hOhsteqVZGAqBOMITEOj
         s90a4heYSgt1w==
Date:   Tue, 6 Dec 2022 10:13:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
Message-ID: <Y475xGp2+AYzDpu+@unreal>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <Y4424LOnXn+JXtiS@unreal>
 <13ce5067-6e6b-8469-a20f-9e83793b2022@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13ce5067-6e6b-8469-a20f-9e83793b2022@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:55:16AM -0800, Shannon Nelson wrote:
> On 12/5/22 10:22 AM, Leon Romanovsky wrote:
> > On Mon, Dec 05, 2022 at 09:26:25AM -0800, Shannon Nelson wrote:
> > > Some discussions of a recent new driver RFC [1] suggested that these
> > > new parameters would be a good addition to the generic devlink list.
> > > If accepted, they will be used in the next version of the discussed
> > > driver patchset.
> > > 
> > > [1] https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
> > > 
> > > Shannon Nelson (2):
> > >    devlink: add fw bank select parameter
> > >    devlink: add enable_migration parameter
> > 
> > You was CCed on this more mature version, but didn't express any opinion.
> > https://lore.kernel.org/netdev/20221204141632.201932-8-shayd@nvidia.com/
> 
> Yes, and thank you for that Cc.  I wanted to get my follow-up work done and
> sent before I finished thinking about that patch.  I expect to have a chance
> later today.
> 
> Basically, this follows the existing example for enabling a feature in the
> primary device, whether or not additional ports are involved, while Shay's
> patch enables a feature for a specific port.  I think there's room for both
> answers.

I suggest to continue this discussion in Shay's series.

Thanks

> 
> sln
