Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D136ABAF4
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCFKJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjCFKJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:09:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF181D931;
        Mon,  6 Mar 2023 02:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85ECD60D39;
        Mon,  6 Mar 2023 10:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B60C4339B;
        Mon,  6 Mar 2023 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678097355;
        bh=PvwO58mgBj3+IJuHLD3nWN6VAFZz7AbN6pge0SfwJ5Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pnIfUSTakNoWKkT+n/4sskZZc/cUlCcVNf5hq6XKOl/VJd8d6/8jbtpa9sccyTHWK
         P2WkxsECXXBiRQefF8HaWj4snQr7MYNcy4Am8yURbfVX/yMy/BmWo87A4Sq96XWudH
         QjWL2D7rJh/NU5AnEnCkCTuty36oKeV1qzbgpSfOo157AT+I/Zq9pDiiwrTbH6EiTl
         rCPobjT3U0bY8crN5J0B/K9ifz2YLvK5p5DG7OSmQjZvAUUzGa+vTdiXt7UDuMOtV5
         jVdfssDu8Di8tgETyN7VrdYrYf7gnGvTLSvNn+tZrcxLnLYrOosUN7WJ9g34wjzli2
         HCPgZkPQr4ZKA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: pcie: Add 4359C0 firmware definition
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230224-topic-brcm_tone-v1-1-333b0ac67934@linaro.org>
References: <20230224-topic-brcm_tone-v1-1-333b0ac67934@linaro.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167809735003.16730.2135671982947382285.kvalo@kernel.org>
Date:   Mon,  6 Mar 2023 10:09:11 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> wrote:

> Some phones from around 2016, as well as other random devices have
> this chip called 43956 or 4359C0 or 43596A0, which is more or less
> just a rev bump (v9) of the already-supported 4359. Add a corresponding
> firmware definition to allow for choosing the correct blob.
> 
> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Patch applied to wireless-next.git, thanks.

e5c3da9abd44 wifi: brcmfmac: pcie: Add 4359C0 firmware definition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230224-topic-brcm_tone-v1-1-333b0ac67934@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

