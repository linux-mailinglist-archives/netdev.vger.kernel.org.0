Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD144DB53
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhKKR5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhKKR5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 12:57:41 -0500
X-Greylist: delayed 16084 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Nov 2021 09:54:51 PST
Received: from relay04.th.seeweb.it (relay04.th.seeweb.it [IPv6:2001:4b7a:2000:18::165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AB8C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:54:51 -0800 (PST)
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 5FF5A1FF01;
        Thu, 11 Nov 2021 18:54:49 +0100 (CET)
Subject: Re: [PATCH] net/ipa: ipa_resource: Fix wrong for loop range
To:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        ~postmarketos/upstreaming@lists.sr.ht
Cc:     martin.botka@somainline.org, marijn.suijten@somainline.org,
        jamipkettunen@somainline.org, Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211111173401.551408-1-konrad.dybcio@somainline.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Message-ID: <3ef6fa1d-6253-2f09-b3f8-abdf6c9c02e6@somainline.org>
Date:   Thu, 11 Nov 2021 18:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111173401.551408-1-konrad.dybcio@somainline.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 11/11/21 18:34, Konrad Dybcio ha scritto:
> The destrination group count was mistakenly assigned to both dst and src loops.
> Fix it to make IPA probe and work again.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> ---
>   drivers/net/ipa/ipa_resource.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
