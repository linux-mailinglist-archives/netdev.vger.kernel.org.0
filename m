Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB974BAE0E
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 01:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiBRAHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 19:07:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiBRAHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 19:07:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D380522F7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 16:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83B5DB82534
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 23:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3DDC340E8;
        Thu, 17 Feb 2022 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645142277;
        bh=cKrb9VQ39E8BlsncJVk7jcG71QBsRvaEbCNxEpp8KAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IHe1QBsGnAvSvVK6qyyJrUZymo5J6my4Y1+WGWrh+E7pQxYxths/SllIpVV5/YVhA
         maWtTE50UmI+PBKCuP6r/nTKGruA06/vpTeVMtRsytylj5tfmMSYUJ4/e8cSHalagL
         hrF+rlvtSDlKF1u6q98ZG7CZ70qheRrUJSmoiMNERyF12oUkda8t5kfKZZwUUyxM38
         6ev2SDlgsQlqciI1Y4YO8JbUep+yTMiQaLflrxD9ZJcBDcleH8Qe42H0dWdViChm1F
         CTiM74B1SrZzngv5bs3tXIAyHHbzS66g/cuvoPg321h7D4gNSsIc5+yW6s58Vo2lWJ
         0GB08YQHssDsA==
Date:   Thu, 17 Feb 2022 15:57:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [BUG/PATCH v3] net: mvpp2: always set port pcs ops
Message-ID: <20220217155755.41e0df1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPv3WKftMRJ0KRXu5+t_Y8MYDd4u0C74QZfsjUjwo7bvonN89w@mail.gmail.com>
References: <20220214231852.3331430-1-jeremy.linton@arm.com>
        <CAPv3WKczaLS8zKwTyEXTCD=YEVF5KcDGTr0uqM-7=MKahMQJYA@mail.gmail.com>
        <33a8e31c-c271-2e3a-36cf-caea5a7527dc@arm.com>
        <CAPv3WKftMRJ0KRXu5+t_Y8MYDd4u0C74QZfsjUjwo7bvonN89w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 17:44:53 +0100 Marcin Wojtas wrote:
> > I don't have access to the machine at the moment (maybe in a couple days
> > again) but it was running a build from late 2019 IIRC. So, definitely
> > not a bleeding edge version for sure.
> >  
> 
> 2019 is enough indicator that most likely there is no MDIO description
> in ACPI. Let me test the patch, thanks.

Any luck with the testing? I wonder if we should keep the patch in or
drop it for now and ask for repost once tested..
