Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94BC5251C8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356144AbiELQDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356147AbiELQDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:03:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F0A6161F;
        Thu, 12 May 2022 09:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB86B8289C;
        Thu, 12 May 2022 16:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383A9C385B8;
        Thu, 12 May 2022 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652371381;
        bh=ENNjqZk7tW88/I+zGS//W6EL/5k5gj2/CoPpQpDO9bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GK9PF0FKQ/YAdn0dXv9fcFH78h1BTwEfQ14DUKNa8Co+s2sdThZY7l5aEP3xUcSDW
         NZMn/aaPtEIrxjM3X0/j/blLbhqax8Oi2an/75fvJT4uvCfric3UIWOvDLTvhiWBTp
         cpu1GuB3V4DcpDyOjzA+nAc6FOdaEi8k+A/0TW2D1QI69sJZwlKz70QQlEK9V9Qb/c
         0/If7Z+UHVoMXVC8gAnjdInGcjpSYcNk+JZMnc2zj96u7LVXDX5Q7xON+NcDaSa4RN
         Fw8pgaOqQbPNF/7fPH7nNtTAsZFoHbszMdn0uHeoNPv+jg4kcKLLPrmcDrPaajWsXF
         6NiVaUvrxru4Q==
Date:   Thu, 12 May 2022 09:03:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Message-ID: <20220512090300.162e5441@kernel.org>
In-Reply-To: <OS3PR01MB659312F189453925868225B2BACB9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
        <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
        <20220511173732.7988807e@kernel.org>
        <OS3PR01MB659312F189453925868225B2BACB9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 03:12:13 +0000 Min Li wrote:
> > Not what I meant. I guess you don't speak English so no point trying to
> > explain. Please resend v4 and we'll merge that. v5 is not better.  
> 
> Where do you want me to do it then? PATCH 2?

First of all, I don't understand why you keep sending these patches for
net. Please add more information about the changes to the commit
messages.

For the formatting I was complaining about - you should fold updates to
the code you're _already_modifying_ into the relevant patches.

You can clean up the rest of the code but definitely not in net. Code
refactoring goes to net-next.

Perhaps a read of the netdev FAQ will elucidate what I'm on about:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
