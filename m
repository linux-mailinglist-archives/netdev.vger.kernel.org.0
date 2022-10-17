Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C8600BA3
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 11:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiJQJzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiJQJzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 05:55:14 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5B1705A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 02:55:13 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id F3C73660232A;
        Mon, 17 Oct 2022 10:55:11 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666000512;
        bh=5276KptNcMaTO+XivxGWRNCBQZByr5Wpl2SJT6iIkIA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Gs1FgmAodKfMPby8Y47pjXjruXfOWtnxBebuhH5bFn/I+EfugwfsgEXZms38wicrc
         FVUQ/moHaCH+XYw2Rg15hBfKL40iPa2gJuqmP0/WA67XKbdkw++Q6spxMHkeLCNEE2
         zEVFQAYV6Rn/fmSU7IoS++Ub6UCg/lrzmthHKHgvhxxY5aVsZQzGYWXlQNb/QC/wfY
         bminZ03ogSfCcMN0CYA9nZk0KIZ3hP8gu/xLN3eCEr3ENAaaOLt6bNZrpKaYX69Iju
         UsKZcoO+GLaW76MoIL3Ct8ZdEjl4818ImmCZjrFfPooUKftMC7EF4tyyGOdCRGEGPD
         LLKhdjUSnUvHg==
Message-ID: <0160f9cf-c408-9bf1-65e7-c7a833993bed@collabora.com>
Date:   Mon, 17 Oct 2022 11:55:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net 2/3] net: ethernet: mtk_eth_wed: add missing
 put_device() in mtk_wed_add_hw()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Cc:     nbd@nbd.name, davem@davemloft.net
References: <20221017035156.2497448-1-yangyingliang@huawei.com>
 <20221017035156.2497448-3-yangyingliang@huawei.com>
Content-Language: en-US
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221017035156.2497448-3-yangyingliang@huawei.com>
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
> After calling get_device() in mtk_wed_add_hw(), in error path, put_device()
> needs be called.
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


