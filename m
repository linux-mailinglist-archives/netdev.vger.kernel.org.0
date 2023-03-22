Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47166C4064
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCVCaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCVCav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:30:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F524EC6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85D44B81AEC
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3250C433EF;
        Wed, 22 Mar 2023 02:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679452248;
        bh=pXIOKtIb+5zoFKus6CquzAJz00+2+HnJi/DCu8EvrrU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tyf4/zkLSdU4bQZurt3TPpLvbWN7s0CBnVfGaBNbUGVoOBoSzbdB5dVdGjB1Bz9Yj
         CywA0DzPWQfB8YQIbGxt9VT71rIOADGKpN00I0oE5I9DWONzKnWseJBeTQFqvgUKdq
         ldbqKtahrd0q9uSJkJPASca2LU+4VDTWdQ33pLiSkJRhYgZq8KN8oNwC4VzE9xCPPu
         +uEz+Rwd8jeeFgAvC4vN4bjIJylJjq8t0MrTdsX2eyVCN8WsD0gEVxaCnBKn/yWzzM
         tfNS3cIgyCUB9h6zYS4lRolCb+iv0fF9rLXgQ2nWm7Mla3Nf/xfPOjwhucTb/3QLid
         rYsmtESb2HMTg==
Message-ID: <ff66a3b6-a634-a408-1d7c-cc53b676528e@kernel.org>
Date:   Tue, 21 Mar 2023 20:30:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 3/3] selftests: rtnetlink: Add an address proto
 test
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
References: <cover.1679399108.git.petrm@nvidia.com>
 <1d62c94b5fe3c03ee08242667304732d68bad000.1679399108.git.petrm@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <1d62c94b5fe3c03ee08242667304732d68bad000.1679399108.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 5:52 AM, Petr Machata wrote:
> Add coverage of "ip address {add,replace} ... proto" support.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/rtnetlink.sh | 91 ++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


