Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6296B6F0D51
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbjD0UiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 16:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjD0UiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 16:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFF02D65
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BCB563FB7
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 20:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51551C433EF;
        Thu, 27 Apr 2023 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682627883;
        bh=vEeCD1eHoeZ/S9/a5BekkgI9S+0CoI+fRi53Exgndqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pIl9eCWmnN7ojvteZeZbcHUBi1fljEZROtuxkWmUbIkoKXctqvLxFloWBKtuMK96C
         K3OFdj6gHo7w2ISZ34zAr6H+cX71knhi1qU4jr5J5uPCtYweu2PeZjUVLPJyPBfwyn
         qvh3ezLNltEYHaOORkwc37pVgcU5BA8Fy8jOcEhA44nygqgzw2HBjY8IrGER7u5KYk
         7tLuvjTv/8PIbRJYms+8zfF27X6C2rR7Tw0mD1rvqQGsNsQ4EYfviT8/7fAYruecAG
         Mt4kDUq1BKJmxtscy0CJBe0BMLLssJC76TsciW49NI5pgvs5V5HMee0AA1BY6f2QRs
         8iTt6ycZ/Z6lA==
Date:   Thu, 27 Apr 2023 13:38:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang Li <liali@redhat.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net] selftests: bonding: delete unnecessary line.
Message-ID: <20230427133750.59977960@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAKVySpyXYUDUtA26pA7A0buCW30VNhgn7aYc+cTXbb9PK=F5oA@mail.gmail.com>
References: <20230427034343.1401883-1-liali@redhat.com>
        <13c54cd1-6fb7-b6b8-79a1-af0a95793700@blackwall.org>
        <CAKVySpyXYUDUtA26pA7A0buCW30VNhgn7aYc+cTXbb9PK=F5oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 15:19:13 +0800 Liang Li wrote:
> Thank you! Do I need to re-send a patch?

Yes, please, net-next is closed during the merge window (i.e. now0)


## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer

