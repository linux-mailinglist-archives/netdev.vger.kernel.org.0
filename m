Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4249A3AF54A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhFUSom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhFUSol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:44:41 -0400
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Jun 2021 11:42:27 PDT
Received: from relay04.th.seeweb.it (relay04.th.seeweb.it [IPv6:2001:4b7a:2000:18::165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298ECC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 11:42:27 -0700 (PDT)
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 751201F8A3;
        Mon, 21 Jun 2021 20:42:25 +0200 (CEST)
Subject: Re: [PATCH net-next 4/6] net: ipa: FLAVOR_0 register doesn't exist
 until IPA v3.5
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, jamipkettunen@gmail.com,
        bjorn.andersson@linaro.org, agross@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210621175627.238474-1-elder@linaro.org>
 <20210621175627.238474-5-elder@linaro.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Message-ID: <e67db5ea-2664-c78a-e468-aa82cd625cf9@somainline.org>
Date:   Mon, 21 Jun 2021 20:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210621175627.238474-5-elder@linaro.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 21/06/21 19:56, Alex Elder ha scritto:
> The FLAVOR_0 version first appears in IPA v3.5, so avoid attempting
> to read it for versions prior to that.
> 
> This register contains a concise definition of the number and
> direction of endpoints supported by the hardware, and without it
> we can't verify endpoint configuration in ipa_endpoint_config().
> In this case, just indicate that any endpoint number is available
> for use.
> 
> Originally proposed by AngeloGioacchino Del Regno.
> 
> Link: https://lore.kernel.org/netdev/20210211175015.200772-3-angelogioacchino.delregno@somainline.org
> Signed-off-by: Alex Elder <elder@linaro.org>

Acked-by: AngeloGioacchino Del Regno 
<angelogioacchino.delregno@somainline.org>
