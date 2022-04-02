Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F19F4EFDF1
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 04:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiDBC0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 22:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiDBC0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 22:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3304B106109
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 19:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A66E61C5B
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 02:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765BCC2BBE4;
        Sat,  2 Apr 2022 02:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648866285;
        bh=aFfYpu7Mz/rCismSla/pLBlrO+vL1i575VNojxUPrIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HLt1nufvy829UQBNJG/glCKSjN/uie8T8yxuNcSIwg+5aljZFUu83mtME6xn/3eyZ
         EIAFlqcny6fq4x5vGb9gKknmism82O/htYtcS7FeYrleyaO5AAl+AcdJjqp81W8FpY
         VFtaHOGvG5GFvnr0iSEheLsjhjhvxUU7cyDcU6oZ72m84JLJPSJLPjMv9kqg4AknVx
         LX+PP/rJ1SpJFXUtBqTT8tBopOc5ocUJVceZ576rQqmkDSEDyroWZtcOgQLtwMLKbL
         6Abs453hrBA/LGCJIHjizzHIJxs9ZYMAeiM1lKVIxiyWo+RFSEeHarMUxGtUohr8Oy
         vvF2EXYEU9Tdw==
Date:   Fri, 1 Apr 2022 19:24:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alice Michael <alice.michael@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [net PATCH 1/2] ice: Set txq_teid to ICE_INVAL_TEID on ring
 creation
Message-ID: <20220401192444.38c177ae@kernel.org>
In-Reply-To: <20220401121453.48415-2-alice.michael@intel.com>
References: <20220401121453.48415-1-alice.michael@intel.com>
        <20220401121453.48415-2-alice.michael@intel.com>
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

On Fri,  1 Apr 2022 05:14:52 -0700 Alice Michael wrote:
> Fixes: 37bb83901286 ("ice: Move common functions out of ice_main.c part 7/7")
> 
> Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

No empty lines between tags, please.
