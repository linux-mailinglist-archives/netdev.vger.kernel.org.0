Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092826A0226
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 05:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjBWE4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 23:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBWE4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 23:56:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB531E3F;
        Wed, 22 Feb 2023 20:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF76B80EF9;
        Thu, 23 Feb 2023 04:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D71AC433D2;
        Thu, 23 Feb 2023 04:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677128167;
        bh=G7vZbFg0UeardSYIFv1QFFkyDJJcjeC9mh3dO15wkgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nFUDAaMwiFN+uGndlpkOQldbihKDyViPmWkszrH84yT7O48o3rUgzge+d80Vu0yD1
         5ISbhWJAimaKNl7nzS1Eoy9aRKtKM+phwQZzCupN+wGPWfIDtNjAYww5dmVQoRu9Ch
         eh0VACSy208vTbeKpaK89xg+eI/btNTmgKZcS7eGB5G8wQdUErAvG+qmEnbBnytBj/
         nORI4DURNpUoOSmVguZ/Rrx5z8UnpncO2uWDXqivy/9PBhjhpUcec1nCFPjonf/oZm
         t/81QAe4KegfkDgbMiqfsBbzK9NhLPHXKoiREZOus64GbYz2fZbwE6oCZCcbawZjAi
         G2k1X6ezO1gxg==
Date:   Wed, 22 Feb 2023 20:56:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhu Yanjun <yanjun.zhu@linux.dev>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 0/8] Fix the problem that rxe can not work in net
 namespace
Message-ID: <20230222205605.6819c02c@kernel.org>
In-Reply-To: <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
        <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 08:31:49 +0800 Zhu Yanjun wrote:
> > V1->V2: Add the explicit initialization of sk6.  
> 
> Add netdev@vger.kernel.org.

On the commit letter? Thanks, but that's not how it works. 
Repost the patches if you want us to see them.
