Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2BC64E21C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiLOUHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 15:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiLOUHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 15:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960E1F2CB
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 12:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F136B81C4E
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 20:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EE1C433EF;
        Thu, 15 Dec 2022 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671134868;
        bh=XlhAYQ0O9+iNzKxJd5YMyGz+4WCwvkhktFzxaYW9zmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T15IJtEiUBfmkDZ6BjesWlyhfhVlFDlvA10EZS5bh4xbCnwYmykPHwcDB4MmdvSDU
         i6YdDcMKwYFRfqS6vu94CyWOrJ13ui1pcJLC9Qu1jeQUFjfYGHRB8pqrygV8WmLChH
         cHGdLs6X7RsO2avU+ThAZ0hdVWSPfYJ/Hu4sDKd0PgOe0OHF13AvwFEMBg73a0sWGe
         Mq/LmMBXhsB8aR53x5+lhrI8jK3yjdMfmwx28KL1zFfNyy7ChAAo4IOU/lyEMHXzob
         UZfz+mKlzcP/CopswgGjUunx/ukO1mLV5cH8M5pNp8Um6CIAULBxHWUwkFUlKKVhKy
         KyvuQS3rbwHBQ==
Date:   Thu, 15 Dec 2022 12:07:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next v3 v3] JSON output support for Netlink
 implementation of --show-coalesce option
Message-ID: <20221215120747.0f15aa06@kernel.org>
In-Reply-To: <20221215051347.70022-1-glipus@gmail.com>
References: <20221214202213.36ab31c0@kernel.org>
        <20221215051347.70022-1-glipus@gmail.com>
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

On Wed, 14 Dec 2022 22:13:47 -0700 Maxim Georgiev wrote:
> Add --json support for Netlink implementation of --show-coalesce option
> No changes for non-JSON output for this feature.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
