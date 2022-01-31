Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D314A4AE9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379826AbiAaPsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379829AbiAaPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:48:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61024C061714;
        Mon, 31 Jan 2022 07:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35430B82B69;
        Mon, 31 Jan 2022 15:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC967C340E8;
        Mon, 31 Jan 2022 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643644108;
        bh=UEyOLWVv7sUa8s8Vg4pqOex28F3C6UYc40hvcG9wAMQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QsRFTm8EkxymwJR7M8Iejww7nhnrsu1rZuWCQ69ACtTsYZF9B7Ca4Md/2/bwKLPUF
         zGSkwyKFXuCb/YhQgShh3/Rae7NuCAIt0mTVsk0F6GQ74RZ3NjmwoUx+Akjk9CkvD/
         A8b2ligKCmrJQNvNMUjFO2bfWboAeVMgsrVy9rXjMjE3P7zGZ79KE/rIPSXZ9KfcJY
         RnFLtRludons5KQwGrTNHUdO+sJcBtFp8E/hVlfL/FUVQ2bot25kiH7PvCDioTc0wM
         Hlmrz+EVi8hoLsmg6pZ1tmzqNe8wmvNbr6OrvGGXf14C52uDW9EJ3ZJtzmwfypAX1v
         vTRPcDc/2OLiw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wilc1000: use min_t() to make code cleaner
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211222070815.483009-1-deng.changcheng@zte.com.cn>
References: <20211222070815.483009-1-deng.changcheng@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     ajay.kathat@microchip.com, cgel.zte@gmail.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        deng.changcheng@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, zealci@zte.com.cn
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164364410401.21641.11538427900323663636.kvalo@kernel.org>
Date:   Mon, 31 Jan 2022 15:48:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Use min_t() in order to make code cleaner.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>

Patch applied to wireless-next.git, thanks.

708db268459f wilc1000: use min_t() to make code cleaner

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211222070815.483009-1-deng.changcheng@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

