Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6264F59337E
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiHOQtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHOQtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A9715FF5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78320611F3
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4162C433D6;
        Mon, 15 Aug 2022 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660582169;
        bh=Xow+56hoJft98clvzzan8rva0MD+3lcS3jQMC/uZLiM=;
        h=Date:From:To:Cc:Subject:From;
        b=l+CnkHNoAKXAxLlPxW40492dTi64pSpV0M281khUakEOmCsUWLZ7H0IUkDVbrbb/R
         aEB4EjLnalDQk1Ynym3X9EKyRfLSBorbfkuuCfWS2sBKj9GnLd1sxmIKeBIhNu5cfH
         5QtqKcrkVYwnB4yVVaA9s2IA5BFMArxer5Pt0fRdUtNdjkCZydsrr9mQSOuiTSfzCB
         SR5PCpxm88qwfkUYRhyo2NRR1uhSTAqAmOF8kANGvCwdmdqcUMZ3bbVd9VJj+ZuE0c
         uAMcEmLpzMuUrz13FoPdRAXK+pel14TY/a7++Fra2v0y6d1ryP45hj6rIU3cA8cr5L
         lIRLnOchgGPBA==
Date:   Mon, 15 Aug 2022 09:49:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: net-next is OPEN
Message-ID: <20220815094928.31a3344a@kernel.org>
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

Hi,

rc1 is out, net-next is open, again.
