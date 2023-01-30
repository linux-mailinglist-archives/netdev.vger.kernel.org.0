Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454E6681ACE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbjA3TvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjA3TvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:51:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6739245896
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B72D6123D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAC7C433EF;
        Mon, 30 Jan 2023 19:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675108263;
        bh=PmaMdL2bNHPkAzFjW5sT5x3yeoIaLGPc1688POO6gwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJS7XPz557rjWRPDem9kNh6G0gqWENqVWf+rQGv5GD7S5rtG/a7s7UdDL3onCxJv0
         z4aITdHNKpWQK+i8kvFo4uk7JJAx40cGYcj5aMX6Iazhl1ZqLnviQJJmphOM3ue+84
         sekFS7722p2EHyW+BA+NkLM7IA7WYL6kL+BDhHqi/sc79r13jrFPLvslw3kr7N+LYM
         Uk9DC3+byx2wsRK+REI2V/ghKtmsNNfkZ11Xdz4Es2CPfBz8154QCMZSY49fddcQ3u
         Tw3iBJ7z3m+4pK/NSKAh95nssWqx6KXlf/C4eLiiz7wXLsvcE8S32r3MVP2prKKEwm
         tbXVdp56D7opQ==
Date:   Mon, 30 Jan 2023 11:51:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 00/13] tools: ynl: more docs and basic ethtool
 support
Message-ID: <20230130115102.4baac908@kernel.org>
In-Reply-To: <Y9gcN9agk89c2K3l@google.com>
References: <20230128043217.1572362-1-kuba@kernel.org>
        <Y9gcN9agk89c2K3l@google.com>
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

On Mon, 30 Jan 2023 11:36:23 -0800 Stanislav Fomichev wrote:
> One unrelated thing that maybe worth mentioning is that /usr/bin/python
> is no more on Debian and there is only /usr/bin/python3, so maybe worth
> changing the /usr/bin/env shebang to python3? (although I'm not sure
> what's the story overall with 2->3 migration; archlinux has a  
> python->python3
> symlink).

I run into that on CentOS as well, even tho on Fedora either way works.
I'll send a separate patch. Thanks for taking a look!
