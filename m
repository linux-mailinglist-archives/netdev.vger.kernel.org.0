Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D774A6D1D5D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjCaJzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCaJyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:43 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BE61D84E;
        Fri, 31 Mar 2023 02:54:07 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 5A6196603193;
        Fri, 31 Mar 2023 10:54:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256446;
        bh=IarGogse4Y+RWB+zvh2pQ1pzR4Yc9/24eKDYTito9nk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XX04hJgzL5flXafpU8G4hjKVA/Mw7TlMn8eGrHCwgGnumJg9DJTOkhUptHEG/ajDs
         JFuYvyIu3X3lfAVU+LSvkxY0tc71mln9Xa8S6+s3WkZXkxzIvwTAPAXto4hG4p8Dhj
         p7+CsT8m2XKK6qnShDRbPQP/uq06a94rMR0sRtU9i1J4iTQ1LDpZHjw2ByqDgb03ni
         MRQGzHNSm+TM57kFOrO0zfboaFrc6+lmSHElxAZcOTaG1L5sz0jGzmx8Qaa8zMHoV1
         JYsrJnhfEo20hB/huMU32Rt8hEr5o6/6OfOpVnZnenpxoc7jAAnDmsv3qxVsiniI2A
         zFSc+uB1lyjuA==
Message-ID: <536915bb-1fa1-638d-2cac-65a4672b9728@collabora.com>
Date:   Fri, 31 Mar 2023 11:54:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 04/19] clk: mediatek: Add MT8188 peripheral clock
 support
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230331082131.12517-1-Garmin.Chang@mediatek.com>
 <20230331082131.12517-5-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-5-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 31/03/23 10:21, Garmin.Chang ha scritto:
> Add MT8188 peripheral clock controller which provides clock
> gate control for ethernet/flashif/pcie/ssusb.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


