Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BCB6E2639
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNOv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDNOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1BBC
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2635260A72
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EA1C433EF;
        Fri, 14 Apr 2023 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681483833;
        bh=M2WUWEkYLgcG8OjadHl3/LRLmD/HIfhgDpvp1jLvaE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NhqVLvdna58+TMzQ06gTrvzR/qo6p8aGHdr3kvqSZulW/dZC9jv2vgk1TJG8jwrCC
         8xA6nVCXzEX4U//xV+wb9W44qY+ToELrXw1SIi+bXiacLqszw5WR3Y1uG2/35buCHc
         4RtfgeIE+xA5hwgyDjm9N191drJy17mCz6pWeVbhfMmbpTDb6agZbsGLW/w6ZYJTCq
         HpSnpWYioM0GH1XLZwsPso/Bmq6kv022ceAC8goknB+qCCLl+OUs0MmW5yrg3iMOjp
         Wb92IE+cCk+pDo74LYx0CPb+RakC3cwN4CyxhvX1ZsubQqOVQvHLkADXF1CvXOaEoi
         8HqrxmcPRgfAw==
Date:   Fri, 14 Apr 2023 07:50:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, brouer@redhat.com, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, linyunsheng@huawei.com,
        alexander.duyck@gmail.com, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next v2 2/3] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230414075032.3b506d8c@kernel.org>
In-Reply-To: <dad5f7fc-dfa8-3aa9-ec4f-9e220e6f400f@redhat.com>
References: <20230413042605.895677-1-kuba@kernel.org>
        <20230413042605.895677-3-kuba@kernel.org>
        <dad5f7fc-dfa8-3aa9-ec4f-9e220e6f400f@redhat.com>
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

On Fri, 14 Apr 2023 10:45:44 +0200 Jesper Dangaard Brouer wrote:
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks!

> BTW, does it matter if I ack with <hawk@kernel.org> or <brouer@redhat.com> ?
> 
> e.g. does the patchwork automation scripts, need to maintainer email to 
> match?

For better or worse we don't have any substantial automation in 
the area of maintainer ack tracking. But if we did we'd run it thru
various mail maps for sure, so it should be fine even then. I hope.
