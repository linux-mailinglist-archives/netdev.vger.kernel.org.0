Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8354ABD8
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiFNIcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiFNIct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:32:49 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C3726116
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:32:47 -0700 (PDT)
Received: from [IPV6:2003:e9:d74a:35d5:ae71:e9e7:2883:5e37] (p200300e9d74a35d5ae71e9e728835e37.dip0.t-ipconnect.de [IPv6:2003:e9:d74a:35d5:ae71:e9e7:2883:5e37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C5AE4C0574;
        Tue, 14 Jun 2022 10:32:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1655195559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zIYRU3p2/mDAj/Wd5UdBeo7p+krjwufUsiWLFeTARKQ=;
        b=FEPczPLd7xQm9ipk0gUDDbnBTQqMwJxtrOGATEupRn27qGPpxcpTQxyzXRtCUHvdV3cftQ
        uHMOrQ4gGmFT6BrDc4iiCyZhQz90yz5VZJ0zktuvq2w9QSzr1wjl3FKVbLJkAxXJ5dDgfF
        MTnRNAVuEAVm6/m4v6oUrfmi0SBGweO432XMG5/Dyx+E592WsjTJMa7f6BmxOh2Dq2yDJP
        HIS4ot/Zxna+IjEbQqfJqc959PzlmJWFkNVI/plMeegb5iGNU4k5uQSIkuKzu9WxMWMuQ7
        ttMRi7mCLmDHp3Fv9HN8oF5PO3YfrTbMUmRhJcHKzuKgbMU3qXVQURfp9P22zw==
Message-ID: <68da0162-55cd-bed1-801b-a1961d3772e7@datenfreihafen.org>
Date:   Tue, 14 Jun 2022 10:32:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCHv2 wpan-next 0/2] mac802154: atomic_dec_and_test() fixes
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        miquel.raynal@bootlin.com
References: <20220613043735.1039895-1-aahringo@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220613043735.1039895-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 13.06.22 06:37, Alexander Aring wrote:
> Hi,
> 
> I was wondering why nothing worked anymore. I found it...
> 
> changes since v2:
> 
>   - fix fixes tags in mac802154: util: fix release queue handling
>   - add patch mac802154: fix atomic_dec_and_test checks got somehow
>     confused 2 patch same issue
> 
> Alexander Aring (2):
>    mac802154: util: fix release queue handling
>    mac802154: fix atomic_dec_and_test checks
> 
>   net/mac802154/tx.c   | 4 ++--
>   net/mac802154/util.c | 6 +++---
>   2 files changed, 5 insertions(+), 5 deletions(-)


These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
