Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BA45A5B01
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 07:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiH3FHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 01:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH3FHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 01:07:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D643A2841
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 22:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3F2B81632
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 05:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12FFC433C1;
        Tue, 30 Aug 2022 05:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661836037;
        bh=+wMO5RpVE8aWdpWwENd73da/Ov7+JCN7CugGG73x488=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KjvRO0jJ5yHGVFGOiMrFFGJwLwEcZ1CM5dX0FMKFr7qTUjuL+UR/MNW9X8QMbyykg
         nevPgGHrF01IRZWAjdMfAHeIF4pBjQAZ1XdGr00hpcmAVzD6lN+Ny5IUEu6d4cnKdR
         +i9vu0LWWJsl37yNxBsXmtzv3zFroEzYtcMIL0C8H7Dek1Qpazcmw7Whm4Iz0PJj5V
         GQ2J0th7ySDU1MjBJNqeDZy9XCpvqmlguZPIXGd9LMXK3wvFsTeollqctD23O0d14Q
         eVArQmuniz9nwe2xn7Ubld/o81lMc5pN8ec+uxCCytwKJtQ/diyIFDBErEBK1Wm4lw
         laC8flqcD0V2A==
Date:   Mon, 29 Aug 2022 22:07:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        arun.ramadoss@microchip.com, Romain Naour <romain.naour@skf.com>
Subject: Re: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <20220829220715.10b707a2@kernel.org>
In-Reply-To: <5628a48f-b521-a940-63a0-52f8db0d2961@smile.fr>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
        <Ywfx5ZpqQ3b1GMBn@lunn.ch>
        <7e5ac683-130e-2a00-79c5-b5ec906d41d1@smile.fr>
        <20220826174926.60347d43@kernel.org>
        <5628a48f-b521-a940-63a0-52f8db0d2961@smile.fr>
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

On Mon, 29 Aug 2022 09:20:06 +0200 Romain Naour wrote:
> > It's pretty common to use a different email server than what's
> > on the From and S-o-b lines. You can drop the second S-o-b.  
> 
> Thanks for clarification.
> 
> Should resend the series now or wait for a review?

Resend, please.

Looking quickly at the code it's interesting to see the compatible
already listed in the DT schema but the driver not supporting it. 
Is this common in the embedded world?

That's orthogonal to your patch, I'm just curious.
