Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA31582521
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiG0LGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC539BCB7;
        Wed, 27 Jul 2022 04:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893DC618E1;
        Wed, 27 Jul 2022 11:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC9BC433D7;
        Wed, 27 Jul 2022 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919963;
        bh=LS1KLm7wDdF2ou3i7iBwkSLEUSAmprWv5RA1lqRiBzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IRztXjfI9B6Qt+ch2FnAESvCv1QrInr377lvU2uVVn8Aw9FbNfgLVxPHKvhLs4vFD
         yXKQqNecUTBOWqepIJNgewoam98yDlRJWc42RcsV4OFdAnMg7cvtwlbII03RXdZcyt
         zl4ZNuJqpwNHdzpT1cqsyPyAmjE8R55Uljdwc2z7DA1grL/BLxZk7AvdV9FbxEMAM/
         gcF98vpJ8REU1fTONaU+KRbWDOSXqGwJUeF1UuUX6kiFQI3Jzws2fUGHLwtIRN01eF
         V4aiWFJmlfIyE9d/Bz5Yo7uNsQ/YuM11s8UTZkFCFNXrPzq392/uDV+suOuNvzWkoV
         pPR8RyyTmAsog==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: Remove duplicate word and Fix typo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220622082524.21304-1-jiaming@nfschina.com>
References: <20220622082524.21304-1-jiaming@nfschina.com>
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891995972.17998.1161911298744891014.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 11:06:01 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Jiaming <jiaming@nfschina.com> wrote:

> Remove duplicate 'in'.
> Change 'entrys' to 'entries'.
> 
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>

Patch applied to wireless-next.git, thanks.

8a7a5c0251e1 wifi: rtlwifi: Remove duplicate word and Fix typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220622082524.21304-1-jiaming@nfschina.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

