Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9C53162A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiEWTab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiEWT3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABF9C3D2A;
        Mon, 23 May 2022 12:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5642361291;
        Mon, 23 May 2022 19:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FEBC385AA;
        Mon, 23 May 2022 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653333042;
        bh=gU6CSrYMFWwFd3WFnLD8ZSo1TC7jGMJPQAYo0Jivjlw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wqn530CVIOsmLDvIYWsN8yMcW3ieIx5hxHRbJ+SzdUFLoiXyK3oCiVX3IQ5wWLUB8
         I4XYLNgg5VkkBB+g6a2L7vQC7Vx3tmZAv8x/o734JwLDEkUqqzdfOsLYV/5a12PH9h
         4AU4tjwrem8GbefqT8uB06LA+PmOzNu8Kf6rV+fGOzrb5Q382Q06G9twaXcjdpZOBL
         VU8GqrWuG+Rqy+2GO7yPy3uqa9HKfztyUpFXJ4SwNcCUIxZ2naAp/We5ODZaPkAIr6
         u9XUzQB7CRTzXAYEqOXAQQ+ddD4TSNFIUhwetQgYZ+1Ub+plCz/S5H6pWeyvjswBCk
         4qJW2F/pzv6iA==
Date:   Mon, 23 May 2022 12:10:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: marvell: prestera: rework bridge
 flags setting
Message-ID: <20220523121041.3919affc@kernel.org>
In-Reply-To: <GV1P190MB2019161DB961FE1EC006C478E4D49@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
        <20220523184439.5567-2-oleksandr.mazur@plvision.eu>
        <GV1P190MB2019161DB961FE1EC006C478E4D49@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 18:56:26 +0000 Oleksandr Mazur wrote:
> > Subject: [PATCH net-next 1/4] net: marvell: prestera: rework bridge flags setting  
>  
> > This patch series adds support for the MDB handling for the marvell
> > Prestera Driver. It's used to propagate IGMP groups registered within
> > the Kernel to the underlying HW (offload registered groups).  
> ...
> 
> Please ignore this particular patchset series as it's incomplete - i've sent it to public by mistake, and will send an
> actual - V2 - complete patch-series that was meant to be sent out into public;

Please note that net-next is closed for the next two weeks tho:

http://vger.kernel.org/~davem/net-next.html
