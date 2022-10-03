Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BCD5F31F5
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJCO2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJCO2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:28:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C4652820;
        Mon,  3 Oct 2022 07:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF68B8111E;
        Mon,  3 Oct 2022 14:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7321AC433D7;
        Mon,  3 Oct 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664807312;
        bh=KiWuybmiF7uvPLLFgNL60QPrAM2Z2mtgDKNIzJdnU/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=er90k8ag8Q5ROjVrSvYnSnPVhtC2sq/FRmTxxQL0Db/KsTmbDgVvro4wuljid6469
         eibKDZAGNZuxZjjAlTQGjpYPkyO4sXbN8AHomC7W1/n0G3KUsdQ2Ixk38ufPFb7BAW
         9n7bwR6G0WZg43iulWMSZaNjJgVmlkFYRwMpsqNBiCePBjL57NLRUBQTSVuevimt6s
         w6zwwg+V0xAHmWZEzmUajYyjpfylMAgF8ESPhT/tnRwcwBGUF4+tMKftKmiGOT5dzW
         CwrGYU/VzSlGzGKgvYt1LsRrBoLT4QTduXCK9TB8anTPcaBXx8xkqjs7giqMUESdSo
         +UF+Hik5Br1ZQ==
Date:   Mon, 3 Oct 2022 07:28:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@fb.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Aya Levin <ayal@nvidia.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Message-ID: <20221003072831.3b6fb150@kernel.org>
In-Reply-To: <Yzmhm4jSn/5EtG2l@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
        <YzWESUXPwcCo67LP@nanopsycho>
        <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
        <Yzap9cfSXvSLA+5y@nanopsycho>
        <20220930073312.23685d5d@kernel.org>
        <YzfUbKtWlxuq+FzI@nanopsycho>
        <20221001071827.202fe4c1@kernel.org>
        <Yzmhm4jSn/5EtG2l@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Oct 2022 16:35:07 +0200 Jiri Pirko wrote:
>>> What I'm trying to say
>>> is, perhaps sysfs is a better API for this purpose. The API looks very
>>> neat and there is no probabilito of huge grow.  
>>
>> "this API is nice and small" said everyone about every new API ever,
>> APIs grow.  
> 
> Sure, what what are the odds.

The pins were made into full objects now, and we also model muxes.

Vadim, could you share the link to the GH repo? 

What's your feeling on posting the latest patches upstream as RFC,
whatever state things are in right now?

My preference would be to move the development to the list at this
stage, FWIW.
