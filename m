Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E75502EE6
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347900AbiDOTGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347903AbiDOTGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6045EDA6CE
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 12:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05755617EA
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 19:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9219DC385A4;
        Fri, 15 Apr 2022 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049432;
        bh=RVds9XxSNlvwWuOPK1En0bGPkQZUY5zXL3gVXkOhN18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ng9rBc4yyfWHg3U9CWDOifZmvPq/9iCGZ6ZPNYe98kGl2ukJKChI180YPpxzU3ytm
         HV9RSsKeq3ESGzn5eGmu2CkhrWvxJGtJoKP4IvX3n/R29G/wnhrzbKMThqz0I8M++w
         up72XzFLB6b5ZoYr8ZEWeQJyZzik+gBIIB1ISkOD8hNBkKDdXGjfAGpKaHRkdzjEcL
         HpSA547er7v3Z52OFJ6LdI1LB0KvKx4uIK5swoekzpowz3BeR8sIx55I3+cPJ5NoLq
         VRmaXkLqiG2kpcPgh4BgQvh3IaDj623z2jWyhm1bGbPs7AIkk1/Hs9nPFMRp44RmZy
         jYt4t9Ye8LQug==
Date:   Fri, 15 Apr 2022 21:03:45 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com
Subject: Re: [PATCH v5 net-next 0/4] rtnetlink: improve ALT_IFNAME config
 and fix dangerous GROUP usage
Message-ID: <20220415210345.08b0ab75@kernel.org>
In-Reply-To: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
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

On Fri, 15 Apr 2022 18:53:26 +0200 Florent Fourcot wrote:
> First commit forbids dangerous calls when both IFNAME and GROUP are
> given, since it can introduce unexpected behaviour when IFNAME does not
> match any interface.
> 
> Second patch achieves primary goal of this patchset to fix/improve
> IFLA_ALT_IFNAME attribute, since previous code was never working for
> newlink/setlink. ip-link command is probably getting interface index
> before, and was not using this feature.
> 
> Last two patches are improving error code on corner cases.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
