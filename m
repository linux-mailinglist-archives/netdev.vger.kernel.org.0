Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF6522B75
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiEKFGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiEKFGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:06:00 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ADA1403D;
        Tue, 10 May 2022 22:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1KHuCmEjlgOiBzRGyizP/FHYHWqcewVx6BpX8+Zrej4=; b=Dq3tx9ac8TZO9AtTj5bjNGhKac
        d3KPoOIFgwa4uzLka8SdKY9IAbXYoKgatWn1jmjegjvJfcqo6ITqydRUNGKXSxo1b0d/E4kNl3lR7
        eye9EAj4rHQee63XqlAub4q1dRVisDZLk+ZU3o3vOb16v7JEgB6nBgSsbWr+MyAH7Uls=;
Received: from p200300daa70ef200e12105daa054647e.dip0.t-ipconnect.de ([2003:da:a70e:f200:e121:5da:a054:647e] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noeXf-0002z2-TZ; Wed, 11 May 2022 07:05:43 +0200
Message-ID: <596e38fd-a563-b119-c541-0370304d299b@nbd.name>
Date:   Wed, 11 May 2022 07:05:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] net: ethernet: mediatek: ppe: fix wrong size passed to
 memset()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
References: <20220511030829.3308094-1-yangyingliang@huawei.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20220511030829.3308094-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.05.22 05:08, Yang Yingliang wrote:
> 'foe_table' is a pointer, the real size of struct mtk_foe_entry
> should be pass to memset().
> 
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Felix Fietkau <nbd@nbd.name>

Thanks,

- Felix

