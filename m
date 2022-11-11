Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF346251C3
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKKDiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKKDiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:38:23 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3C33FB97;
        Thu, 10 Nov 2022 19:38:21 -0800 (PST)
Message-ID: <ef09ae0a-ad22-8791-a972-ea33e16011ba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668137900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvJL6/li/5SPHQQZhp50uZgBoON3KfQxw7kHmklcBEE=;
        b=Z3XCqh+rD+8Jg8jNV8aRt1/qt0UBC/A6ESrWzXl7ciIE2xYXk4PHraByFPNXoiOG+DRxlX
        tS8XlEtz8nlMsKmGDuNRnjLvcj6VUzeQfZ/zNronvsymlkJc3YRaXAmfmbY3yjAYJFS5ao
        idG9Z1Hxw9jzfnwblBHp+/NdYZz8vRA=
Date:   Fri, 11 Nov 2022 11:38:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv2 0/6] Fix the problem that rxe can not work in net
To:     Parav Pandit <parav@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "leon@kernel.org" <leon@kernel.org>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
 <204f1ef4-77b1-7d4b-4953-00a99ce83be4@linux.dev>
 <25767d73-c7fc-4831-4a45-337764430fe7@linux.dev>
 <PH0PR12MB54811610FD9F157330606BB7DC009@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
In-Reply-To: <PH0PR12MB54811610FD9F157330606BB7DC009@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/11 11:35, Parav Pandit 写道:
>> From: Yanjun Zhu <yanjun.zhu@linux.dev>
>> Sent: Thursday, November 10, 2022 9:37 PM
>
>> Can you help to review these patches?
> I will try to review it before 13th.

Thank you very much.

Zhu Yanjun

