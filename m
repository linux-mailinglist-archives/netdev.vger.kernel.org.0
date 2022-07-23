Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1217B57F085
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 19:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiGWRDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiGWRDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 13:03:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D7718391;
        Sat, 23 Jul 2022 10:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B5B8B80932;
        Sat, 23 Jul 2022 17:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1197C341C7;
        Sat, 23 Jul 2022 17:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658595818;
        bh=jkF1ciNW7Z8XW8uh/SwhU5vndEkIN8sjBSUYzVN4iJI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=REmIPo5/LADR3wCzjYcpFgILT6tgBP81AL21H/GKH7pHw/YUmlxv6M/s250sNvxG0
         RC5AB/bZVdqyynar///GRmf4DXsyGC9/Bg249CX5iOGrwjXfCn7ADBAX3poKep8Nwe
         N1vopikMXDSqc7X20KMphX6HdhDFsOO1gl+N/H9iJKNy5chhLbFL55wTXH3idgFn2J
         o01LFduqN9Ob00Pbc1Ium2LJ890NJ4U7K+ehbz+sMVtGiP+7X+HnmFQq5L1+wKVvNM
         H7svA1804j6bHvOb7QlmmN3qG/N66DYQb9+w8ZK8jEpr3s9/v3X7s+fwPoaK0sY9RB
         ViCjRlhe/4CQA==
Message-ID: <b4c65355-6ef8-7704-adc4-34aeed5d152c@kernel.org>
Date:   Sat, 23 Jul 2022 11:03:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v6 1/2] devlink: introduce framework for
 selftests
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, leon@kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com
References: <20220723042206.8104-1-vikas.gupta@broadcom.com>
 <20220723042206.8104-2-vikas.gupta@broadcom.com>
 <20220723091600.1277e903@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220723091600.1277e903@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/22 10:16 AM, Jakub Kicinski wrote:
> Any thoughts on running:
> 
> 	sed -i '/_SELFTEST/ {s/_TEST_/_/g}' $patch
> 
> on this patch? For example DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS
> is 40 characters long, ain't nobody typing that, and _TEST is repeated..
> 

+1
