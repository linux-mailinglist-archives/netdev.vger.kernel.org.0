Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0912464142F
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiLCE7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiLCE7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:59:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3527C5E00;
        Fri,  2 Dec 2022 20:59:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E3E260F7D;
        Sat,  3 Dec 2022 04:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737D9C433D6;
        Sat,  3 Dec 2022 04:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670043588;
        bh=iDabNK+qHFzYeXCjIx3inwDEOC5l3HWEnuS+ahRLzLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A7XUbRZJj38kac+2/ow9JcavYG1D5Mw5WfPFDDus4nvPfAxLnyoRD3rDa/92VpbJ+
         zPuPOLx3aGYY3eLmvf7r2nR2P1cFSldaBwrWPa0LomXXvhX1Ns64zrcdEhy9Ow0Z3k
         guRDUO7FWRJaE/FQeJ/s2a0qASAEYVXvylMYOI/ghUCg3Nz7ZOEdivHsh4ArRYLjyE
         7eZx5MorWcmys4rRTPc1Zl6y4S7r1m8sNzqEyB49G66sLy5CtotPg1qWu09qlAQWd+
         VO6Clqfq5ZmBYySDnJHnEgmOwIHEKkpIuBgPk2M86BzmtcW1J4X9tVYYmW+kgq4Ayj
         okAkLpU21j4Ug==
Date:   Fri, 2 Dec 2022 20:59:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] net: sched: fix a error path in fw_change()
Message-ID: <20221202205947.7175aad1@kernel.org>
In-Reply-To: <20221201151532.25433-1-liqiong@nfschina.com>
References: <20221201151532.25433-1-liqiong@nfschina.com>
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

On Thu,  1 Dec 2022 23:15:32 +0800 Li Qiong wrote:
> The 'pfp' pointer could be null if can't find the target filter.
> Check 'pfp' pointer and fix this error path.

Sounds like a fix, we need a Fixes tag.
