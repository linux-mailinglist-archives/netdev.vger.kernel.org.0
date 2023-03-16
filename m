Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639386BC562
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjCPEoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:44:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F99135
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:44:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6CFC61EFB
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB022C433EF;
        Thu, 16 Mar 2023 04:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941839;
        bh=CFksDl+V+aC/3eWXxWJwfYdLl4XgubKToABSeBb2Vnk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AdyTyxHisyIXqpB1XVDifrm80yju33aN4UNQz02s9ghiG1HkVzWxy7CBrbsSgz15v
         OoBlz8m5w1q+/lpOC+vx6w1+oBs7Vo9TK2iOGr0inSSYmTCnfxM1hr7wrDiyGn9JiT
         ux4BNgkPPi2fjOfFmcKxbO25ivJtKSOgOqh1mHiXv5yrfXde+6vjhqhh66i/SnBFWF
         np68ZlKR7sCSu0zbDKyQOP2KQsH7xPA075XWoLjqfV17wsvdWcuKoEW6LBxS74Ubmb
         CYoTSmF/2Nvu2QC5hSE3bkjv0ESYZS/KRPclFsy8+U0OSy0hQ4/DbWWcaRDtuUKsKD
         mpLQatkTNd/yw==
Date:   Wed, 15 Mar 2023 21:43:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com
Subject: Re: [PATCH net v2] tools: ynl: Add missing types to encode/decode
Message-ID: <20230315214357.74396015@kernel.org>
In-Reply-To: <20230315120852.19314-1-michal.michalik@intel.com>
References: <20230315120852.19314-1-michal.michalik@intel.com>
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

On Wed, 15 Mar 2023 13:08:52 +0100 Michal Michalik wrote:
> While testing the tool I noticed we miss the u16 type on payload create.
> On the code inspection it turned out we miss also u8 and u64 - add them.
> 
> We also miss the decoding of u16 despite the fact `NlAttr` class
> supports it - add it.

Do we have any spec upstream which needs these?
The patch looks good, but I think net-next is good enough?

> Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> 
> ---

Please make sure there's no empty lines between the tags and the ---
separator, it confuses the scripts.
