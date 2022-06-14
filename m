Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E7454B43D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbiFNPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbiFNPKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 11:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B422FE57
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 08:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2597360C92
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E6C3411B;
        Tue, 14 Jun 2022 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655219421;
        bh=DvnXH1zsDgzeeSGHM3b2KGyqHqvNPGUM9GMCMX3Ll7E=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=XFhBuS9JkNIdQuCKUzO50MCV3pfxPTXgXiy5qOfko5rtQX7u6OCrozlpo9PfEzpvM
         m4eUZ7tFBYgw9OTHPxpa0xbKSfxrNp9JXPGbaKpG0bZ8wJyJHIZC9nIkyoTh2VZW0D
         +K9Oe57AD1g5/Goh3xkbitHVZ3cQzeGW55EhkylMu77FkaOIUzreuFnEcLNSTCzuuU
         or/ZJ6TK4rtp0fDjlWzxm3QNfjzesvm6MzIFfGEsPZwlM2wpg4iKaXOV/C3ndN/ecI
         ZbSwrQUMMlQKFeQq3qqD+ylYk8u7BRi2RO0pKT5Sgatf1een6YD6NrFRIDiybuwY5M
         UhYWsmGAqP/dQ==
Message-ID: <06da02ca-35b9-7ef1-18fb-d35ed93075e5@kernel.org>
Date:   Tue, 14 Jun 2022 09:10:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] vdpa: Add support for reading vdpa device statistics
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>
References: <20220601121021.487664-1-elic@nvidia.com>
 <05585cd3-95e9-1379-967a-7fa6e8d065f3@kernel.org>
 <DM8PR12MB5400234FC1BCC7308163FE04ABAB9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB5400234FC1BCC7308163FE04ABAB9@DM8PR12MB5400.namprd12.prod.outlook.com>
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

On 6/12/22 11:59 PM, Eli Cohen wrote:
>>
>>
>> no reference to the kernel patch, so I have no idea if this uapi has
>> been committed to a kernel tree.
> 
> It has been merged upstream:
> 
> commit 13b00b135665c92065a27c0c39dd97e0f380bd4f
> Author: Eli Cohen <elic@nvidia.com>
> Date:   Wed May 18 16:38:00 2022 +0300
> 
>     vdpa: Add support for querying vendor statistics
> 
> I am not sure what's the convention for reporting such reference.
> In any case, I can repost the patch if you could let me know how I should write that reference.
> 

you can add it as a comment after the '---'; let's me check on the
upstream uapi status.
