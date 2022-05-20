Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDE52E25C
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiETCJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiETCJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3FD69CC6;
        Thu, 19 May 2022 19:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1727061BBD;
        Fri, 20 May 2022 02:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57067C385AA;
        Fri, 20 May 2022 02:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653012556;
        bh=gl4KrzZh297pzyRBGrg99DuXFVso9aKDezZKbkvLka8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YZqZgOM2RS1anErK0S9CnH5Hy111XLdQfjNiLiXSmXHTxCZhBVa0rSQpE/QmbHmI4
         VKTtX5cnaC1DiUP/9oLVs2WTxw4rM/O9y+05jgNPcH0gK9ru6CNlhGvknW1LsUS8Y3
         M/+j78CGPRttCfuwcEBqo8xrpKRXefD6saeMuin2clcuEgKekeyqZPWgdFgKQSwnjJ
         Syd6bepO59Ikezl4tD8JsaWRKenKNyrjRH2xttUWWzPoKMNDVVMypMocKiJFKP/JRV
         bCNFnnPPDR1hE0KfS1g3+Wwrbd4dYSZnWatsKnMIbgS8UeHBC+29vgFpYYdhMC52gA
         FGqNtQs05mIiA==
Date:   Thu, 19 May 2022 19:09:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
Message-ID: <20220519190915.086d4c89@kernel.org>
In-Reply-To: <CADxym3Y7MkGWmu+8y8Kpcf39QJ5207-VaEnCsYKRDqnpre1O0Q@mail.gmail.com>
References: <20220513030339.336580-1-imagedong@tencent.com>
        <20220513030339.336580-5-imagedong@tencent.com>
        <20220519084851.4bce4bdd@kernel.org>
        <CADxym3Y7MkGWmu+8y8Kpcf39QJ5207-VaEnCsYKRDqnpre1O0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 09:46:49 +0800 Menglong Dong wrote:
> > This patch is in net, should this fix have been targeting net / 5.18?  
> 
> Yeah, I think it should have. What do I need to do? CC someone?

Too late now, I was just double checking. It can make its way to the
current release via stable in a week or two.

BTW I'm about to send a fixup to patch 4, stay tuned.
