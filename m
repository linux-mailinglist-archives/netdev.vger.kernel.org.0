Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574CA59CF48
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbiHWDLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbiHWDKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A867326E5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 932AB611FE
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0881C433C1;
        Tue, 23 Aug 2022 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661224120;
        bh=RLddHy2Ver5A+E8Q938H308807QiBTfMnw9cQ8FUMC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UcxvaGPtVlkbmHf9vwm4dH08HWmp4mvLHiuTbAcRuHRwVm7wA2jRJU4VsrEmxHSh5
         jof+nWvOjd2FjsdK8gPn2UcDrfskAW3FzD6dBzJ03uUHhUnfWwgfiPrsDpGN5Il/cA
         uAz82UXNpZ5A5qPlW2NkcuxROZUItde2jHY4kNjeFYPkJ379ZAOSKq9O3cg8oNiFFo
         FgJuug6A06jt4o6pr1iT1RstSRGAxRWSvEncjkT9GjCVXhH9COxYgv1nrMfioHBEXZ
         j4hhnPKegSp4ZwgMeWal8wPB3j/EMr6g81i9TwzvpPD1pMOVxmUtXeEHMYOLXUpDYa
         Q2UyeXsdcfbXA==
Date:   Mon, 22 Aug 2022 20:08:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next] net: ngbe: Add build support for ngbe
Message-ID: <20220822200839.0c91b68c@kernel.org>
In-Reply-To: <20220819063157.28315-1-mengyuanlou@net-swift.com>
References: <20220819063157.28315-1-mengyuanlou@net-swift.com>
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

On Fri, 19 Aug 2022 14:31:57 +0800 Mengyuan Lou wrote:
> +================================================================
> +Linux Base Driver for WangXun(R) Gigabit PCI Express Adapters
> +================================================================

I believe this will generate a warning when you try to generate the
documentation with 'make htmldocs'. The length of the '=====' lines
needs to be the same as the length of the text.

> +WangXun Gigabit Linux driver.
> +Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> +
> +
> +Contents
> +========
> +
> +- Support
> +
> +

Can you try to generate the table of contents automatically by using
built-in Sphinx functionality?  Something along the lines of:

.. toctree::
   :maxdepth: 1

perhaps?
