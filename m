Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D10C475AA2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbhLOO2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:28:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54272 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243352AbhLOO2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:28:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 394F8B81F23;
        Wed, 15 Dec 2021 14:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0C0C34605;
        Wed, 15 Dec 2021 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639578518;
        bh=jS1rXz3m/Z+lDbF3WHhlKToTdimzp7WYV8lBznrDmRM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Sf/SiWGw9Y1b2+fGAsZABfXtneeeuOPwQSDeZ1Vh8ZOIaEvr2eCIrdIwjVbRRTezn
         V57Bl8W7I66YYeYgbfNacxmIeVj3tjvNWMDshHSPtglcr298ldFAju+kJNiX+JspuI
         ajfCLrzm+z3Ju2M1hEmFumvouNsc9w1f2TERx0ptSFGrBhWG+Hy4EsCGeuEqwloiX/
         uji6SKZWqUTpq1Hi+sVN5AStChiAZPSk8Fj4BBSx9QoS70jf+VGQCkEDlSTMSwnq8M
         bJJ7U6bj2TmDBRDQEWSZnOTMLA3gPKUOsxg38oXtnaVCfK4eBXleiZ6LQHdJrfyegn
         rKw8Jzp6nrf0g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix array out of bound
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211208095341.47777-1-zhangyue1@kylinos.cn>
References: <20211208095341.47777-1-zhangyue1@kylinos.cn>
To:     zhangyue <zhangyue1@kylinos.cn>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163957851444.6130.11829040584671370301.kvalo@kernel.org>
Date:   Wed, 15 Dec 2021 14:28:36 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhangyue <zhangyue1@kylinos.cn> wrote:

> Limit the max of 'ii'. If 'ii' greater than or
> equal to 'RSI_MAX_VIFS', the array 'adapter->vifs'
> may be out of bound
> 
> Signed-off-by: zhangyue <zhangyue1@kylinos.cn>

Patch applied to wireless-drivers-next.git, thanks.

4d375c2e51d5 rsi: fix array out of bound

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211208095341.47777-1-zhangyue1@kylinos.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

