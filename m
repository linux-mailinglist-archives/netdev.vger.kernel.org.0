Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1B16D227C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjCaO0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjCaO0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:26:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6A91F786;
        Fri, 31 Mar 2023 07:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1785F62997;
        Fri, 31 Mar 2023 14:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3246EC4339E;
        Fri, 31 Mar 2023 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680272776;
        bh=ewI0YO1lqUjVj+mEEU98/eSZvXh5M/9VkRv94eEDfH4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SXhoiMoY9P+xQnHBzX5ok+e4ktg+c/08qYqzzylSTNEbzqqwxV9XM9tBNOCJxk+DF
         UXTb5lu3Qba/lYwtakLvkvK35Yz5VESYAfAEQk+D7Xfz+8iXJi4ITfW9YGW+e2MyHM
         cDdGkbuXqjJbb4JZlxQkIPSDQJirw5cwaGk1aJGj8C9l3fHkotcJog1jJTX+VM09gu
         uZmXtMALJ/G8olLePX4zLjQdZ2CLjBem714wH7AOMdXZFEgPnS9gud5ZZ3H1FKA0Rj
         xZpNw307gTSvRfHJRUK9i7Hf5E3aaAgLrIgpBF9Fgf/bUF31QOhDX9urcCeGO5Ci+0
         TdjJnkbS6RnOA==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array member
References: <ZBz4x+MWoI/f65o1@work>
        <a3bfa2dd-cb4c-876e-b16a-e9cec230108f@embeddedor.com>
Date:   Fri, 31 Mar 2023 17:26:08 +0300
In-Reply-To: <a3bfa2dd-cb4c-876e-b16a-e9cec230108f@embeddedor.com> (Gustavo A.
        R. Silva's message of "Thu, 30 Mar 2023 14:04:42 -0600")
Message-ID: <87mt3tatfj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Friendly ping: who can take this, please? :)

rtlwifi patches go through wireless-next, so usually me.

Please be patient, it's only a week since you submitted the patch. We
sometimes are busy and cannot take patches immeadiately. These friendly
pings are just annoying, you can check the state of a wireless patch
from the patchwork link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
