Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549C75FD4A1
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJMGVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJMGVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D471120BF2;
        Wed, 12 Oct 2022 23:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08889616A0;
        Thu, 13 Oct 2022 06:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E38BC433D6;
        Thu, 13 Oct 2022 06:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665642066;
        bh=Bwb+BgWIiWUfcFQmLH+wu7qHsq3YyIot3Bf4iOUxlo0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IUKGpHWVe95nt+aTub3tQEFM3adfLRl2vxXekWcTccAFzZV1/uYO7RPCK4ApbNq04
         otO6mhE/N24UCT+JGHj3QK7I6ll6vWjh6jDJxYw+1WrIc46xuidNF77BO0fyXsivRd
         HR5g/RKOyCcbmPoPALv8XvwX8cXyKYrDoJjV0wsBxZ2zzyxUwj+5oEUfbpMcN9tj2r
         j/UpRCsTOdKXEd4fjxdNpimQ44vKyE7af2aA7VkeWqj3ODdEericyCWU4KZUmiI45l
         Mc20F+rep2s4d/5fEKbxtDEULQ5f6if/h15Mis16gVwaWWBDuH4L0hn2z3IfXIp89o
         HC9B+AsUHxqtQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Check return value of ath10k_get_arvif in
 ath10k_wmi_event_tdls_peer
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221003091217.322598-1-pkosyh@yandex.ru>
References: <20221003091217.322598-1-pkosyh@yandex.ru>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166564206242.7747.3762641081323577228.kvalo@kernel.org>
Date:   Thu, 13 Oct 2022 06:21:04 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Kosyh <pkosyh@yandex.ru> wrote:

> Return value of a function ath10k_get_arvif() is dereferenced without
> checking for null in ath10k_wmi_event_tdls_peer(), but it is usually checked
> for this function.
> 
> Make ath10k_wmi_event_tdls_peer() do check retval of ath10k_get_arvif().
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

473118917cc3 wifi: ath10k: Check return value of ath10k_get_arvif() in ath10k_wmi_event_tdls_peer()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221003091217.322598-1-pkosyh@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

