Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8DC5127EC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 02:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbiD1AIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 20:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiD1AIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 20:08:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7304D83B18;
        Wed, 27 Apr 2022 17:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C3E7B82B32;
        Thu, 28 Apr 2022 00:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34854C385A7;
        Thu, 28 Apr 2022 00:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651104328;
        bh=XwtdpP4ayHPyeA1qU4OKPtrBPh9Keba6AQojYvfouIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQD8QQeX8x+tOhqW35NgKHvFL2qTi99avZeOek4o7lyHxR1GrCbTkGz43W6TpKnHo
         4UGaBu1SelJy6sIKoXm0nDYuCJON1uVQc4GD2xL8kNgu6jvxAvpwsUkT1mKeh4G5NZ
         ffdGJWVyTiTVoTaz2cj5wmv02onwvvP1vG1HL2VxKbqevxFmsWA6k3PWBVviiEUejT
         bKwpkbDprDh017GnYKukhv0S2Emgvf7d8d3K4icoD2xJvnMTUOODg8JRdbm48QUAR9
         CgAmwllXlQfLodVozac8qoaTB7v6iBlZWrpR1SsiCxTEN17GW+lFqKz1HURu7Frsnz
         LSKhKpUxJTWEg==
Date:   Wed, 27 Apr 2022 17:05:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2022-04-27
Message-ID: <20220427170526.57d907d2@kernel.org>
In-Reply-To: <165110050658.2033.16722871450848438620.git-patchwork-notify@kernel.org>
References: <20220427224758.20976-1-daniel@iogearbox.net>
        <165110050658.2033.16722871450848438620.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 23:01:46 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This pull request was applied to bpf/bpf.git (master)
> by Jakub Kicinski <kuba@kernel.org>:

Boty McBotface still confusing bpf and bpf-next PRs :(

Pulling now.

No chance we can silence the "should be static" warnings?

The new unpriv_ebpf_notify() in particular seems like it could
use a header declaration - if someone is supposed to override it 
they better match the prototype?
