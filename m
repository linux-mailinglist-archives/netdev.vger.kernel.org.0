Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0AC5ED6B3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbiI1HtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiI1Hs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:48:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41AB1280FA;
        Wed, 28 Sep 2022 00:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9FF10CE1D69;
        Wed, 28 Sep 2022 07:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2735AC433C1;
        Wed, 28 Sep 2022 07:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664351128;
        bh=d8cUuUPU8Gx5F6dT9KlT55nEuvcdQFanccxvkAG225g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D6vo9YVF4TV3wzXxqtJb9UOZXCgN3nMvWTeDR8gS3ceORL2ZDHbHSClTtxFh35kh8
         q08yW+5HYXmshbHx8Lztck4wqlIANulemdL09N9TXluJSRyyzmjcym+92JzjX56Wt2
         4Bmu1sDOX7hnoLbZYtZR6RPThs63U+xzGCA9M0tUDH5+aPN7GPElM2CinUd7irL7jV
         MpOkynj7o+vjZL8iCrKVZFBT4dLrnbO9W852lQlJUEo9P2sEPtRnnnV63GiVdCNO1N
         ANh6sg40bHm0ZBTwFX9UAAKKtHEBueqo2pJ5PMpKvm3RxZ9zfilUyNmfWrEG5g9VAb
         2rI3Iqb8B5iPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wil6210: debugfs: use DEFINE_SHOW_ATTRIBUTE to
 simplify
 fw_capabilities/fw_version
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220922142858.3250469-1-liushixin2@huawei.com>
References: <20220922142858.3250469-1-liushixin2@huawei.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166435112526.3623.17623257878272432718.kvalo@kernel.org>
Date:   Wed, 28 Sep 2022 07:45:26 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Shixin <liushixin2@huawei.com> wrote:

> Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
> No functional change.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e5398f92d1ca wifi: wil6210: debugfs: use DEFINE_SHOW_ATTRIBUTE to simplify fw_capabilities/fw_version

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220922142858.3250469-1-liushixin2@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

