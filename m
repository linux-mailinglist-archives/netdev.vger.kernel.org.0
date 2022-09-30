Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF71A5F0F40
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiI3PvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiI3PvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:51:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9D0FA274;
        Fri, 30 Sep 2022 08:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73E16239A;
        Fri, 30 Sep 2022 15:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A62FC433C1;
        Fri, 30 Sep 2022 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664553066;
        bh=ueLIxdlRUBf4/FSK9IMMTqRYPrA5x99k4kWr17Ek3So=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AgpTT34IUQK+kbgEu6PlEZrYDGtOwfnUWSrNi1Om/A/T2qmp+Aq38GHSna3vuzIeo
         fMDPePBpNyDPKLWFfOsxJvrT3tIY/h3il82m9r7BSq4ElaAuJN5GV+O9RQ0G2iiorF
         7q0gsdWvedrwtvobvotKhlALOHaZOiUPmuqMNBk95SZNN8qk5L57+T3mBpmbQyVml0
         6wB48Ys3gmuHERwsPbiqAiOpB/Q7c9BdeAJkyffHeFDTtkASo8Jp7QHfhgf4+57C2a
         RSbq6zIOHq2ffaKUSvzQKXf+YL2+3rPJdAu14hKHYUFFCWS2TFV7rXH2ig6YxZP/We
         1vh4iK+aePb4g==
Date:   Fri, 30 Sep 2022 08:51:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH -next] net: mvneta: Remove unused variables 'i'
Message-ID: <20220930085104.1400066b@kernel.org>
In-Reply-To: <20221010032506.2886099-1-chenzhongjin@huawei.com>
References: <20221010032506.2886099-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Oct 2022 11:25:06 +0800 Chen Zhongjin wrote:
> Reported by Clang [-Wunused-but-set-variable]
> 
> 'commit cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")'
> This commit had changed the logic to elect CPU in mvneta_percpu_elect().
> Now the variable 'i' is not used in this function, so remove it.

Please fix the date on your system. Your patches are sent with the date
over a week in the future.

Please note that we have a 24h wait period so you need to wait at least
a day before you resend anything.
