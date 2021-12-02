Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060E7465E55
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbhLBGn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbhLBGn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 01:43:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BEAC061574;
        Wed,  1 Dec 2021 22:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C972DB80D51;
        Thu,  2 Dec 2021 06:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F5C00446;
        Thu,  2 Dec 2021 06:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638427202;
        bh=1BNLT3Q1+5jsUhS7n37+CSiLbxMZIe6yO1mKFYbg0pQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z7pia+BFp+fv2V7Jbp2EDweH9KZUrhJ5koDlxptoqcgkL6byz/25nQO1K/3ylo0NQ
         XVWubHv/uvCMHyq31Nl0qwjCd0es1lWAjfrqBerH/eH76lFbaRU8xXA4spGCYhvnPN
         ice6gqtI3KSTechLqZTAGZh44ed8S7RNPnAQScqk8TetqILf0dIZfI09KEpBZJ9HgX
         ob4LwryzUPDHFlgOqosSOENf8kmjh90XeL8V8vuknOY+SIUXnPZCDNHWxr7/GPFVqi
         2yOybtJ++HxvxizvyfJ5DaKc8eHDqviuxuvZdmFumbBtmKVMnU74bTZgcUaec7bD/4
         hFYiMfk1uR/Ig==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] wireless: Clean up some inconsistent indenting
References: <1638414076-53227-1-git-send-email-yang.lee@linux.alibaba.com>
Date:   Thu, 02 Dec 2021 08:39:56 +0200
In-Reply-To: <1638414076-53227-1-git-send-email-yang.lee@linux.alibaba.com>
        (Yang Li's message of "Thu, 2 Dec 2021 11:01:16 +0800")
Message-ID: <8735nbqzlv.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> writes:

> Eliminate the follow smatch warnings:
>
> drivers/net/wireless/marvell/mwifiex/pcie.c:3376
> mwifiex_unregister_dev() warn: inconsistent indenting
> drivers/net/wireless/marvell/mwifiex/uap_event.c:285
> mwifiex_process_uap_event() warn: inconsistent indenting
> drivers/net/wireless/marvell/mwifiex/sta_event.c:797
> mwifiex_process_sta_event() warn: inconsistent indenting
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c      | 2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_event.c | 2 +-
>  drivers/net/wireless/marvell/mwifiex/uap_event.c | 2 +-

The subject prefix should be "mwifiex:", I can fix it.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
