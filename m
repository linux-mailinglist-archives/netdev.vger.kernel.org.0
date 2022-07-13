Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CAF574004
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiGMXYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGMXYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:24:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319B445F41
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 16:24:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6F461ACE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33C8C34114;
        Wed, 13 Jul 2022 23:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657754675;
        bh=TTnxx39Xe1bGt4XaybkBewNPb5EooEhM6Sj9DbEay18=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=X+yTIhTVWAICjuOezYH8ryPhIR9Fmj+eo/YUQwikG8Cc01enGgCiQ8tUy6hJUF+Yq
         RTf+EBjg8+mYH0OEnFeQfkQulkUeAyntM5kvdPewcjxqGgF8OYE3ZOh1U3Qzh7Dws9
         zM0Nnvh7KseMUEYDK1LTQlP37FP7YXaz0zWmyNurMrngjEM8l0ImYIBsGtfiPCkizn
         p7OUhK2Wm1sS67d7oux+v29oibgyes6YKMUy0+efe6U8as8fAewGMzulb6/T34/nQy
         /KPNTtJ7dE6OLm5c6s0WblXNGvh5akLHzMGYtYncmovMmPJHxf1XdAzbZyuNUJVyGM
         LLdasexV3MIpw==
Message-ID: <faaafd40-48c0-1e03-3e7d-549d73ca1df0@kernel.org>
Date:   Wed, 13 Jul 2022 16:24:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v1] vdpa: Add support for reading vdpa device statistics
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>
References: <20220615034616.16474-1-elic@nvidia.com>
 <DM8PR12MB54007939BDF9777A237A4981AB849@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB54007939BDF9777A237A4981AB849@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/22 10:40 PM, Eli Cohen wrote:
> Hello David.
> I haven't seen any comments from you nor has it been merged.
> 
> Is there anything else needed to have this merged?
> 

I see it in iproute2-next:

commit 6f97e9c9337b9c083ea0719b633622bcfef5d77b
Author: Eli Cohen <elic@nvidia.com>
Date:   Wed Jun 15 06:46:16 2022 +0300

    vdpa: Add support for reading vdpa device statistics

