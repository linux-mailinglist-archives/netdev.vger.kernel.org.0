Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24745623440
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiKIULe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiKIULW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:11:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3934D186EC
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D09FBB81CC6
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356A1C43144;
        Wed,  9 Nov 2022 20:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668024679;
        bh=9sLJTlAYiR2MuDBUSt6ueJjJPIaZaiLvFBa5r1g2gK0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MQr6SO8hEYBhyLNI6FT9REhiFoDZ4qiF8TulIKHswr4xbrhVQCnsGx/PciHYjT3pb
         3KGhSNNltoIZvZN3sONwK+AtyYB88KIdwM0AZw4FiPtirm+UqhfvZ6k9X+QmhVEASH
         eDZY8L+SyyfmaKrxfG/v9d3ioi3tie3S7jtdxI0SIg/23fDnb6XDjo5+tjNmO/v8pH
         hLDvmBL7kLVtQ0IUB3/m7OjeItKrxKRepkmwJIcNAQPAcrKzB6KYOiuZoETFVgLu1w
         sr7oR/CzkvC10bSzn30du00Fqtzor5G7mDQCllT8xCj86FSTTL0C8VglgLyFCvMlcY
         lUb/kpkTula/Q==
Date:   Wed, 9 Nov 2022 12:11:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jonathan Lemon <bsd@meta.com>,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <20221109121118.660382b5@kernel.org>
In-Reply-To: <Y2v4fVbvUdZ80A9E@unreal>
References: <20221108204041.330172-1-kuba@kernel.org>
        <Y2vnesR4cNMVF4Jn@unreal>
        <Y2v4fVbvUdZ80A9E@unreal>
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

On Wed, 9 Nov 2022 20:59:09 +0200 Leon Romanovsky wrote:
> > I added your updated patch to my CI run. Unfortunately, the regression
> > system is overloaded due to nightly regression so won't be able to get
> > results in sensible time frame.
> 
> Tested-by: Leon Romanovsky <leonro@nvidia.com>

To be clear - did you test as posted or v2? Or doesn't matter?
I'm wondering how applicable the tag is to v2.
