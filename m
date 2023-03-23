Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA386C5F05
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjCWFhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCWFgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:36:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4C22DF2;
        Wed, 22 Mar 2023 22:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=4rYA27bP5SJ96nwlsw/Ut9+9UJxvq6/W6cEfEakTthw=; b=sFBJRaKocNeVAn4DYTWwAZHy9e
        k6BkoKt9dkyqQSMcwRG6UuUOA2cIZ/gCw8tcHR+kgmspjCMMl74M9jK227yPt4L2nkCBZYi320A+2
        eSgAkLSwlU0nCybjsTgj210oum2+Ll4E3d0mqMvk4kjTkcPK0wJzuTOKBytcaSqtHTaZVUN0MyCmp
        qgzhYfCTQLeHxavmgazRuhxXoWn66gHWvM8kUaGtJg5DxDAr/6AAd/rRQHq/FYmUBnaT/fyN7+qBA
        aNXT/F7yAq2FGOpJhjWWReJVrjtut3C6WObbfzoZrhF20jTNkp3lTCjPm2aMhQfaSvBrgtckLmw/m
        B/QTpyWQ==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pfDcQ-000rkX-2k;
        Thu, 23 Mar 2023 05:36:10 +0000
Message-ID: <5952c3e9-814c-288f-3682-e026f4250406@infradead.org>
Date:   Wed, 22 Mar 2023 22:36:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] fix typos in net/sched/* files
Content-Language: en-US
To:     Taichi Nishimura <awkrail01@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah@kernel.org
References: <20230323052713.858987-1-awkrail01@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230323052713.858987-1-awkrail01@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/23 22:27, Taichi Nishimura wrote:
> This patch fixes typos in net/sched/* files.
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>


Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  net/sched/cls_flower.c | 2 +-
>  net/sched/em_meta.c    | 2 +-
>  net/sched/sch_pie.c    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)


-- 
~Randy
