Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9B6BE80B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCQL1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCQL1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D73199D5;
        Fri, 17 Mar 2023 04:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C43B82433;
        Fri, 17 Mar 2023 11:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46958C433EF;
        Fri, 17 Mar 2023 11:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679052461;
        bh=pKOJZxA4vx6FFBJUnFSIcDMCz1EFmCQ7yXB8l6il98w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZJy1K0QOwotLq91F3IMqInoyXcYmCggK3addsD5Z+E8KwQOGxoEEFTsqgyW0naK7Q
         ALNIHBErnFD+iRTzJxeOMAmtEyWuJkvX1+k3etx5c4vCLLUoMXaSPnS6I9ptyF/CbR
         QpDhdKpUC0g3FDg56yKsXbayL21485542OuXPh88bwRNvKzoh1wIHg3ArOVpKx1Vc0
         29b4wVZqP/RZ06IgcqVbp8nUMiqbEjTEDFlI8jEdva7ozLqKY2kIzGF01Pza4KIDBW
         DBOutoPI6glmWRCfEySM97f+Wqq6CjygRkMpeVrP0POMihtb9PiOVgGP+xBWrvWe+J
         CIZO4GdBDoKWg==
Message-ID: <b0dc760d-fb7e-a19b-babc-8cd571b8f74d@kernel.org>
Date:   Fri, 17 Mar 2023 13:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: reset pps genf adj
 settings on enable
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230316095232.2002680-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230316095232.2002680-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/03/2023 11:52, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> The CPTS PPS GENf adjustment settings are invalid after it has been
> disabled for a while, so reset them.
> 
> Fixes: eb9233ce6751 ("net: ethernet: ti: am65-cpts: adjust pps following ptp changes")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
