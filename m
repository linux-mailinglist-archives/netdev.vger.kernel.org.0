Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C65660BD3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjAGCPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjAGCPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:15:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6F84BE7;
        Fri,  6 Jan 2023 18:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20B2461FBE;
        Sat,  7 Jan 2023 02:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ABDC433D2;
        Sat,  7 Jan 2023 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673057741;
        bh=Bwu0gjh6SC4DZe66nJYF/rW03OKiuMjUNnNGs7ZAZpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tn2R3p9FmFC65DtY1yI2meOFQoswYCYYzajUw1UxHtC57rPs05J8US2iq1bLBU882
         cLl0jZzMKRMCySrmGipwV3+iGUqnk2TyMdI7QOnnni778LqhRITgu/StEpEdl28DcV
         Vhci8AlGrCghql9jHKRqtCymznFTm7YNYJs9jGx22YHHwaJQFoSoM+1NEKj6+ClrET
         upes7Er7b6R5v1JmjfLwMuUMSmZ8kQNRnJxDX1vhhD+1T6stiwSVE97YSc+kTcDTjk
         9yVO/l1zQ5IcUqkPtb5Um5pi8tYiIBcFvfxD0qQcxltAFeGuSjyoiTV764g7DY/7Qh
         rPPkhtnkL3kLw==
Date:   Fri, 6 Jan 2023 18:15:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-mips@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
Message-ID: <20230106181540.61d4cad0@kernel.org>
In-Reply-To: <50dfdff7-81c7-ab40-a6c5-e5e73959b780@intel.com>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
        <800d35d9-4ced-052e-aebe-683f431356ae@physik.fu-berlin.de>
        <50dfdff7-81c7-ab40-a6c5-e5e73959b780@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Jan 2023 18:04:54 -0800 Anirudh Venkataramanan wrote:
> >> In a recent patch series that touched these drivers [1], it was suggested
> >> that these drivers should be removed completely. git logs suggest that
> >> there hasn't been any significant feature addition, improvement or fixes
> >> to user-visible bugs in a while. A web search didn't indicate any recent
> >> discussions or any evidence that there are users out there who care about
> >> these drivers.  
> > 
> > Well, these drivers just work and I don't see why there should be regular
> > discussions about them or changes.  
> 
> That's fair, but lack of discussion can also be signs of disuse, and 
> that's really the hunch I was following up on.

Lack of feedback, too. Some of these drivers are missing entries 
in MAINTAINERS and patches don't get review tags from anyone.
