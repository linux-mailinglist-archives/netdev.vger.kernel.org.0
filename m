Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478EC6DA22B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 22:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbjDFUET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 16:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDFUES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 16:04:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58DF6A44
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 13:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704F864A98
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 20:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9825FC433D2;
        Thu,  6 Apr 2023 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680811456;
        bh=1uthiPahevhIwg0/VQ36QYzrLmPVg7p03329/aa02pA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IB+XzYNDQbyJy81qB66aGKp5f4ZF5B00BxdJNmFR1VlusNQ+XpoDTndG82pld7Wyo
         oHfwXWQOFfxFMVRxNDBzLoI4e3RTpKFokXAi0X3OgJlhJuJg35qy9Io3iW7vcwmZZA
         jDBOZK3C4ja29zDpeBmWUdwxmy5iiiYTD7IA6XZfltnEkOpznH11l31jadj+bnQ3dq
         X/VqnRb/JWLq3DMJIgoqXg2oiYT+tzsI1OaOFLpBPJ04aVpdYxNLB8Rvj27W/3+nXq
         vr1xQZAPxNchQAVOJDc5d/UtudawbzcyKSyEiO+roqoWlQTONCaW+B48sgSgfVobqm
         3BkkrZ3MMlEJw==
Date:   Thu, 6 Apr 2023 13:04:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmed Zaki <ahmed.zaki@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>,
        "Rafal Romanowski" <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: refactor VLAN filter states
Message-ID: <20230406130415.1aa1d1cd@kernel.org>
In-Reply-To: <e6e256a9-009b-593a-9f06-6f4adb4df688@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
        <20230404172523.451026-2-anthony.l.nguyen@intel.com>
        <20230405171542.3bba2cc8@kernel.org>
        <99053387-16ff-9ed0-ef12-7bcbc7a7af2e@intel.com>
        <20230405175908.2d3b504f@kernel.org>
        <e6e256a9-009b-593a-9f06-6f4adb4df688@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 12:55:43 -0600 Ahmed Zaki wrote:
> > My intuition is that we prefix bit numbers with __,
> > then the mask (1 << __BIT_NO) does not have a prefix.
> >
> > But these are not used as bits anywhere, in fact you're going away
> > from bits...  
> 
> Ok, how about sending v2 without these underscores, then send another 
> patch to net-next fixing the rest of states?

Definitely SGTM, thanks.
