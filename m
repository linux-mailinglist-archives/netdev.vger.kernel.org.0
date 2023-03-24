Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552ED6C76B6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCXEyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCXEyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43180EF8C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 21:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3CF26294A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 04:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A4EC433D2;
        Fri, 24 Mar 2023 04:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679633650;
        bh=2JRudIQh65qZ6tHnsabSRzj18cCSM5gxQ2xSsUScztU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G1pKJna+/jOgIGc4r3jD8QlSPnVvOm9k8tkj96noQVOvGLcV+uOddBfsSUWYuz0Rz
         xzgOgW9zQs/E5UTjaHM/GUVkTcgY2xORPasZ3iSwJ1rMHm2QPEyfh2ol12R98kHVg8
         6VeDITodLeutW1kDRBQaaal7eChXprIhmFq1b3+ArWkHms7RqDuHHEgB98fbFdxGCu
         4s6ZKuzyqBqeWT0zpnw1z3mltHV9EUaOgqUAxvDuuTCGPITzU2c6oBbNHAurpzTuZc
         FvyFIBP+ovG0EbICuqI0bg91XZLwBYFMWRoKXdixJykXsy6IE670nP2I5mL8hfwDq+
         YIDErTeRkSyNA==
Date:   Thu, 23 Mar 2023 21:54:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v3] tools: ynl: Add missing types to
 encode/decode
Message-ID: <20230323215408.08c76fd5@kernel.org>
In-Reply-To: <20230323175129.17122-1-michal.michalik@intel.com>
References: <20230323175129.17122-1-michal.michalik@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 18:51:29 +0100 Michal Michalik wrote:
> While testing the tool I noticed we miss the u16 type on payload create.
> On the code inspection it turned out we miss also u8 and u64 - add them.
> 
> We also miss the decoding of u16 despite the fact `NlAttr` class
> supports it - add it.
> 
> Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")

No fixes tag, no in-tree spec needs these today, right?
Please rebase, too, Jiri sent in just the u8 addition in the meantime.
