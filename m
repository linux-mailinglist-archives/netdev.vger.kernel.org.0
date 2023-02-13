Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9A6694AD7
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjBMPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjBMPQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:16:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA741E9CA;
        Mon, 13 Feb 2023 07:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57BF061019;
        Mon, 13 Feb 2023 15:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73E9C433EF;
        Mon, 13 Feb 2023 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301382;
        bh=HRfHImk5mlCJ91SQ2Wunn6A/SDSLLmIX1XY2IxtxsJk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=F7prc1UdojEHtYH9j3xz+IRaL1Y1109jIUo5F795Cd5CCXfa5slq8doNX2GuNMPyI
         ME9fFK0QTWNt+jj2gpr3hDkMJtW4+BvnOp9m249Cr37i25M9JuFwYX/KIO/X7rFtEf
         05n9B7qgRRXDMeTj/ei/XF/xjVBq3Frj+N6klUkWshl8ItvqF00smakAQTd9smujbZ
         mbxL2irEBy+zWq25pIixSn5p6mdJkEEYmHcaTWKCU+zBKF1KVgl+CsUKsprGKtqVR/
         l/7lWriTUG1H09vS4pLtiUSB3wnw/XoupRhpVa7PfXciTytxVcyhzENkIn4r/3mmug
         /vjXKpWlhLCqQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/4] wifi: rtw88: pci: Use enum type for
 rtw_hw_queue_mapping() and ac_to_hwq
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230204233001.1511643-2-martin.blumenstingl@googlemail.com>
References: <20230204233001.1511643-2-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630137893.12830.1578587567778747590.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:16:20 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
> rtw_tx_queue_type. Change their types to reflect this to make it easier
> to understand this part of the code.
> 
> While here, also change the array to be static const as it is not
> supposed to be modified at runtime.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

4 patches applied to wireless-next.git, thanks.

6152b649a708 wifi: rtw88: pci: Use enum type for rtw_hw_queue_mapping() and ac_to_hwq
c90897960c19 wifi: rtw88: pci: Change queue datatype to enum rtw_tx_queue_type
7b6e9df91133 wifi: rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
24d54855ff36 wifi: rtw88: mac: Use existing macros in rtw_pwr_seq_parser()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230204233001.1511643-2-martin.blumenstingl@googlemail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

