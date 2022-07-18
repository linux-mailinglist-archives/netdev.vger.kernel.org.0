Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9781E57819B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiGRMIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiGRMIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:08:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85348240A6;
        Mon, 18 Jul 2022 05:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A897B81249;
        Mon, 18 Jul 2022 12:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77871C341C0;
        Mon, 18 Jul 2022 12:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146072;
        bh=agUuMKxjHNvdFE9TlcWJ00oYcJHm1BoBs1S+rJCBZPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fVFfl/i26VdFfWC71sLHpoH/mn0O2hz2ieAF38Ecd4svERqTSZANBlqPz69KznfB0
         qURJoLhFBZq7Wv5M4fp2lpRhVflQa+Y7/e7ZWXMFHyMNyrMsEwHdNhkl5xFmmu5YCz
         sCgVeVoR1EM8Y+V1hA5l1S5CV8bqovxUlGrT94N0r6oW9cdI/AzW+MjZGKWh9MSFiC
         vaDDc3EYrN3qLsIDz07MraW0VFCFwUl1wJW4593U8JGzFqtglMsHRR372o1oXxt6c2
         jlfD4xCg3dyN5/7V0oGOr/rJCMs4RjLFSIR+Lire9kKZ8lngj0k35J9oXyZUcAa0x1
         2sJor296imytw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709133618.25958-1-yuanjilin@cdjrlc.com>
References: <20220709133618.25958-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        angus@akkea.ca, jiaqing.zhao@intel.com, mike.rudenko@gmail.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814606673.32602.13081425182073828932.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:07:48 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant words 'this' and 'and'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

29069fb49837 wifi: brcmfmac: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709133618.25958-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

