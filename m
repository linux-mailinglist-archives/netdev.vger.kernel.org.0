Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626806ABB29
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCFKKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCFKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A915822787;
        Mon,  6 Mar 2023 02:09:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6330160C63;
        Mon,  6 Mar 2023 10:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18298C433A7;
        Mon,  6 Mar 2023 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678097385;
        bh=1io4VW9Te7Dq5kQHLfFajoTl5UVA+0Th0RmGw4q+7dE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NwTXuTP6FRAKh+L+ZPyNZOXR4WBvNaOpf+btbOT1xBAMWWA2WO3Kh583wTCzkJRZM
         I8bbru2T0SqGQixUInQiBGo6xSPQWEx6XflQlsRg7Ayl21kfRc320l6D8S7hPC4mdr
         SGtYcpAWsGJ5hW0yl5ptGGcvFxjtBDwDsLAJIT05rFJ0KEosJdDyym6+7NgCJQi1ff
         7F1u2JJY/1MDbc53l6dfL9yGrG7KkCa6n/Kar7gVkh4L9h2SlHYolSU9jGYV6TxrRx
         zolGTMCXcVRGf02wD/Q9kqALMcfnbxBzmuzZVIbMo7laLUhzAUPNciUe3Q/jsKNSfF
         NcbQyhDR23zig==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1 wireless-next 1/2] wifi: rtw88: mac: Return the
 original
 error from rtw_pwr_seq_parser()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230226221004.138331-2-martin.blumenstingl@googlemail.com>
References: <20230226221004.138331-2-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony0620emma@gmail.com,
        Ping-Ke Shih <pkshih@realtek.com>, Neo Jou <neojou@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167809738202.16730.6601200631730210566.kvalo@kernel.org>
Date:   Mon,  6 Mar 2023 10:09:43 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> rtw_pwr_seq_parser() calls rtw_sub_pwr_seq_parser() which can either
> return -EBUSY, -EINVAL or 0. Propagate the original error code instead
> of unconditionally returning -EBUSY in case of an error.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

2 patches applied to wireless-next.git, thanks.

b7ed9fa2cb76 wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
15c8e267dfa6 wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230226221004.138331-2-martin.blumenstingl@googlemail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

