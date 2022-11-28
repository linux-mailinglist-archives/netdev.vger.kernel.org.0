Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1763B60C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiK1Xjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiK1Xj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:39:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64649F0A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02381B81034
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4C6C433D6;
        Mon, 28 Nov 2022 23:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669678763;
        bh=5sQ21sE2D1n2ZkTPAiYwwE0ozFAMvd2gldty/jct02k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B/SM1hUV3SEY26AHbKpTJzVv52iIIoIMKRlKzDj/ryv4cYucs1aS0sxsvfFnaSb8c
         PD0o1mezPT2ehAtgU+8S66aLcvjMNupHoDdd4uVLmb5e62S02czALTv3ryFCJ/nMPv
         1BN5FPH/wyMYcdjizRHQRl+iD4Ybb+KC5y6TbH8UkZq9R+6YywcZuCXsptcaNyy1zZ
         SnzRnhZh7dd4unWx6Let1X1W0eqZe1/9lJFYxVVAujYjKo/u2CFles6HEeYCmJg7Nm
         s+4y/NodjOmgu/X7BHPZ8uoNJ6itAWL42dsUdlvLKKs/Os2f8N6BRwwjafMH7ivySj
         75s4ISXi55aqA==
Date:   Mon, 28 Nov 2022 15:39:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shannon Nelson <shnelson@amd.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for
 enabling VIF support
Message-ID: <20221128153922.2e94958a@kernel.org>
In-Reply-To: <Y4VEZj7KQG+zSjlh@lunn.ch>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-11-snelson@pensando.io>
        <20221128102953.2a61e246@kernel.org>
        <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
        <Y4U8wIXSM2kESQIr@lunn.ch>
        <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
        <Y4VEZj7KQG+zSjlh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 00:29:42 +0100 Andrew Lunn wrote:
> > How about:
> > 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION  
> 
> Much better.

+1, although I care much less about the define name which is stupidly
long anyway and more about the actual value that the user will see
