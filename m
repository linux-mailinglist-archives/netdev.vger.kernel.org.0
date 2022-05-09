Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2798C51FCD4
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiEIMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiEIMcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:32:43 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB9F2725D1;
        Mon,  9 May 2022 05:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/1n3rjutGSa5dsULNVK8p84C/0maofyVZBHiKNgsQrg=; b=OT1f3HSzOICd2q8fIINH5tBNA1
        mVnAC33As8v8d1pVtdKajKMeLzzMx4vDF3OxjpMCgKcHG9kAwXCOthmr22a9Ncnh//JNVPyAADZU+
        8L/d5l+BYFpJlP0z0mxB8qszrolXOnpe/vG5p8llY1dKxAIdkAI2MwJ9cPynCT7KGmBo=;
Received: from p200300daa70ef2003c9b1ea8f6ef4a42.dip0.t-ipconnect.de ([2003:da:a70e:f200:3c9b:1ea8:f6ef:4a42] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1no2VJ-0003QX-1G; Mon, 09 May 2022 14:28:45 +0200
Message-ID: <59acb1d4-d9e3-10cc-6bb7-1270ccf45bdb@nbd.name>
Date:   Mon, 9 May 2022 14:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 2/4] netfilter: nft_flow_offload: skip dst neigh lookup
 for ppp devices
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20220506131841.3177-1-nbd@nbd.name>
 <20220506131841.3177-2-nbd@nbd.name> <Yni0AIc06fBELtXz@salvia>
Content-Language: en-US
In-Reply-To: <Yni0AIc06fBELtXz@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09.05.22 08:26, Pablo Neira Ayuso wrote:
> Series LGTM.
> 
> Would you repost adding Fixes: tag and target nf tree?
> 
> Thanks.

Sent. Please note that this will require a fixup when it gets merged 
into -next, since the mtk_ppe_offload code is affected by the 
ndo_fill_forward_path related api change.

- Felix

