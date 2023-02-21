Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60D169E573
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbjBURCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbjBURCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:02:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C5B2;
        Tue, 21 Feb 2023 09:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9C3B80E0D;
        Tue, 21 Feb 2023 17:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07ADC433EF;
        Tue, 21 Feb 2023 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676998921;
        bh=XwRKixfVP1CE7jMp5yp72P0P1rYw0HpsSm6t5ba/gCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GlQ57A0Oe63MQlWLUsb87Usm6khG33Nq2C57NJC5Ur9z+B2pU0qER1PS8AtY904/b
         MU0WRne77gXbnSiu3Y8PnQldPXC+RXteQzybyIgxPn8grSBuNsIJnBXBKwBbtMIvVL
         NLc0KGBDiuvccIA+iP9H43DSjnL45Z2hwpS0tc+iC7tFifYuLlCnwESgHieKr+9rrI
         MuVHOFR01W095k2IrHhww6f7iAqWa70zM6KPqTUPmCEyysNtkTbT2emJV2Q6xhxvQT
         d6EXqrOrfo5Mz4ntvM5zev7aZ8D1zntAorhg/C8TAvCBtpBhWSo6FCCWymSHKR6oL7
         1KanvIvtkEKww==
Date:   Tue, 21 Feb 2023 09:01:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Bo Liu <liubo03@inspur.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rempel-privat.de,
        bagasdotme@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <20230221090159.4fa9a548@kernel.org>
In-Reply-To: <Y/TxxBYvHrv1mZfJ@corigine.com>
References: <20230221083036.2414-1-liubo03@inspur.com>
        <Y/TxxBYvHrv1mZfJ@corigine.com>
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

On Tue, 21 Feb 2023 17:31:00 +0100 Simon Horman wrote:
> On Tue, Feb 21, 2023 at 03:30:36AM -0500, Bo Liu wrote:
> > Remove the repeated word "for" in comments.
> > 
> > Signed-off-by: Bo Liu <liubo03@inspur.com>  
> 
> net-next is closed.
> 
> You'll need to repost this patch after v6.3-rc1 has been tagged.
> 
> Also, when reposting please indicate that it is targeted
> at net-next by including [PATCH net-next] in the subject.
> 
> Ref: https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

I was planning on applying it, actually, it's just a comment change
and PR is not yet out.
