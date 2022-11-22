Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CF863347C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiKVEgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiKVEf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:35:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4EE23E82;
        Mon, 21 Nov 2022 20:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F6961516;
        Tue, 22 Nov 2022 04:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA9BC433C1;
        Tue, 22 Nov 2022 04:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669091727;
        bh=PDtlbocrwoXmgOx6Nh/7xgeFTsn0/E2BmW82h1T5idk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FW5KeiH1LvUUVYcUG6FAyNpYcfjk2mLeVKSvn/mYqDIrqDemNRKZ5vx8Q51cm5KvE
         tLSwXLPkELamNX3AJa5CyI69CRyQZiiOSJAVcfy/SQtp/ox9bLSA0zCuEfRKMvuwI4
         Tr8NYo9JZDd8V5ANC+5AZ8v/HTwF1HYU8Pv4fK80zs6fb3phKXVgan6tnroOtd2bod
         w504/ijneM9joH+aW0GoMsZZ65f5NmyV3D0LMH3zVul42u9NAvZqvqKKfaZ6HvbZNs
         8kdLkO2cH5eZwy9B7zFgYnuRETlO05g4gjKza4VJPZ6RarTT5hhGJJCE0exMn4S3Rb
         oCXVdp41nheBg==
Date:   Mon, 21 Nov 2022 20:35:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        John Fastabend <john.fastabend@gmail.com>, toke@kernel.org
Subject: Re: [PATCH 0/2] Revert "veth: Avoid drop packets when xdp_redirect
 performs" and its fix
Message-ID: <20221121203526.00e3698a@kernel.org>
In-Reply-To: <20221122035015.19296-1-hengqi@linux.alibaba.com>
References: <20221122035015.19296-1-hengqi@linux.alibaba.com>
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

On Tue, 22 Nov 2022 11:50:13 +0800 Heng Qi wrote:
> This patch 2e0de6366ac16 enables napi of the peer veth automatically when the
> veth loads the xdp, but it breaks down as reported by Paolo and John. So reverting
> it and its fix, we will rework the patch and make it more robust based on comments.

Did anything change since the previous posting?
