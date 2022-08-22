Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B727E59C5D0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbiHVSLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiHVSLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B511C46D99
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64284B8172B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D508CC433B5;
        Mon, 22 Aug 2022 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661191857;
        bh=9EglNjCD+My0ZUcQUIkp8KSc5l/diY5K26Dz/wDeR90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NGbAWMTQwtjQlT8Z8QeDZ7YtQmYEqMSgpqlU9M6xsuCS08sj9ODxrk6HwCHz+34DQ
         gnRFAs3iPBWnjw0kbT4bexB+ItYvuNJ55gORlyzJDmCdeahndvfOuMIAHylduek/YK
         7P6GKxtUY46NXrSgE643g+CtvzkxtRTc3byZ0HuOYyahHZS6BDkNNsxqM3L3f2hEiH
         qeIy5J1+n9+4XGqztJRFDDYtp1j6P0g4pn+TNIsWJumvDBvMOdA4CPXcqwiHLQKNEe
         VbTE0TtoRLl7puBcIXasK5ZKNSubBi4qPj218GBM0prlm7OY8Pf838yTzmjhHvLHjY
         2ImOBKNaFlvKQ==
Date:   Mon, 22 Aug 2022 11:10:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raed Salem <raeds@nvidia.com>
Cc:     Lior Nahmanson <liorna@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data
 path support
Message-ID: <20220822111056.188db823@kernel.org>
In-Reply-To: <DM4PR12MB5357C54831EB8F1C9C982D90C96E9@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220818132411.578-1-liorna@nvidia.com>
        <20220818132411.578-2-liorna@nvidia.com>
        <20220818210856.30353616@kernel.org>
        <DM4PR12MB5357C54831EB8F1C9C982D90C96E9@DM4PR12MB5357.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Aug 2022 11:12:00 +0000 Raed Salem wrote:
> >On a quick (sorry we're behind on patches this week) look I don't see the
> >driver integration - is it coming later? Or there's already somehow a driver in
> >the tree using this infra? Normally the infra should be in the same patchset as
> >the in-tree user.  
> Driver integration series will be submitted later on

This is a requirement, perhaps it'd be good for you to connect with
netdev folks @nvidia to talk thru your plan? Saeed, Gal, Tariq etc.
