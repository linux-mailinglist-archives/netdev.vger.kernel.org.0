Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DDF586CDF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiHAOcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiHAOcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805821EEF1
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 07:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CA446134C
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 14:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20285C433D6;
        Mon,  1 Aug 2022 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659364327;
        bh=QLjKiYxfWAf75o2UV32Fgh0yl/C1JjKJpq7Abv0tGDs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sWjVEhA9a5aNR9l6yxTEdwu63KCjxz1RREmxKAGFRjUZ2Mpm3TLMdTPzEHn0eN0dr
         sc9R50NhB1FQxCWWMB9OLkAuFtVMNzYNxP29HsFC9OhIIbFlZAJc7cGMI6wQTF8BsH
         LtsNv0fujqKER6TMWdj+uIUBF60H/UFArnLVOEU7LfrxRNDftXipHj7FVISJyMenfE
         dwP0UoKraUj1Vf99Kwva2XumggyLRFDBcMLxbD72mgZkxguDTXH6j++OyOiIu9BaCk
         7lMCX8yi90Ou+udYDdXPHXwIwmvXxQPDTwwL2zcIdgwumBQUdxnB90YtBbUmkLFcTW
         pPnpKfjFLyUwA==
Message-ID: <ca415b6b-20de-d102-e02d-c44d7896961e@kernel.org>
Date:   Mon, 1 Aug 2022 08:32:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v1 3/3] macsec: add user manual description for extended
 packet number feature
Content-Language: en-US
To:     Emeel Hakim <ehakim@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
References: <20220711133853.19418-1-ehakim@nvidia.com>
 <20220711133853.19418-3-ehakim@nvidia.com>
 <IA1PR12MB6353120F51ED3E761DEBC86BAB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <IA1PR12MB6353B88D92C8EEFD8BFE7DE2AB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <IA1PR12MB6353B88D92C8EEFD8BFE7DE2AB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/22 5:15 AM, Emeel Hakim wrote:
> 
> Hi,
> a kind reminder ,
> also is there anything missing from my side?
> 

repost.

