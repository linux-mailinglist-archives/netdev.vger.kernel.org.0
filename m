Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D97434237
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhJSXlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhJSXlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:41:53 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE837C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 16:39:39 -0700 (PDT)
Subject: Re: [PATCH 1/1] ice: remove the unused function
 ice_aq_nvm_update_empr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634686775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RXC6bw5hISE6877h+QtcaVaXUhDEBqLzCKBjfpdPPqo=;
        b=TMp4M0MT3IRngO5lDUlsfGvKoNIEJx2tHn7a7O+CQhbCkI1Lw3YAaTDserlLBmdROud0E/
        1uv6uO+gtlcG2vsaqVQuVlOF/Vg98Q3mkOwvnBLDWJYBYDCE+LmUkft7TnpEfZZe5fbQ9o
        OPyGD2YewsdTzRKgTxEKqYO2Gakjnwo=
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        yanjun.zhu@linux.dev, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20211019091743.12046-1-yanjun.zhu@linux.dev>
 <5f4cdd35-680f-b5f1-25b4-dcd27419edf0@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
Message-ID: <bb786469-25e7-92a4-3697-ec1a62ee44b7@linux.dev>
Date:   Wed, 20 Oct 2021 07:39:27 +0800
MIME-Version: 1.0
In-Reply-To: <5f4cdd35-680f-b5f1-25b4-dcd27419edf0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanjun.zhu@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/10/19 23:30, Jesse Brandeburg 写道:
> On 10/19/2021 2:17 AM, yanjun.zhu@linux.dev wrote:
>> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>>
>> The function ice_aq_nvm_update_empr is not used, so remove it.
>>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Thanks for the patch!
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thanks, Jesse

Zhu Yanjun
