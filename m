Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228DC69F482
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjBVM23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 07:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBVM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 07:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60F76594;
        Wed, 22 Feb 2023 04:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68EFAB80B46;
        Wed, 22 Feb 2023 12:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1411CC433EF;
        Wed, 22 Feb 2023 12:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677068899;
        bh=ugSE0ju1zdiImMeAGhi+a+Ehwcs0Fs20OXXyiY6O49U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WTUkUH1uyOmr3CThWw5cQX9K6uBOwcmyjDW0q+VtwXThE0/GG0TKyxkGdQ7l3PzKY
         eI6xbMOk9TEp6/0XRZfu/aO5epY8pKlr2ngbfgtW/8s9q661XqgCfPHHRPVdfK5RgX
         6rY4p2w9NPoDFPSqj/m6zNYEfPoHhJjP1YfENgRgaNH89kDakRmGoS1LK6G218pHeq
         3ejrxSIbQPdQqBuXK7DL0tY26ZF9EYDwk6Ced58KUOFtY37HpqGs6BOEUva5hMevOt
         PvEmpl2hU/32HYwRFHvImpWVWA+MWms/kPiexTXqXw7Ht9ZOtVA+hMZvj3o5xbRzFK
         H8vGpUU41Nxhg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM
 values
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214063602.2257263-1-jiconglu58@gmail.com>
References: <20230214063602.2257263-1-jiconglu58@gmail.com>
To:     Lu jicong <jiconglu58@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu jicong <jiconglu58@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706889446.20055.15648946753748423220.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 12:28:16 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lu jicong <jiconglu58@gmail.com> wrote:

> On OpenWRT platform, RTL8192CE could be soldered on board, but not standard PCI
> module. In this case, some EEPROM values aren't programmed and left 0xff.
> Load default values when the EEPROM values are empty to avoid problems.
> 
> Signed-off-by: Lu jicong <jiconglu58@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

59e6ded57cc1 wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214063602.2257263-1-jiconglu58@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

