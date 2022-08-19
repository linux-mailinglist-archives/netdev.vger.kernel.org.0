Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9CF59932B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbiHSCtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiHSCtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:49:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9F1C877C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B621B82558
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BF2C433D6;
        Fri, 19 Aug 2022 02:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660877382;
        bh=fRkX9uP6+YgaLMkW1AjFewtpN9irIIsISU0de9OvobE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ccakrr2WvEfThSHfd8nfP7rLzzAzdcBrkBmHq7+qj/SjEUduxUU1hd6Xs2Nfa66TJ
         EAf9ZAO2OXV0VzmMCNu0/iA5afNKERnEq0soyfux6eFRyX5nluxDpmp/2mTSxZbCMh
         v7VJqTOTs1mbuzok+KLf2jJUIZi6tkaOZ6ha9Vf2IzK/IJ3YHgcrJkpn+a/wU7RuRU
         F+wxsKfvwHIP3lwz1l0vKpWhu3ESc1y0BDQ4+Vk8kEW94tY7W67hgt5rFCsQUhcq9R
         D7VfxbxDJMtrzg4m18RCbqjBdOI+YTedZSkK3a64hdicQLahRj8O/BUFAkQGM2/iVx
         bgTdXohT8Gm9A==
Date:   Thu, 18 Aug 2022 19:49:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 commands
Message-ID: <20220818194940.30fd725e@kernel.org>
In-Reply-To: <20220818130042.535762-1-jiri@resnulli.us>
References: <20220818130042.535762-1-jiri@resnulli.us>
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

On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
> Currently it is up to the driver what versions to expose and what flash
> update component names to accept. This is inconsistent. Thankfully, only
> netdevsim is currently using components, so it is a good time
> to sanitize this.

Please take a look at recently merged code - 5417197dd516 ("Merge branch
'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
there so I think you're gonna break them?
