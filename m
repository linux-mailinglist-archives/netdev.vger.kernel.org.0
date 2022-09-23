Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D65E7BC1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIWNZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiIWNZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2767312C683;
        Fri, 23 Sep 2022 06:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF467B81E56;
        Fri, 23 Sep 2022 13:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8BFC433D6;
        Fri, 23 Sep 2022 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663939543;
        bh=dvzp8eyI4MQl3wONgiHtP4fVdsf0WDy4arC+9dcgonw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyaeRFAEYordYWbyGSMdleexKo5WW/HrH9aUcowCGGEWPFqFoM7adziIPM8YPe3oq
         +ySW1PLXu4jKAM5UHlfQXoYGpuYdFXoPrCFMxOjMvR94mOJ3EjcXVVA5JZHPP7WLS3
         sr1TLyqNscp2MmImHNWuaRYXSbDQNRPzB7tYHj8eR/SB73egR6MPMaS4E25JQukFhr
         SCqVhLu6g0iWs6nMzxfinuteAeaYApNaY95/Y4u7kSn8rn2Vw7AFr8bchyBwl4hIoN
         Nz56I4RyD+l+rScDkmVwSmPaQo2RnzL4d5G1uD75daiofxHyirRlbiZdQO8U/iRtlK
         0Hb1RE5oyiSQA==
Date:   Fri, 23 Sep 2022 06:25:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] selftests/bonding: re-add lladdr target test
Message-ID: <20220923062542.6e41fed8@kernel.org>
In-Reply-To: <Yy16saDPo5tnkXdp@Laptop-X1>
References: <20220923082306.2468081-1-matthieu.baerts@tessares.net>
        <Yy16saDPo5tnkXdp@Laptop-X1>
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

On Fri, 23 Sep 2022 17:21:53 +0800 Hangbin Liu wrote:
> > The first one was applied in 'net-next' while the two other ones were
> > recently applied in the 'net' tree.  
> 
> Thanks for the fix. Before re-post to net-next, I should wait for some more
> time so lladdr test could be applied to net tree.

That'd be best, but hopefully if the tests are sorted the chances 
of conflicts go down. Chances are the tests will end up landing in
different spots in the list rather than all at the end.
