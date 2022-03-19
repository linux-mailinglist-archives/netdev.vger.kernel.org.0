Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F444DE5F4
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbiCSEch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbiCSEcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01488D3AFD
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 21:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 894D4B80011
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 04:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F199BC340EC;
        Sat, 19 Mar 2022 04:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647664274;
        bh=XWy9DkkcQQqF8h9WSfaHugUA6mtBirkqKD1AceGceSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGnLUzC5LeBTBBONCSrOyEHpNuaRN3oRsCy9e2J9Ntsc5Az5jhuVh3SegdPcbnlis
         K9kL0hOJo1O17erSZQUgCjs4/pckUVcQmdLb/9S7QWgC3YDXgW+E8cwWb9UkcbfyRX
         ScIvBTfYT9U4qKnIF5NSFvenaF3E4h5zbfqbPEl6/dSdaJAaOjMMHgTyoVPr4E+7AP
         Xaz8+CnTI3fzL8qC3T5Cjeh9neD17TE3FRKEcKByPMp1PHGWuv4i1D1c7S2cNPfaJm
         2MMzxTBDrXYQcGsZ+L5KRLj6uA+SuVZ6oC18VxushSC795vfDR7gKeK0glCKlOv9IF
         mxAlmJ0dEeK3Q==
Date:   Fri, 18 Mar 2022 21:31:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] net: remove lockdep asserts from ____napi_schedule()
Message-ID: <20220318213112.33289a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHmME9rUrWE=AtBhTo95GfCeQCMoRh_KMSOKfpTVpq-7LywMzw@mail.gmail.com>
References: <20220319004738.1068685-1-Jason@zx2c4.com>
        <CAHmME9rUrWE=AtBhTo95GfCeQCMoRh_KMSOKfpTVpq-7LywMzw@mail.gmail.com>
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

On Fri, 18 Mar 2022 18:50:08 -0600 Jason A. Donenfeld wrote:
> Hi Jakub,
> 
> Er, I forgot to mark this as net-next, but as it's connected to the
> discussion we were just having, I think you get the idea. :)

Yup, patchwork bot figured it out, too. All good :)
