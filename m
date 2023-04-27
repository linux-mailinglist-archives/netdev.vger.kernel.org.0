Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C26F0034
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbjD0EfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242831AbjD0EfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FFB420E;
        Wed, 26 Apr 2023 21:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06CFC63A88;
        Thu, 27 Apr 2023 04:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEE9C433D2;
        Thu, 27 Apr 2023 04:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682570117;
        bh=ZWJxz5ju6P+OVD/7NyM+5pJxespwIzDbwPpmWrff8AQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g0cjfv5y37f+NrSBWiH89ab/8q42L903hYb7ePaa9kPABfrRO61HbYi8vC4lkNUCs
         bvXgXyB+CcQc9K1w6M6nkkG30PqNzKs5L9NI+u0p1vVLxY8b1xuTzSXVbKUVGMZ8/h
         s7qfaR3rBfICkl1OSC99qK3+emSwvaRGM8Hs6aAVVDEA86pvQPGJPxWhS1BQ0t8zXG
         mGOPMiy560BfH5hrfUzfs3MJc+1swAWe5yMVIvHjn0+Ns+Xvk9x/mKzzSJnLAZANtv
         FlyFprBecySuLn85aHHzWXvgybWFeUzYZ2Xk/PMIq7CYIEkZ0CVp9QsdzRA59pI+Fa
         lgs7YxiTamPOA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] wifi: ath11k: Use list_count_nodes()
References: <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
Date:   Thu, 27 Apr 2023 07:35:09 +0300
In-Reply-To: <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Wed, 26 Apr 2023 22:48:59 +0200")
Message-ID: <87v8hiosci.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> ath11k_wmi_fw_stats_num_vdevs() and ath11k_wmi_fw_stats_num_bcn() really
> look the same as list_count_nodes(), so use the latter instead of hand
> writing it.
>
> The first ones use list_for_each_entry() and the other list_for_each(), but
> they both count the number of nodes in the list.
>
> While at it, also remove to prototypes of non-existent functions.
> Based on the names and prototypes, it is likely that they should be
> equivalent to list_count_nodes().
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Un-tested

I'll run sanity tests on ath11k patches. I'll also add "Compile tested
only" to the commit log.

Oh, and ath11k patches go to ath tree, not net-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
