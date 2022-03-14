Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9BA4D8DF3
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244039AbiCNUM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244433AbiCNUMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:12:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829313D0C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB59B80FA7
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C8AC340E9;
        Mon, 14 Mar 2022 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647288695;
        bh=KIOrN/hO69r3zY7TPtbiLbMsh5cL4njwJiGp3c2h1v8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b8xsqLLVncLh1pENyG1w+Dfloo9He1sd/aXW5MIhxkeCS2pBMVqHiTRED8XkcGa5s
         3AXecJRwOKg0YsQNBOq/QUTiFdvu+PulTWOiCrGDjqarTaKCpi3DAdfEUbE/kB9Mr7
         Q8QOHPJZoNykgCq0+IWht6Nr1t0XQILUzr8LhqMn940c7KL8MyHsW6qsJhwWGyUtNF
         G0fC6rceku/D/VAsGeAoFOzUZeJ8hqotxvuAnbjh0af+ZsnHsyQzckIFdz8+TXVXcr
         R7OWbMO0YhkMzFLq49E/MzDmBAV1W+IixITON4YgqnhhWb6oQDwHaJLt/i6qhrr/dQ
         nl4OCK7BzrMnA==
Date:   Mon, 14 Mar 2022 13:11:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220314131134.62f98ba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yi+TJ5X27Esi4NWz@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
        <Yim9aIeF8oHG59tG@shredder>
        <Yipp3sQewk9y0RVP@shredder>
        <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yi+TJ5X27Esi4NWz@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 21:10:31 +0200 Ido Schimmel wrote:
> > Hi Ido, no news?  
> 
> Sorry, forgot to update you. All the tests passed :)

Perfect, thank you!
