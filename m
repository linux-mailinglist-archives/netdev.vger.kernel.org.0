Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BAC5EE244
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiI1Qud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiI1QuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D314076954;
        Wed, 28 Sep 2022 09:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90EA6B82149;
        Wed, 28 Sep 2022 16:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F7FC433C1;
        Wed, 28 Sep 2022 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664383818;
        bh=nO2FVx71lLMwIArJSpqWwipysfz4URJIeLuB3aibPQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mWAtM9P5ETCtHOlINql5maT/SfzU+ljYbUqasDO4Wo3rsLIPpQvwMVjWg/am70D/e
         QAeLabB0TEq4JW0b1Q8YxqCvd4Kb0lJHdJ1uYwkPJiJMi0+LFR4qKJJJ/yRyPasjGX
         9BffnXnWvJk/HCHpRkz83Nis22w9/t0P45SJ6Z+LJ2pFohx2kAzSkHapjzSGgLVDbQ
         JBAb2//JCqmNleSoMHDU10RHxAjwOJ8JUkoLaAchlpN/O1NoZMYfEkhL7WNXyEwte0
         bNOp9UsboC6WN+YPa2D5epNnCSQObELwVdqnvAQi/Fw9abpzZdQphNRi9v9tsDP0yN
         Mo/f3EGp9pWBw==
Date:   Wed, 28 Sep 2022 09:50:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x
 devices
Message-ID: <20220928095017.014f6c14@kernel.org>
In-Reply-To: <20220928082050.GA92990@raju-project-pc>
References: <20220928070830.22517-1-Raju.Lakkaraju@microchip.com>
        <20220928072725.t7otq35ui5xw3kzq@soft-dev3-1.localhost>
        <20220928082050.GA92990@raju-project-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 13:50:50 +0530 Raju Lakkaraju wrote:
> > > Reviewed-by: Jakub Kicinski <kuba@kernel.org>  
> > 
> > I am not sure that Jakub gave his Reviewed-by, but maybe I have missed
> > that.
> 
> Fixes tag correction was suggested by Jakub in V2 patch.

Does not mean I reviewed the patch, only add review tags if someone
explicitly sent them to you.
