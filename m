Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DCD60D391
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJYS3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJYS3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:29:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92CB62DD
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE04B618FB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 18:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E816EC433D7;
        Tue, 25 Oct 2022 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666722584;
        bh=z1jMFGp7lv7c2Hel0GXXAUuzit22uZKq/PJTF95fDng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q9kaOwaSo8EZhOX8dcf1Ut9Wke/spb5dPYE2dui8OfBYyq1S/UH4ZTyvPQvFAh8lo
         KRwYe7RWK5+yk8VQ0ohM6BfZ88DQ87xVwLlZG/Tqs1SzFGHP/m+a9W0dOfi3OF5iLg
         YaXi5/PAdy7yCZJdnbsbL/MrttlAjXmWkIW37sbVlk9HFjFrot7VUH5XP/xEmjFHPu
         ZCSkOSQV4wm6lzKUO9qbzAw/X7FphR9QaAY1mbphYIDJiRBbXydYhKRC4ZfhiYB3NE
         z2Y6NIFEioqyW3jeuNgzH1DJ19mjLRG5hKgT92YqNuZq3XFK+fXcdZwEfv20HGw0q8
         7vLFEL8w62C8g==
Date:   Tue, 25 Oct 2022 11:29:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <leon@kernel.org>
Subject: Re: [PATCH net v2] net: fealnx: fix missing pci_disable_device()
Message-ID: <20221025112943.3aa9024d@kernel.org>
In-Reply-To: <20221025130751.1075684-1-yangyingliang@huawei.com>
References: <20221025130751.1075684-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 21:07:51 +0800 Yang Yingliang wrote:
> Add missing pci_disable_device() in error path of probe() and remove() path.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

This is pointless, I'm deleting this driver.
