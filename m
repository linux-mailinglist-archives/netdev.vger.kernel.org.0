Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B84D88B4
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbiCNQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242879AbiCNQCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9181C45AEA
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1302D6131C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEE1C340F4;
        Mon, 14 Mar 2022 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647273682;
        bh=03/PU8lbXzOXbG5il0kOgiMnPKsS2BErk0xSDIBVZi4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GewjmkBvvQGzObc76ev9vZOnebySuqxSGX3Sk/nf54tktqz8OIhYe8c4dHCeghghB
         3jmgGZRlXXGcbtll92FqD+banmH9vEAgn032sBY6G0mjKnjg8DzJT1jWN+HLq2muXZ
         2AMTHQ4zR6j/mEpWE1ylYx0Yq5pCIk819dTRCdhEouKOhEfr5ITF00A+Ki31GET0KO
         5XC26bwYzCuJ1oWHsCv9HwTrxdymQ2SweepYZsDjsBM3rSws+3qDaYJ6JYRSfUtpqs
         4JN1aARBDHMFSv9uB4s2k/plRGTI1lkjRA8GPC1rSTZbeAfkOzTBWzB/Y1C0yTNpJj
         SJvuK8AyuiGDg==
Message-ID: <cdb63108-d66b-1c41-062f-1e9253d82679@kernel.org>
Date:   Mon, 14 Mar 2022 10:01:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-4-elic@nvidia.com>
 <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
 <DM8PR12MB540011BD3BCED32FEE7522F8AB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB540011BD3BCED32FEE7522F8AB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
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

On 3/14/22 9:45 AM, Eli Cohen wrote:
>>
>> new options require an update to the man page. That should have been
>> included in this set. Please make sure that happens on future sets.
> 
> How would you prefer to update the man page? Within each patch or in a
> new patch, last one in the series?

the other patches have been committed so a single patch for this current
set.

For future changes, 1 patch at the end is fine; key is that
documentation change is with the set.
