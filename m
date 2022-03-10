Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5969A4D3FEA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbiCJDxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiCJDwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:52:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06E912B778;
        Wed,  9 Mar 2022 19:51:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 745CB617D1;
        Thu, 10 Mar 2022 03:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F137C340EB;
        Thu, 10 Mar 2022 03:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884312;
        bh=5c4yrkr37JIFiZZkOYIYTU4xF8R/9nKa7tdZZj58W0I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m0VL+OWC0CWzPtPEMCbpIgiywa8DEDheeiYxA8xDmoyniq1B9MP+5ekGInFJVUK1p
         FNC/NVW+3mqAtedwdXgxaBTV4fktRM8uMzySB1DXqwNiDufSRF/SHJZezuIl37SRqd
         AbC9TfiiJv1xdeC8/HNhrd4kRLIwxvktUNlw+5G49c/0xHRo7PrNR6ZpqNapIslaDA
         ZF6elgqgbgfl/GPSY1R6sYS2KnhS+Xewo07hgqbnh9GwiTMiHY3pE4FTtsyzj2xjUM
         T1rVG9YfDlkTt8gM5TD6Ps51qdfMzuClygW/UfcjlrPnkW1u0EAmqy9kR4Gq0jyLWd
         X2/lXhD3B9cig==
Message-ID: <cf2fe0ff-cc37-bda3-37ca-48f3e27b3812@kernel.org>
Date:   Wed, 9 Mar 2022 20:51:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: IPv4 saddr do not match with selected output device in double
 default gateways scene
Content-Language: en-US
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, ja@ssi.bg
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
 <0f97539a-439f-d584-9ba3-f4bd5a302bc0@kernel.org>
 <86c61138-c82c-a403-664c-a61d651008b0@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <86c61138-c82c-a403-664c-a61d651008b0@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 8:20 PM, Ziyang Xuan (William) wrote:
> Does the community have a plan to address it?

i do not. someone with the knowledge and time is welcome to create a patch.
