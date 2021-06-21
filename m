Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C4A3AF54F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFUSpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhFUSpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:45:13 -0400
Received: from m-r1.th.seeweb.it (m-r1.th.seeweb.it [IPv6:2001:4b7a:2000:18::170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08259C061574;
        Mon, 21 Jun 2021 11:42:58 -0700 (PDT)
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 74C881F8A3;
        Mon, 21 Jun 2021 20:42:57 +0200 (CEST)
Subject: Re: [PATCH net-next 5/6] net: ipa: introduce gsi_ring_setup()
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, jamipkettunen@gmail.com,
        bjorn.andersson@linaro.org, agross@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210621175627.238474-1-elder@linaro.org>
 <20210621175627.238474-6-elder@linaro.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Message-ID: <85327e60-ecb0-7525-23d2-0917f9c2472a@somainline.org>
Date:   Mon, 21 Jun 2021 20:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210621175627.238474-6-elder@linaro.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 21/06/21 19:56, Alex Elder ha scritto:
> Prior to IPA v3.5.1, there is no HW_PARAM_2 GSI register, which we
> use to determine the number of channels and endpoints per execution
> environment.  In that case, we will just assume the number supported
> is the maximum supported by the driver.
> 
> Introduce gsi_ring_setup() to encapsulate the code that determines
> the number of channels and endpoints.
> 
> Update GSI_EVT_RING_COUNT_MAX so it is big enough to handle any
> available channel for all supported hardware (IPA v4.9 can have 23
> channels and 24 event rings).
> 
> Signed-off-by: Alex Elder <elder@linaro.org>


Acked-by: AngeloGioacchino Del Regno 
<angelogioacchino.delregno@somainline.org>
