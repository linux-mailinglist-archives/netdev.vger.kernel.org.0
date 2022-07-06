Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB07656942E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGFVUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiGFVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10701B7A4
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F6C162166
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 21:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFDBC3411C;
        Wed,  6 Jul 2022 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657142414;
        bh=eaE9z/Sndc2Jiv59qeQeHtefBhprhY05sBUp2K6hsy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n8XW51c1nTb51aIByBOU/xli8HQK3XnI9nlvbrgj3Gal3diXBfhzPZfURuyT5fs3S
         7VeVs1LavIxkGkkbseIs84q/ONbXLWD/XLAiFuckowrl20bUjCnhnKGNEQ1ZGghggG
         8mydCZsHqKZewQT7lV6dEVFtt0qa3z8ff+8uKyd1OMpBLYg9YQgDFoFuK+Arckvs/c
         PLILMcn0XgDo2uY6oOnYu51iK5/boUVxAEDEWpiQ9dmzKVEWuE92szJR+r4/eLelCM
         In6V4KRasV8fIhq5wVtnUEhdJX/xWtTIqRrokgF3/NOzCsC+yLj+tVi3noO8u4T9pu
         O3BEL3QEAFMxA==
Date:   Wed, 6 Jul 2022 14:20:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 1/2] sfc: Add EF100 BAR config support
Message-ID: <20220706142013.0afe6196@kernel.org>
In-Reply-To: <YsXFbRF/cw4sH0RZ@lunn.ch>
References: <165712441387.6549.4915238154843073311.stgit@palantir17.mph.net>
        <165712447305.6549.5015491740374054340.stgit@palantir17.mph.net>
        <YsXFbRF/cw4sH0RZ@lunn.ch>
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

On Wed, 6 Jul 2022 19:25:01 +0200 Andrew Lunn wrote:
> On Wed, Jul 06, 2022 at 05:21:13PM +0100, Martin Habets wrote:
> > Provide a "bar_config" file in the sysfs directory of the PCI device.
> > This can be used to switch the PCI BAR layout to/from vDPA mode.  
> 
> You probably should also Cc: the PCI maintainers.

And virtio people, just in case.
