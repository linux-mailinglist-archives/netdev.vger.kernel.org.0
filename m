Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6889C6B8108
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCMSqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCMSqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9993F85368;
        Mon, 13 Mar 2023 11:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C54EAB81178;
        Mon, 13 Mar 2023 18:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C5C433D2;
        Mon, 13 Mar 2023 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678733139;
        bh=roAf8HAlZ9310qEP1wz99rUJLUFSSDJmzvkwlWZAuEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S0Wgr4gUfc/sozDE6E1d0tecqNee2kGwwEz0kVMEFHkz7GDhw51v5yxdJrGt7uOEm
         n+jGgq2TUFTsYE4+qPWg9KHW9n8/Mi6fZo3Yu8aK34gnHV+dGf09q5/qJKK5HEjogc
         EwI0TpdC/aFJQ95SkwTmKJQGZphPCCJWhjb7F03zfDBOBZydS35bRnEpcRl85ZarIT
         1gIdFX4gP/lNAyCwQMSsaDbkVzHMIpjAEYpYURwUhUZ3ovezX0n7n44uvkyYCSvHYF
         U0kKFwJ0iViSS4Nig+IvODGqlULmXOezEuAKoe39o+5lODm4Jk1f9U/U6jLu/dbjWo
         YuGAASsnuqnfQ==
Date:   Mon, 13 Mar 2023 11:45:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <20230313114538.74e6caca@kernel.org>
In-Reply-To: <ee08333d-d39d-45c6-9e6e-6328855d3068@kili.mountain>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
        <20230303155436.213ee2c0@kernel.org>
        <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
        <ZAdoivY94Y5dfOa4@corigine.com>
        <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
        <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
        <ee08333d-d39d-45c6-9e6e-6328855d3068@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 11:46:57 +0300 Dan Carpenter wrote:
> This is only for networking.
> 
> It affect BPF too, I suppose, but I always tell everyone to just send
> BPF bug reports instead of patches.  I can keep track of linux-next, net
> and net-next.  No one can keep track of all @#$@#$@#$@# 300+ trees.
> 
> I really hate this networking requirement but I try really hard to get
> it right and still mess up half the time.

Don't worry about it too much, there needs to be a level of
understanding for cross-tree folks. This unfortunately may 
not be afforded to less known developers.. because we don't 
know them/that they are working cross-tree.

Reality check for me - this is really something that should
be handled by our process scripts, right? get_maintainer/
/checkpatch ? Or that's not a fair expectation.
