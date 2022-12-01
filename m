Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993A763F5BC
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLAQxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLAQxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:53:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6574127143
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C832662089
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B3CC433C1;
        Thu,  1 Dec 2022 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669913612;
        bh=iQH9KkZiwBPtZRFaTE6MLGlOkKxexem2UhW9rOwIpB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KjAwUAImhqT2n4GqcaqAIzfPKa/YBUZo/+1eP9p1Fs3KBylqiDqvDCitObDrLfHIZ
         F7Ui2EIl1DGFKO5PU4/WgzOSeQUiIwaCSfzTQQ1LqJTTMe93vvv7bk6xqasRvvic48
         kNsEydOLKjTy5Mj0ULqX0AfatW3T9ydmX/atBPT9Zm8GZGr19tvp2e1LIPMXMR6pYP
         is1DDEoCwfD+ob/9VTtgyCQo9EufboqcdHrDU5+s64NHWlByPloW15nNKZ0WTtBLH3
         uVTJMeKoIRkShTXr+zrz/mId+5S+7ZhcmJrWrXP5YBvxgAfkth0b37bijssKe2Mvnb
         w5YTzY0Ije6hA==
Date:   Thu, 1 Dec 2022 08:53:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        przemyslaw.kitszel@intel.com, jiri@resnulli.us,
        wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next v2 0/4] Implement new netlink attributes
 for devlink-rate in iproute2
Message-ID: <20221201085330.5c6cb642@kernel.org>
In-Reply-To: <20221201102626.56390-1-michal.wilczynski@intel.com>
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
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

On Thu,  1 Dec 2022 11:26:22 +0100 Michal Wilczynski wrote:
> Patch implementing new netlink attributes for devlink-rate got merged to
> net-next.
> https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/
> 
> Now there is a need to support these new attributes in the userspace
> tool. Implement tx_priority and tx_weight in devlink userspace tool. Update
> documentation.

I forgot to ask you - is there anything worth adding to the netdevsim
rate selftests to make sure devlink refactoring doesn't break your use
case? Probably the ability for the driver to create and destroy the
hierarchy?
