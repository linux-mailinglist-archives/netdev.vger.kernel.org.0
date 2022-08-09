Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425CC58D371
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbiHIF7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 01:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbiHIF7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 01:59:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED31F2EB;
        Mon,  8 Aug 2022 22:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 148A2B81071;
        Tue,  9 Aug 2022 05:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6605C433C1;
        Tue,  9 Aug 2022 05:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660024755;
        bh=GH83vdhE9GLRwEsTC0EAguqWeme/yN2FDtgFcb4nEmQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HiVnj3C8Kvfy29DmtvJ+c3DNXEvnTPzG6m8KXfxeOFM3mn/J0KoIlrznM/I1Bc+Qh
         MC8aSIFKS95jDa7OkArHeft5Uqi/DiX9ZyMSDWJFEpG8NlEdPZh+cdvl4sjjIXC7c2
         wYLbQbt2bOcENoSW9oqCdaQBRve9BGq+hhooqnUFiU1HcdCw0/7VMnL8BMXbcHeYQo
         gDO563bZMdIKbMyQebYLrKa8K20n78M3FGQ3qxBS3xLQCBTbjAAMZFgZa1Hxd96RBw
         TMfHBbVIBs/90Dafs2aU3B6p3y8t1hlhmp3a4uCeafLEV7F4xb6CsyJo1+BuPkZPpG
         a8VpfHF2Vm1HQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmsmac: remove duplicate words
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220731225850.106290-1-RuffaloLavoisier@gmail.com>
References: <20220731225850.106290-1-RuffaloLavoisier@gmail.com>
To:     Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166002475070.8958.11457867749640806800.kvalo@kernel.org>
Date:   Tue,  9 Aug 2022 05:59:12 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ruffalo Lavoisier <ruffalolavoisier@gmail.com> wrote:

> Remove repeated 'to' from 'to to'
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>

Patch applied to wireless-next.git, thanks.

0cf03f1b432d wifi: brcmsmac: remove duplicate words

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220731225850.106290-1-RuffaloLavoisier@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

