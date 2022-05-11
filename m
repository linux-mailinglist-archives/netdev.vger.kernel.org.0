Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765F7522FF1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbiEKJxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbiEKJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:52:28 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDE5E767
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:52:09 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 63FE361E6478B;
        Wed, 11 May 2022 11:52:06 +0200 (CEST)
Message-ID: <7ee58bc9-bacf-9d16-8f96-5c9beacb5e8a@molgen.mpg.de>
Date:   Wed, 11 May 2022 11:52:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Intel-wired-lan] [PATCH] igb_ethtool: fix efficiency issues in
 igb_set_eeprom
Content-Language: en-US
To:     Lixue Liang <lixue.liang5086@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20220510012159.8924-1-lianglixue@greatwall.com.cn>
 <8d7e86ad-932c-d08c-3131-762edd553b22@molgen.mpg.de>
 <B0201E3D-98F5-490E-81CF-45B16A06760D@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <B0201E3D-98F5-490E-81CF-45B16A06760D@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Lixue,


Am 11.05.22 um 09:59 schrieb lixue liang:

> Thank you very much for your reply and suggestions.I have made the
> corresponding changes according to your suggestion.

Thank you.

> In addition, for the problem that the invalid mac address cannot load
> the igb driver, I personally think there is a better way to modify
> it, and I will resubmit the patch about igb_main.c.

Awesome.

> It's the same question, but I may not know how to continue submitting
> new patches on this email, sorry about that.

As you use `git send-email`, what does `git log` show as the patch 
author? It might be as easy as to do

     git config --global user.name "Lixue Liang"
     git config --global user.email lianglixue@greatwall.com.cn
     git commit --amend --author "Lixue Liang <lianglixue@greatwall.com.cn>"


Kind regards,

Paul


PS: When replying, it’d be great if you used interleaved style [1].


[1]: https://en.wikipedia.org/wiki/Posting_style#Interleaved_style
