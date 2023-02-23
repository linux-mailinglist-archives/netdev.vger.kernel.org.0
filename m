Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63AE6A0794
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 12:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbjBWLmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 06:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjBWLmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 06:42:14 -0500
X-Greylist: delayed 40214 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 03:42:12 PST
Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7523151FBE
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 03:42:12 -0800 (PST)
Message-ID: <c623e3d0-c31c-6535-457d-d9c888f17a77@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677152530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IlRun0sxQkrtkZQkswZ/qHzOAQd1JteeBh4pUkMb+r8=;
        b=REyLgldk3UO7PiN892X53wfkzbDI3PgN1aZlQqjqHWGn/a9GqAfVwtggLcOrptFYZDWyug
        Zl72hDgbwT8A9M4hD5AtL46BCs/K9Cz3yFcfUXX5FNcaNMljcv8ZHQj4gmvYH8i5YLVolF
        HcuuYzNkvMEYZ217Mh6c9xjL/xb6vYs=
Date:   Thu, 23 Feb 2023 19:42:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 0/8] Fix the problem that rxe can not work in net
 namespace
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
 <20230222205605.6819c02c@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230222205605.6819c02c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/23 12:56, Jakub Kicinski 写道:
> On Thu, 23 Feb 2023 08:31:49 +0800 Zhu Yanjun wrote:
>>> V1->V2: Add the explicit initialization of sk6.
>> Add netdev@vger.kernel.org.
> On the commit letter? Thanks, but that's not how it works.
> Repost the patches if you want us to see them.

Got it. I will resend all the commits.

Zhu Yanjun

