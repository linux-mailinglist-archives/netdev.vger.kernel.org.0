Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73853BCEF
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiFBQ6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiFBQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:58:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23B42A27B;
        Thu,  2 Jun 2022 09:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 338C4B82045;
        Thu,  2 Jun 2022 16:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FC4C385A5;
        Thu,  2 Jun 2022 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654189077;
        bh=5rLeLdp+YbP+/ucj0teEA5x6RT8O3GDre9gLuIDrYHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HZjBWhXlYVlAodadzXnJB5yyobkNkipRR0DpSQYYTWQYyzfazV5r2WIrTJJN+jzNL
         jzORnlXe5V2nDkpsX7Gpm/fggGP6/6jI9VrkZO+WUdqAI/bV3s2qwCqSrIzxk1x1nE
         UKHGmjhw4gk8yRLpZslG2xQJfRJrKxVKP0H1HNA++e9kKJcC7q5De+dg8lTQuD/DgC
         GcM81s46fH34AO6GxxOizovlMRLC7aM1Nz4hw5PazRrp3lMxpmKJ/w5yVEXlLL1Pp5
         TevsKcXZ1h4Zi9SL5UbiO+7LOKJcbthlSQx0AaMCRfEcwMQBWcvIt429yVLEXeO/RM
         LktKqazPsjQoA==
Date:   Thu, 2 Jun 2022 09:57:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220602095756.764471e8@kernel.org>
In-Reply-To: <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
        <20220601180147.40a6e8ea@kernel.org>
        <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
        <20220602085645.5ecff73f@hermes.local>
        <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jun 2022 16:26:18 +0000 Joakim Tjernlund wrote:
> On Thu, 2022-06-02 at 08:56 -0700, Stephen Hemminger wrote:
> > > Sure, our HW has config/state changes that makes it impossible for net driver
> > > to touch and registers or TX pkgs(can result in System Error exception in worst case.

What is "our HW", what kernel driver does it use and why can't the
kernel driver take care of making sure the device is not accessed
when it'd crash the system?

> Maybe so but it seems to me that this limitation was put in place without much thought.

Don't make unnecessary disparaging statements about someone else's work.
Whoever that person was.
