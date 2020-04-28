Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB01BCEBD
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgD1VcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726800AbgD1VcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:32:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCB9C03C1AC;
        Tue, 28 Apr 2020 14:32:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 989C81210A3FB;
        Tue, 28 Apr 2020 14:32:06 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:32:05 -0700 (PDT)
Message-Id: <20200428.143205.1990723843043287086.davem@davemloft.net>
To:     ndesaulniers@google.com
Cc:     natechancellor@gmail.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] dpaa2-eth: Use proper division helper in
 dpaa2_dbg_ch_show
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKwvOd=cb-dyWGeMoCE4+zdgA1R=t=QPkzU9EGiCtgdzXke_cw@mail.gmail.com>
References: <20200428174221.2040849-1-natechancellor@gmail.com>
        <CAKwvOd=cb-dyWGeMoCE4+zdgA1R=t=QPkzU9EGiCtgdzXke_cw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 14:32:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 28 Apr 2020 11:34:11 -0700

> On Tue, Apr 28, 2020 at 10:43 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
>>
>> When building arm32 allmodconfig:
>>
>> ERROR: modpost: "__aeabi_uldivmod"
>> [drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!
>>
>> frames and cdan are both of type __u64 (unsigned long long) so we need
>> to use div64_u64 to avoid this issues.
>>
>> Fixes: 460fd830dd9d ("dpaa2-eth: add channel stat to debugfs")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1012
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Don't forget reported by tags to show some love to our bots! Thanks
> for the patch.
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Applied to net-next, thanks.
