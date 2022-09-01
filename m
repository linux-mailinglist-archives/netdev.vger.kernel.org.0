Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1835A8B85
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiIACgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiIACgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:36:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBBDEEC7E;
        Wed, 31 Aug 2022 19:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 838A6B823CD;
        Thu,  1 Sep 2022 02:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C88C433D6;
        Thu,  1 Sep 2022 02:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999778;
        bh=iDgU5RZFbyahMadS6JY2dQFR3WMXl0VHBx0XFhI1uUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YRsh1yfqG+f4Rv8Zar3rYUjCqJnyk346JYw9/RIiV4BxSlC61YoZpCbanlbWh3rZS
         KuoC9AwOzIVGOE0UAKRxnkrU5PeQI0rMgGe3q6FqwaRjzcum/b3THSDvo5rAtFf1JL
         SoT0XibgrjJrr/xldI8yIUBBkzsZpOyOYo7IPktsS9Yw31pzzBz1gOnxblHFKt+l5w
         e9+iMvYlhsUVidW51dNxexczrWmlHNWR5HCIRBS76cvzBXay1FnZnxYp92xRouXZd8
         OiYx9ilgTi6TbCRu4HLdWPB8rsNHm1nFl4hczAz8HKlRFDkZ3fnMFzp32Fe0cEu0KM
         4VqM4Rfujh6RA==
Date:   Wed, 31 Aug 2022 19:36:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fec: add pm_qos support on imx6q platform
Message-ID: <20220831193617.40d7aeed@kernel.org>
In-Reply-To: <20220830070148.2021947-1-wei.fang@nxp.com>
References: <20220830070148.2021947-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 15:01:48 +0800 wei.fang@nxp.com wrote:
> There is a very low probability that tx timeout will occur during
> suspend and resume stress test on imx6q platform. So we add pm_qos
> support to prevent system from entering low level idles which may
> affect the transmission of tx.

Any more info on the issue? Is there an errata for it?
What's the expected power consumption change?
