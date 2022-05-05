Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDA51B6ED
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 06:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242639AbiEEERX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 00:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEEERW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 00:17:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CA61FA6B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 21:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2027EB82A86
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 04:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA17C385AC;
        Thu,  5 May 2022 04:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651724021;
        bh=603LS4oKcI3zDcIx/j8AKER4j1Ql9LRZ89C1e8uXugQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dECi7ax2vrQ+kgkJb71Ftk8O/7FTeANx3/DWXA4fc0b6stP4BsSco6y93FRvL2U2s
         lLJabl2mvXZPibBj2RNutmoeNo4swy7yYGBnCIOyIcTwEiwDOjQcPzSVPTbdwxBndi
         YuNvY3BvLMicImtDen2qj0bzoheUqODiB9FK2UuMUBnEQ94nxL0dkxi1226bsuDYzM
         hjfC0GrOntQGOeMM0WirQAgGMmQO7cY+zVQXnDEPVuZjmeNBGorSF7p3PtrAg2XPtY
         5Ef/o/fMwVWDYj8o5PHGsNr4hZ/lbN3qPgWietal5KzVMO4t9g59AmZhwyJvEqvwHl
         AVIIpkZuRTOzw==
Message-ID: <094b9834-2ea6-f990-1661-f68ba65d4cfd@kernel.org>
Date:   Wed, 4 May 2022 21:13:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: gateway field missing in netlink message
Content-Language: en-US
To:     Magesh M P <magesh@digitizethings.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504223100.GA2968@u2004-local>
 <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 8:43 PM, Magesh M P wrote:
> Hi Dave,
> 
> Thanks for responding.
> 
> The librtnl/netns.c contains the parser code as below which parses the MULTIPATH attribute. Could you please take a look at the code and see if anything is wrong ?

Stephen gave you a few comments. In addition to that rather than me
reviewing your code for errors, here is a reference to iproute2 code
that is known to work:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/ip/iproute.c#n742

you can review it, add debug prints, etc to get your code working the same.
