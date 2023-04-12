Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53ADB6DECEF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDLHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjDLHuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0759161AC;
        Wed, 12 Apr 2023 00:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC7262EED;
        Wed, 12 Apr 2023 07:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554C5C433D2;
        Wed, 12 Apr 2023 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681285808;
        bh=ri3rmltlry7sXZG0HWrFLS7srDjoutKJ+DI1dim4Th0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=q9qFJBdAz4QXEK7MMlz4lShRdVYWzuAofvFum771baqoXW51TsUm49abk5dmdUcbl
         mcub7ByZnR32hyMDp5aHTwpX/6BKup3pedj11K83aXMGsLI5G+EwAguqbuvng03aPt
         BtgZacw97cfnTiVwaEFyrn8gSKARplPeKmsbVqjv7Gf0hF22j3+1ym++iIQk8yI59E
         TCuFmxZ0ovWdymGbSBOyH5VFDsr0S6sY+JT9vS1evqTLy3b/TK3dxIfQoSWsv/A0Hn
         er4QHnD7sDeE/dRIVerlRKmzNy7ZOIE2gu6TCc92EWJJZtS/boDO6OZQVMomXrM5vP
         xguIrc8iu4tCw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
References: <20230407203752.128539-1-marex@denx.de>
        <ZDGHF0dKwIjB1Mrj@corigine.com>
        <509e4308-9164-4131-4b93-75c42568d1e4@denx.de>
        <ZDHEI7tbjLJiRcBr@corigine.com>
Date:   Wed, 12 Apr 2023 10:50:00 +0300
In-Reply-To: <ZDHEI7tbjLJiRcBr@corigine.com> (Simon Horman's message of "Sat,
        8 Apr 2023 21:44:35 +0200")
Message-ID: <87v8i18rpz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <simon.horman@corigine.com> writes:

> On Sat, Apr 08, 2023 at 06:44:40PM +0200, Marek Vasut wrote:
>
>> On 4/8/23 17:24, Simon Horman wrote:
>> > On Fri, Apr 07, 2023 at 10:37:52PM +0200, Marek Vasut wrote:
>> >
>> > > NOTE: Please drop the Fixes tag if this is considered unjustified
>> > 
>> > <2c>
>> > Feels more like enablement than a fix to me.
>> > </2c>
>> 
>> I added it because
>> 
>> Documentation/process/stable-kernel-rules.rst
>> 
>> L24  - New device IDs and quirks are also accepted.
>
> Thanks. If I was aware of that, I had forgotten.
>
>> So, really, up to the maintainer whether they are fine with it being
>> backported to stable releases or not. I don't really mind either way.
>
> Yes, I completely agree.

IIUC you are here mixing Fixes and Cc tags, if you want to get a commit
to stable releases there should be "Cc: stable@...". So I'll remove the
Fixes tag and add the Cc tag, ok?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
