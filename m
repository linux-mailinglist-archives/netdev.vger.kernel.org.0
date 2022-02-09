Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398854AE947
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiBIF1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348290AbiBIFNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:13:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37020C03F91E;
        Tue,  8 Feb 2022 21:13:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE338B81EBD;
        Wed,  9 Feb 2022 05:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3794C340E7;
        Wed,  9 Feb 2022 05:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644383586;
        bh=OKmszPrcHGGikw3VvLNoWHnD+7XDa2MaWmpt5hxWoUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICeETITanenZYMlw45UYMM0KfSKIfjVkEIfvxNfaJhH00s7P4JV5+PFWB9FFREbjl
         kcdR06MqbLqfAnt3Pj627Z8Te4cdpY2feR4/bjinEU2PtuaQdXHAZsrsxzidiO7zz+
         FGu0KbgSenR1+e3AFvPQGc17G4c7W5XthayclpesxEeX5hK9A31Z2YGuqCNsSzWx6p
         tqnqUrc2dAZuzWuGykvwhFOlRRcXbeQQdNYfPyAlUYJJJnr2i26TPipGUDylyuiMGQ
         TmbBmc5cunwUUS99YgVT67SXYgoKja5xLSiLEOYx66d6CoZ8H+mLlluVNPoeEaNkv/
         fLZFOK9uszYzA==
Date:   Tue, 8 Feb 2022 21:13:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, vinschen@redhat.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
Message-ID: <20220208211305.47dc605f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
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

On Mon,  7 Feb 2022 15:32:44 -0800 Tony Nguyen wrote:
> Corinna Vinschen says:
> 
> Fix the kernel warning "Missing unregister, handled but fix driver"
> when running, e.g.,
> 
>   $ ethtool -G eth0 rx 1024
> 
> on igc.  Remove memset hack from igb and align igb code to igc.

Why -next?
