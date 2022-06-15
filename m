Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7654BF86
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbiFOB7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiFOB7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE2C4C423
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 18:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4478A619CF
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F293C3411D;
        Wed, 15 Jun 2022 01:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655258338;
        bh=WNBTkyhh15tCOJZwZTQpJNvgCWbAH7wXx1+D73kFpHo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mefC8Ha01VUmXHIdGOCsEkif4nMeIqG5PiUj6QpM/rd5bxScJbeTc26R664M5Y2bW
         tUXYj85Ez7wi1Jwkw3AFFtvu3E77r7OWAFKjYgarvthtcK8wuwyKiSzpHKwTBMyKSz
         l4pGqF+3OLnhdtcmZ8TXcSAXQTBCT+e+74FbJW2ZNkakx5eZLywy5qBJF2epEP430V
         NAhVLq91kCPt+ESKiwWSyaVhB/ls+UoxooPGKOvG93AV3AulaDJJJaMPmxWQm7Pth6
         t5Q6vdkJGgeUfIKeegX3Lvnxr1JK3JEGLLadFF28GZ/bWxTK/wlry68PwBDoh7801t
         xlvBUnNTVYeYg==
Date:   Tue, 14 Jun 2022 18:58:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/3] net: Add bhash2 hashbucket locks
Message-ID: <20220614185857.771aa2c8@kernel.org>
In-Reply-To: <CAJnrk1b7F6LMwA9wK-xyimVcGB8mNSn94fL8_Z0SwWnd0uqcmg@mail.gmail.com>
References: <20220611021646.1578080-1-joannelkoong@gmail.com>
        <20220611021646.1578080-3-joannelkoong@gmail.com>
        <5b6a4415-c4f-254c-3c54-7fa0dfde32e9@linux.intel.com>
        <0789de291023a1664d2b198075af6ce6a9245c6e.camel@redhat.com>
        <CAJnrk1b7F6LMwA9wK-xyimVcGB8mNSn94fL8_Z0SwWnd0uqcmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 11:08:41 -0700 Joanne Koong wrote:
> I think it's a good idea to revert bhash2 and then I will resubmit
> once all the fixes are in place. Please let me know if there's
> anything I need to do on my side to revert this.

We'd appreciate if you could post a revert patch and gather some of 
the history into the commit message (with some Links: to reports and
postings of the fixes if possible).
