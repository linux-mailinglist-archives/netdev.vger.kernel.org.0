Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A125F49B484
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574642AbiAYNBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574682AbiAYM7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:59:00 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC13C061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 04:58:59 -0800 (PST)
Received: from [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4] (unknown [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nuclearcat)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id EA5191F43D40;
        Tue, 25 Jan 2022 12:58:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1643115537;
        bh=73HbB7DfDhPGc8BAChsmii2o3bpAdT7sjK+j339PVe8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NglJDAZqHN2x7AYHou46rqpNxRuHHCygqul9J1WDXM675mLxuehricWCALMU9b0Q9
         U00q9HaiSEoeLykVCbosLm+d76vT2BvJiwxP8y7KUt4iwIbls/AhAkrISaeAwUMhYd
         3l+wrSmNCnXbacc+4Wl6uTsIvdHMLfIYMGgNTCB+0Yfq/VOyC9JcuT3p1AbKj/FrXS
         TetFD9bRO0kQPRSZ6yDxAJbiohTbVyLHC95Xseek6jVswmCsDmsuwneq81b9yrQLKc
         6G83hMaDbd/B0hXcDJFK2fSE5+8pnXBZBKvwZFT0vlaIe/NcU99f0l0C4WWYV27B4q
         ibnbG6hUJWsQg==
Message-ID: <eb1a82b90e6668207d5ef41897bb4453dfc30bdb.camel@collabora.com>
Subject: Re: [PATCH ethtool-next v2] features: add --json support
From:   Denys Fedoryshchenko <denys.f@collabora.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Date:   Tue, 25 Jan 2022 14:58:52 +0200
In-Reply-To: <20220124110249.47b5d504@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <5577ef768eaaab6dd3fc7af5dcc32fb8bbbee68c.camel@collabora.com>
         <20220124110249.47b5d504@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-01-24 at 11:02 -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 10:06:35 +0200 Denys Fedoryshchenko wrote:
> > +                       if (is_json_context()) {
> > +                               print_bool(PRINT_JSON,
> > off_flag_def[i].long_name, NULL, flag_value);
> > +                       } else {
> 
> Would it make sense to report "fixed" and "requested" as nil for the
> special features? I'm not a high level language expert but otherwise
> generic code handling features will have to test for presence of
> those
> keys before accessing them, no?
I thought about this question for a while, some people prefer to check
for key existence, some prefer to have key, but set null value, and
even all my friends were divided in opinion. 
I think you are right, for a stable schema, I'd better add null values
for missing attributes. I will prepare v3.


