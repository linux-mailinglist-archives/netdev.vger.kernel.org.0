Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476E74D4FB0
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiCJQtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244228AbiCJQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:49:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC21D10A7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:47:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 666B9B826F5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 16:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A0C340E8;
        Thu, 10 Mar 2022 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646930861;
        bh=liQliv6fc1THdKeU5Uys1EOerwAfyAVEAHClaXHlqeI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZQC0KIAdNii4mgjgXiUP/LWyS9zruJ2iCmgjjdHTvITG+9rFbKN3M/zf1s/TflOwx
         3ElwDE05BuKT0XEsEIuJRaR8b0e2ZF1m/P3qRyLMndh6ec/L7mooAd1c+dJ+L0CEXc
         8kjfOrFl8hNg/IPqEJ8FrCd7OGfqTyKTU0t7Pn3WspT/BPwSoMzs9CjViCUsAepl6R
         LKR5n6wyTwZ1+J632zX4SW5rVCx+wUp7iv1a4BfsfrehJhX+2xRDln4UlAZmbRe6Jz
         WER5L54BbfqWn3GKVFLy9gyFAuidCM1pDNdaur9apN2UYc4mkEBLibPbnKcnzv3w11
         KzJvOcuxD7QBQ==
Message-ID: <59ae13a1-3b18-e7d8-f012-aee9790780db@kernel.org>
Date:   Thu, 10 Mar 2022 09:47:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a
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
References: <20220309164609.7233-1-elic@nvidia.com>
 <20220309164609.7233-4-elic@nvidia.com>
 <2d4bc28e-41a8-c6ce-7d52-cb1d9f523e70@kernel.org>
 <DM8PR12MB54001673F48C4FE659A74FFEAB0B9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB54001673F48C4FE659A74FFEAB0B9@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 10:59 PM, Eli Cohen wrote:
> Break the string into two lines?

yes. See other commands on how they break usage across lines
