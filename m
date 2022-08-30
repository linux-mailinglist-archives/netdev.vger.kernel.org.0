Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA45A6C2A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiH3S3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiH3S3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:29:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3BB606B0;
        Tue, 30 Aug 2022 11:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=UYQek+qMCToSnQsPHyu58B7DsB3xgc4kYQ4E/F+X1Yg=; b=iwhsstQSgNuQeT2obw6YbDQbow
        /Z8XJYKHFp7BZ/adrMoekoeTPIi/AXS2k0dQGCt0n61y29e+3ryMkr9KXhd0COFBLGfK4iqxYleBd
        7uL8HN+itar8OFux6DO0y8BwbMTYU1Gmr9nXP7pb27k4e0hWG/9sR55fYgZ7/I0ZEfu8EHlE7rS2t
        KzbTj6DTfy+pcUKscMY/y32BhrnSWEhKnZCaZ+ah5QxLiZ8/pHwzeW98S3JQGpeNDQICKGF3e1M0M
        +j+ACvY2O4mivtvCwA3Umu5l6oiPSuK3srW/LQ3UeUjeaPX8XiiOmt7RvXpnrWJ/VnbcNldrbUC04
        7bTFnpvQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oT5zQ-001CSx-Gi; Tue, 30 Aug 2022 18:29:32 +0000
Message-ID: <3d308d17-1c00-39ab-eb47-8fe1f62f9e7f@infradead.org>
Date:   Tue, 30 Aug 2022 11:29:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: linux-next: Tree for Aug 30 (net/ieee802154/nl802154.c:)
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220830170121.74e5ed54@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220830170121.74e5ed54@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/22 00:01, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20220829:
> 

on i386 or x86_64:

when # CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set

../net/ieee802154/nl802154.c:2503:26: error: ‘NL802154_CMD_DEL_SEC_LEVEL’ undeclared here (not in a function); did you mean ‘NL802154_CMD_SET_CCA_ED_LEVEL’?
 2503 |         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                          NL802154_CMD_SET_CCA_ED_LEVEL


-- 
~Randy
