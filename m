Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60D600BA2
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 11:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJQJzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 05:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiJQJzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 05:55:13 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AB727FD8
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 02:55:09 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 67A596600357;
        Mon, 17 Oct 2022 10:55:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666000507;
        bh=mkjOjjOXCXqris3rbpAafu+DINsdWCcTHpAeTHhUQC4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jJ7w7y7Azm2L2STCUpXOif78aQi1DGv546+HPTeB9o0yLNcK3k1XqMo5ODYHJnTqJ
         sKeKwlnUPDa5gNCHIBlLHI7DAya3VOoHLFboM4KrkktMWQg8WHaxvaPf5TfOgwWjq1
         MK4gFrooagjqQsGG3Ne52Tat+khr4xvnUJjSkAW4MdBBVjvx31xMRD2SwWuQXO3JAH
         EdcC3zfnRACeyG2ematgXyBgB0XhS2uKzGkWBYaFIE500k8zKMns136+GnGyqrDu7Q
         L+1CWNf9xTD+0NeV/7t8Gn2FzFZ6iaPkOASEr396hJZoRD2Rxf8tYcG6wQOYrpujgY
         e3ArMpfWuvtog==
Message-ID: <ad7840dc-f4d9-18c7-cc1c-91e5c0dfa4a6@collabora.com>
Date:   Mon, 17 Oct 2022 11:55:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net 3/3] net: ethernet: mtk_eth_wed: add missing
 of_node_put()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Cc:     nbd@nbd.name, davem@davemloft.net
References: <20221017035156.2497448-1-yangyingliang@huawei.com>
 <20221017035156.2497448-4-yangyingliang@huawei.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221017035156.2497448-4-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 17/10/22 05:51, Yang Yingliang ha scritto:
> The device_node pointer returned by of_parse_phandle() with refcount
> incremented, when finish using it, the refcount need be decreased.
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


