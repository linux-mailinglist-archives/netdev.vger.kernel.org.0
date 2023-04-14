Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7952F6E266E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDNPHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDNPHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:07:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49C10F2;
        Fri, 14 Apr 2023 08:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB82261633;
        Fri, 14 Apr 2023 15:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AF1C433D2;
        Fri, 14 Apr 2023 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681484850;
        bh=BhqDRlXbhJFVBZFdkSSkW5XqxP8BybMDa19WNKzFwEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fZ0DE0145apnwE9EMAeWSHi93Q4QG7J+hXtNmv0IihebIZpHYbS0k9dk+WdfyEr3d
         g0KNsmFjR4hvrguPr1MR3MxNjDlP3srSHJIBgf+boXuvwgWa8E43+cMLZ4hap+4rkW
         /ogkWaViwI2mxJJEalCutdnmaVQCm49Ntu//zcbM6bx9lZKOYwFHnyO6OfUNmXdWss
         Ws7jxJtMWH+L4Gr4tAZhSdFF7+bmkdVCGUb/ycLePo/qk8Z/32XfeH/huVzSx4JNTw
         UXOnxPvI0/Orfj2UB1XFZHaINqpjv0sA0D1qdAyDqgzag/3UvtmMLpEIcQVjUmv3uW
         9viI89hZpwmQw==
Date:   Fri, 14 Apr 2023 08:07:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Yixin Shen <bobankhshen@gmail.com>, leon@kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        ncardwell@google.com
Subject: Re: [PATCH net-next] lib/win_minmax: export symbol of
 minmax_running_min
Message-ID: <20230414080728.58918495@kernel.org>
In-Reply-To: <20230414022736.63374-1-bobankhshen@gmail.com>
References: <20230413171918.GX17993@unreal>
        <20230414022736.63374-1-bobankhshen@gmail.com>
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

On Fri, 14 Apr 2023 02:27:36 +0000 Yixin Shen wrote:
> For example, Copa(NSDI'18) which is adopted by Facebook needs to maintain
> such windowed min filters.

Perhaps an unnecessary comment, but this should not be misread
as this patch itself having anything to do with Meta.
