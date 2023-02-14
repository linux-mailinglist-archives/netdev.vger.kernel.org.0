Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF8569591E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjBNGXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjBNGXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:23:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F68417CF2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03485B81993
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874A7C433EF;
        Tue, 14 Feb 2023 06:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676355825;
        bh=YIVcBFNmzBg6LfskVB0tcXe4+AfHmYvbHv6sEPRQWnE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OIyGP3JuKQT93s6FcpgWiVmMQc6wHOZlqjSqC9MSk0Ido3ef0gCp0d9bx3UtBPRmH
         ZpC2ZPtrRdHx+juvrNznSQEw6MEZuec8lZtCvSnG6/RiXl32l8t7WiUC//g84xg9NF
         NtqQwtkTsl+ODikh1a+/6XfcaRXx0gp1PwXOql1JQveC/Gp9o8QjNsxKsSEIxPld0r
         unKoDVabXj2o7qTtzIxy+a/ZOgwGXfK8zHNg+S21LbgRiFOz19xPvaYJ+Nj8dRNpTe
         5Ny2hkYSX01YSpxjUbnZZfYQBbLQGKi8iyEMcvEkUGXXEBNi9mEOsXq4n9niwtBhRM
         16w9nEAJEeocQ==
Date:   Mon, 13 Feb 2023 22:23:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/10] devlink: cleanups and move devlink
 health functionality to separate file
Message-ID: <20230213222344.10aa7876@kernel.org>
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Feb 2023 15:14:08 +0200 Moshe Shemesh wrote:
> This patchset moves devlink health callbacks, helpers and related code
> from leftover.c to new file health.c. About 1.3K LoC are moved by this
> patchset, covering all devlink health functionality.
> 
> In addition this patchset includes a couple of small cleanups in devlink
> health code and documentation update.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
