Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17715379B3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiE3LVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiE3LVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF80F1EC48;
        Mon, 30 May 2022 04:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89E2F60FF6;
        Mon, 30 May 2022 11:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C879C385B8;
        Mon, 30 May 2022 11:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653909661;
        bh=UqyPEInCEPXI76RocK9+Or7vaLi+1BthGegONWtDbSk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CndpQp9lYSCKugc9kfd7Ls2RKaDL/Y3O2dIDYaeVc3EjSkBcQ/6zHYtklQl63I7M4
         ykCLFihhpQNcXmoKOr8K9OICZyTfbtAucDG5OlahOtCa/L4ahmuoD29vI+D/J++SCS
         yos0QGvMUhUfbLEHxqccwsJUW6+057+U9LMgqsOdI+4KijG6h5zyFNCV9TVp1aDQQN
         juFMxrM+3gDJCck7oX1ZV8qvol+cihoS0EsV5PtspGITaV5I7vA1QJN+d/c/5G1j9X
         qarizZysQG5S9TjYVGAr9VQPRexsr6fpZVcHi8sa7hYw/TnGVGtNZ8lIvHu1kSSp1e
         1hr5W5y7kntxg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath6kl: fix typo in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220521111145.81697-14-Julia.Lawall@inria.fr>
References: <20220521111145.81697-14-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165390965375.3436.6595451115191931176.kvalo@kernel.org>
Date:   Mon, 30 May 2022 11:20:58 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9f855efd9a7b ath6kl: fix typo in comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220521111145.81697-14-Julia.Lawall@inria.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

