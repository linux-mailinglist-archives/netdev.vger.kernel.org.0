Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A4543F7E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiFHW6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFHW6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 18:58:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803757DE16;
        Wed,  8 Jun 2022 15:58:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDB0C61952;
        Wed,  8 Jun 2022 22:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006AAC34116;
        Wed,  8 Jun 2022 22:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654729091;
        bh=7b2L2H8ucBg4c9J7v/FFroooKt+KN2n9czhTLRJEah8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Jz1KTWNYdOcojfE5YoGaeusea4ZhdHgAC7LJS4WIrIYaC+RdF+1jwH4EUUBv1fqlA
         7oTc0thaYL+c47XbH9G2pG3KbitUz1a4yxB3lY+O1KKGr6jl3LTmrzhoTujAq9UREJ
         ijIhzU0tkhY05rgH0NwIvH27u16ODLs0T+Kz52ZIwChg3IvtisR2Q3uyMLFOaZoROd
         wjQdcRTZpgeukMpCB1GFIcSwX3fAsDxP+IPIH9BUsBWU9SPkSBQwtAkDrS8aXrnJtX
         D+hYUlDtXP90tRdx+HhNkYB5uo9iFhNK61iKaWZiUXwTB2fewSTjjdgXZOKEgWUr35
         HOXBpzwvDRGLA==
Message-ID: <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
Date:   Wed, 8 Jun 2022 16:58:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, kgraul@linux.ibm.com, ivecera@redhat.com,
        jmaloy@redhat.com, ying.xue@windriver.com, lucien.xin@gmail.com,
        arnd@arndb.de, yajun.deng@linux.dev, atenart@kernel.org,
        richardsonnick@google.com, hkallweit1@gmail.com,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
References: <20220608043955.919359-1-kuba@kernel.org>
 <YqBdY0NzK9XJG7HC@nanopsycho> <20220608075827.2af7a35f@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220608075827.2af7a35f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/22 8:58 AM, Jakub Kicinski wrote:
> IMO to encourage use of the track-capable API we could keep their names
> short and call the legacy functions __netdev_hold() as I mentioned or
> maybe netdev_hold_notrack().

I like that option. Similar to the old nla_parse functions that were
renamed with _deprecated - makes it easier to catch new uses.
