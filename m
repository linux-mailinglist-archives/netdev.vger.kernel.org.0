Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448C76B794E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCMNpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCMNpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:45:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F059B136C3;
        Mon, 13 Mar 2023 06:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A30E9B81116;
        Mon, 13 Mar 2023 13:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56300C433D2;
        Mon, 13 Mar 2023 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678715139;
        bh=I4zY+LXnuFUjxJbu4LZ94Kpb5enSTyc03lUFn1B00eU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TF4Mc1GkldghFxjdBHUNKnHFvoOTJDPaqOAtHRLO5unZQ3ktIjgKjAGAliyaQ5e9K
         jN6yx8QEdR8QxJbNmvkHxFLfLGURCm9qLDZa1jrPK7HKKCtkyjbzirLeYBYPWTfsdF
         B7VbdOsgb5tY26ESYBwmEHl7aqGXLY7PXZxv5dSX+j/7Zt/Kb09KlWDk93/mYWeD9G
         LYd6TnRb9SxF+i6CrFSfBIq1SVLoM6HcX+IE+xdJKdsuEKQWixDCQe/9ErsMYbyotf
         d+sCe35aTH0EKgPzxQQnl4ZRSi0aVBh7CdEJTbiFEjn7zJy/qkIjz3gJwr86gDQqAf
         JFN45QHN8tFFA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rtw88: fix memory leak in rtw_usb_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230309021636.528601-1-dzm91@hust.edu.cn>
References: <20230309021636.528601-1-dzm91@hust.edu.cn>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167871513564.31347.632153019551010162.kvalo@kernel.org>
Date:   Mon, 13 Mar 2023 13:45:37 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> wrote:

> drivers/net/wireless/realtek/rtw88/usb.c:876 rtw_usb_probe()
> warn: 'hw' from ieee80211_alloc_hw() not released on lines: 811
> 
> Fix this by modifying return to a goto statement.
> 
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

48181d285623 wifi: rtw88: fix memory leak in rtw_usb_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230309021636.528601-1-dzm91@hust.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

