Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7BA4F62EA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiDFPOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiDFPNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A3A5157B3;
        Wed,  6 Apr 2022 05:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B9E619AF;
        Wed,  6 Apr 2022 12:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43586C385A3;
        Wed,  6 Apr 2022 12:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247272;
        bh=qyZ9AYOMwCdHEOHTI0k1UmaT9fMUcZsXkV8dbGjNtOo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TkvO/07TjPSngk6jdULAnCyXGGMMEitdC3dkpQFfUlNMfYn/DmKfWzhlcEoeWXGEz
         U6d+ZtXEnCu8lpgPd9CjxFWMe2+00LGKo+u28QJxXiBARmRTo/c8admekhSt6nFo26
         fVX4yAPlOWzWZ+y/aa3qZqUC45dWUWGqs/VWVRUEYEmrrYHSn59rYvbms5AazxRCga
         ttsuBQvvzOQ57IJUqatNukmU3OODfccSkgvDP7HiU2OOFBx4GpFX8KkzpHKpvW4FP4
         6NihZzIEchc/1EacXPhusZC43bTHsrvXlUX1D8cr8Tx78jaV2H/U395tSiF/emWRzd
         KBT7z/B0PNq4w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] b43: Fix assigning negative value to unsigned variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1648203315-28093-1-git-send-email-baihaowen@meizu.com>
References: <1648203315-28093-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924726846.19026.10101315161220642062.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:14:30 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haowen Bai <baihaowen@meizu.com> wrote:

> fix warning reported by smatch:
> drivers/net/wireless/broadcom/b43/phy_n.c:585 b43_nphy_adjust_lna_gain_table()
> warn: assigning (-2) to unsigned variable '*(lna_gain[0])'
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

Patch applied to wireless-next.git, thanks.

11800d893b38 b43: Fix assigning negative value to unsigned variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1648203315-28093-1-git-send-email-baihaowen@meizu.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

