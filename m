Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72BA4CAC9D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbiCBR4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbiCBR4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:56:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7ACD0496
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 09:56:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEAE0B820E4
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 17:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A7CC004E1;
        Wed,  2 Mar 2022 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646243766;
        bh=qIxb++kouzMcrzlYZuhQiPF5Q2E4wEQfCoQfjOstD1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ihi05XeaFfIeNbZryb6F7D2GnZeGfvh8ufpm4EF/HX8xC9Mer5e59QBR9WMT4ZXY6
         jHyWpLd/tiAYdBMX9XbuDsGzSLOhWgjJ8QiE+EU3FQLe8ZCGYO49rqmjsCxSh09Npa
         FF9JXC/mOrRmApZHMC4n9q7g3ecfx79/o0GWaLkfj6mvK6T5EGvkAOq+YecgcIACIl
         sPzzqx9NXldPYpO0nrgElyCm2GxrVyNGKzvaJI7SeSPKQn2aGC1J5y2r4lnlbJI0lC
         +O0qE/SH5JD63dkd1VJb/Y1st7LVoUQ9x6cVdM5OnYz0OPBU6gtWvYLpR8AgP80Ks1
         xyjDnPng/TZVg==
Date:   Wed, 2 Mar 2022 09:56:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
Message-ID: <20220302095605.137b7b42@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220302164800.fdfnmutc7f7zb3ek@bsd-mbp.dhcp.thefacebook.com>
References: <20220228203957.367371-1-jonathan.lemon@gmail.com>
        <20220301182153.6a1a8e89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220302164800.fdfnmutc7f7zb3ek@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 08:48:00 -0800 Jonathan Lemon wrote:
> > This one's tagged for net-next - do you intend for it to go to net-next,
> > or is that a typo?  
> 
> I build and test net-next, so that was my target.

You should develop fixes against the current tree, not -next trees.
