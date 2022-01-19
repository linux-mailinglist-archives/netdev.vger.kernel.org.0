Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC23493AE7
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 14:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354692AbiASNNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 08:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354629AbiASNNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 08:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F2FC061574;
        Wed, 19 Jan 2022 05:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBEB2B8189A;
        Wed, 19 Jan 2022 13:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E6BC340E5;
        Wed, 19 Jan 2022 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642598025;
        bh=MCJ80zPEGqOHdJ2QElivFmgcDuJnFFqE3ijFB2jlRYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SMzBBy9WAUXX4vPGCdIt6daZg2vEDYylKwOomhQCud6n5lvQF6tN449n8PZZihFKN
         cAtBOWCuEwU8v7I7Qo108uhm46ZLGNAwwYMr8hJ5uHGlCG0ItpjpRrf7n9l2obWmTO
         vu0JATyIixYThUD9FGaxGGyOgtV9psLefezf43b8lhTwfmhueppV+sSBTMAYA2Y0Rd
         2YM2lXNORQ9x5s0lOqfzA1nus1Qdzu9bQBPzMxxrAif+Lyu76rkxRy1GkBaWy4q6+B
         ffIx5CrFDw+3GvS+ylD2VzdAZqBTY42O9Ss+gJluTjHY1jI8pJ91DOgE19fZviZ3uZ
         bDCQzupAj3JhA==
Date:   Wed, 19 Jan 2022 14:13:38 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree v2] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <20220119141338.6815de68@thinkpad>
In-Reply-To: <YeeAXSHSCn6PtqKW@robh.at.kernel.org>
References: <20220112181602.13661-1-kabel@kernel.org>
        <YeeAXSHSCn6PtqKW@robh.at.kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 21:07:09 -0600
Rob Herring <robh@kernel.org> wrote:

> > +select:  
> 
> This should be omitted and this schema should be referenced by any 
> binding that uses it. That is necessary so all properties get evaluated.

Thanks, sent v3. Will you be applying the patch? Or should this be
applied the first time it is needed, by maintainer of the specific
subsystem?

Marek
