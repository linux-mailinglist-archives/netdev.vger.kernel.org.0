Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C67539CC5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 07:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349744AbiFAFtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 01:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349743AbiFAFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 01:49:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA76B326EA;
        Tue, 31 May 2022 22:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E104CE19D9;
        Wed,  1 Jun 2022 05:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EADC385A5;
        Wed,  1 Jun 2022 05:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654062535;
        bh=6t4my5SVSuWyRsbgRzJu1RWUBtMadQQHSTtdzc6C3Pk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=APXOtnlvafGXZFJGJVqYq+y4Yu8jPQgWVzaAO2X0MNrWVxyI+Dzs47vPx+ACRX5PW
         /Nhklb0VOHr8YNPlDD7CmEo6S+V9nl46RVGW5RHmj3efWrmMboZ7T4OzxWP+ZfV+4b
         0Gahec1c6VhvYhj4B8Puwy11F8EUpTORH4G1UgN5y3YZBD3nqOhVeQhZo1QKaZxSIO
         WgrWCJ1PqRjMlZdUbiexeVTOxjXIltBYhX3EvgJjCfEbsT80lru7KPhQe1cirHRvPc
         7Bs1kFRwxdOO/l9OCyOLTlrTIMA51msed+NkrtiolO04P7egtR6RBystDcjyWzpBtZ
         y+EFe2bUNVQWQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [RFC PATCH v3 1/1] mac80211: use AQL airtime for expected throughput.
References: <20220531100922.491344-1-gasmibal@gmail.com>
Date:   Wed, 01 Jun 2022 08:48:48 +0300
In-Reply-To: <20220531100922.491344-1-gasmibal@gmail.com> (Baligh Gasmi's
        message of "Tue, 31 May 2022 12:09:22 +0200")
Message-ID: <87y1yhszlr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baligh Gasmi <gasmibal@gmail.com> writes:

> Since the integration of AQL, packet TX airtime estimation is
> calculated and counted to be used for the dequeue limit.
>
> Use this estimated airtime to compute expected throughput for
> each station.
>
> It will be a generic mac80211 implementation. If the driver has
> get_expected_throughput implementation, it will be used instead.
>
> Useful for L2 routing protocols, like B.A.T.M.A.N.
>
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>

Please include a changelog to show what has changed since previous
versions:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
