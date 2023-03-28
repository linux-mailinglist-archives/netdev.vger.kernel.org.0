Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D856CC821
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjC1QgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjC1QgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:36:18 -0400
Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [IPv6:2001:41d0:203:375::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A196CDE5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:36:17 -0700 (PDT)
Message-ID: <64e444ee-70e4-e51a-250d-471cfffeab5a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680021375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1mvRN/2jYKvoRjIsnLQKdOjpz9Xb6FNa5ZLklCXKNc=;
        b=pgGAvtjJ708aQj6Lcu77vMpjK0QiX/zIVljlWTa8WoWPR+LgFr2xtSKXNok7S17pIyug8/
        H/qCdEjOFmywoavWR2sN0/w6lYTDwgaYYl5Rfpw5f8ZVL97gMIEhD6Moa+EWw7xgBCRYOl
        NdMIpdycyw5a8U3/xcRxX/RWkmMMKuk=
Date:   Tue, 28 Mar 2023 17:36:13 +0100
MIME-Version: 1.0
Subject: Re: [patch dpll-rfc 0/7] dpll: initial patchset extension by mlx5
 implementation
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        arkadiusz.kubalewski@intel.com, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2023 18:00, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Hi.
> 
> This is extending your patchset. Basically, I do this on top of the
> changes I pointed out during review. For example patch #6 is exposing
> pin handle which is going to change, etc (there, I put a note).
> 
> First 5 patches are just needed dependencies and you can squash them
> into your patch/patches. Last two patches should go in separatelly.
> 
> Please note that the patch #6 is replacing the need to pass the rclk
> device during pin registration by putting a link between netdev and dpll
> pin.
> 
> Please merge this into your dpll patchset and include it in the next
> RFC. Thanks!
>

Hi Jiri!

Thanks for the patch set. It looks like it covers some changes that I 
have also done to address the comments. I'll try to combine everything 
in a couple of days and will re-spin series and we restart review 
process. I think that there are open question still in the conversation 
which were not answered.

Best,
Vadim
