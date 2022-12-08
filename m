Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7164723F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLHOyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiLHOxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:53:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADE58C6B3;
        Thu,  8 Dec 2022 06:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A03461F6E;
        Thu,  8 Dec 2022 14:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6C0C433B5;
        Thu,  8 Dec 2022 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670511229;
        bh=NFtkawferRCuVtsF/S8GA8PeJYS5gw8p6/Iw4nU7lBU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jptKTexdF7ia3A1EWZpUy8IWWeby29awyP+el5cEnKFUgMiIcuSIZiTthOlfNAyIB
         YYoBIfVhrrofG74bfSnPwDZm2ykOfZHTCjMHJRe/1oQT1420QtKX/dxZzIRIxOicYh
         zoA/8cuRe4+pf+Xy3rey47SP8sfpwJ8BeolfIpjsxyG84Md0eau0JJdrEkF0yfHl+A
         SynrC0nYUojWW/S/KfluRQkz9haaEa6dLMyEq8LjddXD9vEnxHGwk2LgfvUEllmUg+
         Lfc36pBvR/nU92QEWMuNA2jivu1AeoQ6PS8xISPEVSMBKYHQflAaxmQj+FwE5Hr7ns
         62GSo9JgUGgsA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jun ASAKA <JunASAKA@zzy040330.moe>,
        Ping-Ke Shih <pkshih@realtek.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051122141.9839.8256110387408123706.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:53:46 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jun ASAKA <JunASAKA@zzy040330.moe> wrote:

> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
> issues for rtl8192eu chips by replacing the arguments with
> the ones in the updated official driver as shown below.
> 1. https://github.com/Mange/rtl8192eu-linux-driver
> 2. vendor driver version: 5.6.4
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

695c5d3a8055 wifi: rtl8xxxu: fixing IQK failures for rtl8192eu

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221207033926.11777-1-JunASAKA@zzy040330.moe/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

