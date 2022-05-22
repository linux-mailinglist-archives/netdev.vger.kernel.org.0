Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B135304C7
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 18:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346544AbiEVQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 12:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiEVQ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 12:56:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969EA24F13;
        Sun, 22 May 2022 09:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 977DBB80CA9;
        Sun, 22 May 2022 16:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10466C385AA;
        Sun, 22 May 2022 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653238583;
        bh=6EXJtR4cnG6MT8IMxtERRltKbq2qz/Ha2duwGNw13bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lKWgbNsiaqRtbV3r6a2ViNIYqdG5Ns9vbH5NfxQMge/ZoIk/+wkfwi3o3GoJGOMDq
         RZD3ZHYl0Iq+kcWts9MSsaZbnekLnL4Xsqfvt9g/AS3ZUL2A2sMF2Vf7QjFLRaNncC
         k6TZa/RKiB4BxesqYUOP5KD+zjFa2Z5NnipunYAJfxrmxoexVyaNn88vmywSdi7ysA
         N4lFzFT9VShcjlYCXa9y5Y3INulO4C1DGo4tGZarKr9ewaKs+dQM89Poa5w8f1lZtg
         rCfVSe5z219dUm+rPp/T3R9+mMOaxoCxFvzOfwNXSQlYN6ggk/A8nkbnxuE08m5Jva
         t/98T6y5c2dkQ==
Date:   Sun, 22 May 2022 09:56:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kvalo@kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH net-next 7/8] wifi: libertas: silence a GCC 12
 -Warray-bounds warning
Message-ID: <20220522095621.369292d1@kernel.org>
In-Reply-To: <dfc9d27acf3eaf6222b920701e478c3e9c22fefc.camel@sipsolutions.net>
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-8-kuba@kernel.org>
        <dfc9d27acf3eaf6222b920701e478c3e9c22fefc.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 May 2022 00:03:22 +0200 Johannes Berg wrote:
> I had a similar issue in our driver, and I could work around it there
> with a simple cast ... here not, but perhaps we should consider
> something like the below?

Excellent, LGTM. Would you be willing to submit this officially?
I'll drop patch 7 for now.
