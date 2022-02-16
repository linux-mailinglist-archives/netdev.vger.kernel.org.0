Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227ED4B9163
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiBPTiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:38:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiBPTir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:38:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D327C24BE;
        Wed, 16 Feb 2022 11:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5614B81ED9;
        Wed, 16 Feb 2022 19:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A69C004E1;
        Wed, 16 Feb 2022 19:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040312;
        bh=YUNeMwnffWU/vzA+11lFMuMWe0+JjFTHVyeqME5xzxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RvhRgyEjawXUAql0FqCTCcTpqR6GYBvsqNC9EZPqI5ZukTe3YMkyAiJ+1YKBf+Rlr
         sxewfhO7AtNd8GwQy/RQGGJ/AXgX1LgrWMnZTpDKZCiIl4MoI0X8P3b4yUkf4X3JeP
         l7bOM+By1/829q8HEUDp0joAEckiMlN1bSJeEtmm9DT0v1cg0aKN9haMO+KRTEXTKx
         BIawC1huC6S2hOqZ/gswPro0qF/Bzg0858Vu6QjTMbuvQTz7D1gR8uQt+HV6mEdhmv
         BV4TgmRvjAQDxRzfAaigAGsmsMmR8Yj0ESiy1ZrH3LP0qLNGtaqg4OazRGKQ9Qu6L7
         d13KOv1rLre5w==
Date:   Wed, 16 Feb 2022 13:46:09 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-alpha@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        coresight@lists.linaro.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-staging@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, sparmaintainer@unisys.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        greybus-dev@lists.linaro.org, linux-i3c@lists.infradead.org,
        linux-rdma@vger.kernel.org,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..." 
        <alsa-devel@alsa-project.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220216194609.GA903947@embeddedor>
References: <20220215174743.GA878920@embeddedor>
 <202202151016.C0471D6E@keescook>
 <20220215192110.GA883653@embeddedor>
 <Ygv8wY75hNqS7zO6@unreal>
 <20220215193221.GA884407@embeddedor>
 <CAJZ5v0jpAnQk+Hub6ue6t712RW+W0YBjb_gAcZZbUeuYMGv7mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jpAnQk+Hub6ue6t712RW+W0YBjb_gAcZZbUeuYMGv7mg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 08:05:47PM +0100, Rafael J. Wysocki wrote:
> On Tue, Feb 15, 2022 at 8:24 PM Gustavo A. R. Silva
> <gustavoars@kernel.org> wrote:
> 
> Can you also send the ACPI patch separately, please?
> 
> We would like to route it through the upstream ACPICA code base.

Yeah; no problem.

Thanks
--
Gustavo
