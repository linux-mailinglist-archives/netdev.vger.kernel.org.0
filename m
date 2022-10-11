Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF25FA977
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 02:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJKAqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 20:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKAqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 20:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AD613D39;
        Mon, 10 Oct 2022 17:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6680661040;
        Tue, 11 Oct 2022 00:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88088C433C1;
        Tue, 11 Oct 2022 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665449210;
        bh=qzAnevukwzgKzM8k4PiH/jy6hHD8tIFfQp/2qb7dFXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2lizhc7ZNQAgG7oubhnjh/7sFuuU+ymNbjzQ63fHki3ZcrdWVyTD9GKqgVZY7fQi
         7t3Nu+nvz2pueQhmI8ot3kOabCASQ2M7uz6BfcNQRHMqT3kw0Lhfj5mB/SOWFhjMiN
         sZ11vpAl2JngHC039fkRqocsVw2UBngcRn2Z54DG5OzZLZ805bxbaJwFozSzKKodKO
         pWqWNGx+nW5Zel1f+IruM7V1z2Eh/PPh8CV9kg3Wf/KoRub5GlIuRdgtWWV3YmI7li
         qyG2HhtmYXAFSggeUeOOvEMjFCrJztpROXb6R58k5JYOTzPFg0P+TSRj4PfP5rn5Sk
         9blAa5bsKvkkA==
Date:   Mon, 10 Oct 2022 17:46:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Furkan Kardame <f.kardame@manjaro.org>
Cc:     pgwipeout@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add support for Motorcomm yt8531C phy
Message-ID: <20221010174649.57b49c0d@kernel.org>
In-Reply-To: <20221009192405.97118-1-f.kardame@manjaro.org>
References: <20221009192405.97118-1-f.kardame@manjaro.org>
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

On Sun,  9 Oct 2022 22:24:05 +0300 Furkan Kardame wrote:
> From: Peter Geis <pgwipeout@gmail.com>
> 
> This patch adds support for Motorcomm YT8531C which is
> used in OrangePi 3 LTS, OrangePi 4 LTS and OrangePi 800
> Currently being used by Manjaro Arm kernel

# Form letter - net-next is closed

We have already sent the networking pull request for 6.1
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
