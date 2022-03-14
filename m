Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDE14D876A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiCNOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiCNOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D725A41987
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 641016120C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFB6C340E9;
        Mon, 14 Mar 2022 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647269515;
        bh=nGhebV+ENOKrBZuNDrS4tIsEW4oInNPbYMxtlNcpb7U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RM6FC1nrK6dCMCohNgup4Ys8nEfXwrEBpawiVFOCGvGULwPfi3Wjuj+ymEFB+sj65
         tRgCA6OunBipTJY1Mr1yZNSdzk34En5IIr8xEnvy7H04qMHE1+fM+xGt2o09bZdh8l
         ioVcypGeQ4o0XKThNUIw6UPEzRy5jmAQCtSHo7sHofzQ8nf4mS8EnDmc0anym53tli
         IlerHDGRDFPEx7n0/m+HM1U51sxXYXLtwyhYhJayvb2BxDO62Z6FeGMVj8+uf5ciGP
         52N87PXJjXz1K0/PiG0Ro2pzrOgkEwAuMuGhveeDuXmjth8G9DpvRIJdraZPRBliL5
         ay+7fM/di8uGw==
Message-ID: <a9e95f95-6ae7-518a-329b-3195e25a15e8@kernel.org>
Date:   Mon, 14 Mar 2022 08:51:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-3-elic@nvidia.com>
 <20220313103356.2df9ac45@hermes.local>
 <DM8PR12MB540017F40D7FB0DA12F7AB8DAB0E9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB540017F40D7FB0DA12F7AB8DAB0E9@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/22 12:04 PM, Eli Cohen wrote:
>>
>> On Sun, 13 Mar 2022 19:12:17 +0200
>> Eli Cohen <elic@nvidia.com> wrote:
>>
>>> +			if (feature_strs)
>>> +				s = feature_strs[i];
>>> +			else
>>> +				s = NULL;
>>
>> You really don't like trigraphs?
>> 			s = feature_strs ? feature_strs[i] : NULL;
>> is more compact
> 
> If you insist I will send another version.
> Let me know.

I'll change it before applying
