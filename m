Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866AA6E4F94
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjDQRrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjDQRrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB83CC0;
        Mon, 17 Apr 2023 10:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81444628FE;
        Mon, 17 Apr 2023 17:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571B9C433EF;
        Mon, 17 Apr 2023 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681753656;
        bh=0iguMpbvCM/A+j/R/eOFgiNmp1g5wSMPcY/VMYtj7Mk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hbpKP+y1C+L8xMr71Jps0IDYcppwOrG09tHpfS5hEAhSuld98TNf54iELYDvPRliX
         dXMLc9N/Zy+ibe27c+mIf3j7NugHBRI93/ZWhhHAJhCIwh++PhZsz1DqlwAWzF6uDf
         ymHl8u/VcVqPgcWXbuV7ZN13SNGwHr8VnUZ06h8nyQYxAQ12+cdDXXCDgPK2jQ26PG
         goYAd9QjuaFyEznl4nTXkIQJuyKmbQsZL2d0uf3302GxJ8OE6RJmrPno6jSIzxEnDs
         L2sPwxDRls47jtSxqw8QCXMIVn+dgcFwgGfhpmU+AzotJFjQkK0gJUHm40LFDTrGmT
         8VaV/QCDzmz2w==
Message-ID: <6e558956-3bed-c1eb-5474-c272fdc14763@kernel.org>
Date:   Mon, 17 Apr 2023 19:47:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/3] dt-bindings: net: marvell,pp2: add extts docs
Content-Language: en-US
To:     Shmuel Hazan <shmuel.h@siklu.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
 <20230417170741.1714310-4-shmuel.h@siklu.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230417170741.1714310-4-shmuel.h@siklu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/04/2023 19:07, Shmuel Hazan wrote:
> Add some documentation and example for enabling extts on the marvell
> mvpp2 TAI.
> 
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

You missed not only people but also list - at least DT one - so this
won't be tested.

Change looks good though, but still needs testing, so please resend.

Best regards,
Krzysztof

