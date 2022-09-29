Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262DD5EF9CC
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbiI2QI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbiI2QIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:08:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626551D2D10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D86E61A0C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 16:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED2C433C1;
        Thu, 29 Sep 2022 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664467721;
        bh=H9PLbOB0JA8rcGt0T0sisZIgYZE/d5am1O1i9vl1Mv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DR8pu+WExUJiPR+dkxa8/tYYW9LK9YBT9LRHwuoCMG6gRwVqPezBLapx7qB04UWF2
         HHPxG0sxCU8CWWx0woVr9MLwXogM9ZhRAdghP8iyAwBkEDGf7VHbZzn+rAnMrJ2DYu
         nzdfNq2vMoY9I7v75FGrrMdT2jmZymHnd5dxhkRVbb7cqjeCvDF68aRWD+X6cxbBPc
         uW4Hh8DkJ2ENFKxVwFtEoV1yia3oaxbKcvT/7qzEV7VkkQN957txe1e7L20tHnzVPx
         lajw3XIpVFDmYODb2iVKqhIxXBH+kbY6jaAOI9zSucoZVZB51MY1yO4Qilbaypelfd
         IKP5b11okiqGg==
Date:   Thu, 29 Sep 2022 09:08:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] macsec: use NLA_POLICY_VALIDATE_FN to
 validate IFLA_MACSEC_CIPHER_SUITE
Message-ID: <20220929090840.062e1ace@kernel.org>
In-Reply-To: <5d4541915e5229c0329ff8e6618439ca21767b18.1664379352.git.sd@queasysnail.net>
References: <cover.1664379352.git.sd@queasysnail.net>
        <5d4541915e5229c0329ff8e6618439ca21767b18.1664379352.git.sd@queasysnail.net>
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

On Wed, 28 Sep 2022 18:17:21 +0200 Sabrina Dubroca wrote:
> Unfortunately, since the value of MACSEC_DEFAULT_CIPHER_ID doesn't fit
> near the others, we can't use a simple range in the policy.

This one warns: 

drivers/net/macsec.c:4122:6: warning: variable 'csid' set but not used [-Wunused-but-set-variable]
        u64 csid = MACSEC_DEFAULT_CIPHER_ID;
            ^
