Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04CB65FB5B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjAFGTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjAFGS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:18:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52B96E0C4;
        Thu,  5 Jan 2023 22:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A742261D1F;
        Fri,  6 Jan 2023 06:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E5C433EF;
        Fri,  6 Jan 2023 06:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672985830;
        bh=EP7iIpwhh963RLuo/LxdY7KfiYEtuA0zswuKSqhUA7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFewlX5anhu9askLgIdh+o7fCxowSIYGjhIgAQhsS/U88SbjHrh5RouB7+oNgRdwY
         Erb9WpC+ZAcnzHtg8aPasNDLCZMYn+tWD5Tpmhn55hlzYy2Ex6awoQqPDBIMfnYrOK
         a5aYOOyEwh35lJW6wB9fmMvmWIgIZmu1l9WhbUHicVFGKi4zRwq1VGxZPPobftwCp5
         YcWHayIkirJvMRa/DirxjD1JUW8b5E9UtGyjlyga7jEuavPRVv5m11QUZ2pVgFFjV2
         SJtR/YUStUKTLB3wbKQXFGAbNHjLHwEcS7s5lRMpxwCHx+wDYrRtG0NvSBqduF/d5z
         ENul6XiqVcWow==
Date:   Thu, 5 Jan 2023 22:17:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] net: ipa: simplify IPA interrupt
 handling
Message-ID: <20230105221708.659069f1@kernel.org>
In-Reply-To: <167298541710.969.9209439108124310998.git-patchwork-notify@kernel.org>
References: <20230104175233.2862874-1-elder@linaro.org>
        <167298541710.969.9209439108124310998.git-patchwork-notify@kernel.org>
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

On Fri, 06 Jan 2023 06:10:17 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
>   - [net-next,v2,6/6] net: ipa: don't maintain IPA interrupt handler array
>     (no matching commit)

Hm, no idea why it thinks this patch was not applied.
