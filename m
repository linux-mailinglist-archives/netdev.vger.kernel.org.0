Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EA851546D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbiD2TbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbiD2TbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C788EC74AC;
        Fri, 29 Apr 2022 12:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A85B8377B;
        Fri, 29 Apr 2022 19:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D6AC385A4;
        Fri, 29 Apr 2022 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651260482;
        bh=2d+UHz/5zxzsei7MM6RtAJkyGRt88SKqYYvyvFLBWQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AtuF+p54erDmpmGP/kN5VmKNrOGLoRHnlQXQYDa4s4ZLCqvoTyHE9iUYGTNCswaPy
         ++u1H9HwDsXlNNC7yMdyRE2e/NGv0yUG7PLjul92mXSFcY80NJs3yf92iCqwKAB5Nf
         JpUSx2JVmvxwvFJQxfA2zhHmV/8MXAwlrnhL6MfW0P4OOg4VumZIA0T7uZ4lieApn+
         5lE44QF2GJ6bxtk6Gg8b5UaGCuZNtUMOLmG5DUPk+RlOtgdV+SvO3VPMqdBIjmuixx
         1Crn/SrEEtKFy7rXSwqS6OrLTzz9QQevf990PTJrqgCHufWhSjjiXaQjD4LtZh4dC0
         Gse8KLDV51xUg==
Date:   Fri, 29 Apr 2022 12:28:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220429122800.1df9cd27@kernel.org>
In-Reply-To: <1651244864-14297-1-git-send-email-min.li.xe@renesas.com>
References: <1651244864-14297-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 11:07:43 -0400 Min Li wrote:
> -/*
> +/**
>   * Maximum absolute value for write phase offset in picoseconds
>   *
> + * @channel:  channel
> + * @delta_ns: delta in nanoseconds
> + *

You must have missed my comment about this not being valid kdoc.

  drivers/ptp/ptp_clockmatrix.c:1734: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Also if you're just fixing build issues you can keep Richard's 
review tags.
