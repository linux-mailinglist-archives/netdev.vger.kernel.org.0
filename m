Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463F859CF20
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiHWDHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiHWDGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:06:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4EA5C96B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4A16129A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7589EC433D6;
        Tue, 23 Aug 2022 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661223863;
        bh=gpxjMXEMfi4+MhP5ukjcVxzdGnd0H6rjthJjlVl6S6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rjtnn1bZw8oTM7PqS6zGBkxzaNB3HjrQ0F6jDI235ADNNJD5ZYYSEANb6MrU7U+oY
         m7k7ri/sB2KeQ9dh50Z/x1zwG4SO/KYcPY7nzbPi+LU/Cu9G5bZER0YtDddBUqn9eZ
         EIU9n0EpQgfqm5D2Sf2w3Kzfh9ZNFF3gUSIBhk2OuFrzYs5iswsTXwqUHmp4lpefsK
         LIvjtEJYJBOv+oKgzmr0A1RMFt0EG98hB6BA/nUyz/CWNLaC87wqcOS5PgpfdsGLsz
         Gl4+CXXNFL9ProTpB4KBzZYfqt5fZWhci5y+M9dpvgLTRLaW9Y7gStmDy1GDpd/CEt
         xF3NhGGVKyycQ==
Date:   Mon, 22 Aug 2022 20:04:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes
Message-ID: <20220822200422.4be18ebb@kernel.org>
In-Reply-To: <1661180814-19350-1-git-send-email-michael.chan@broadcom.com>
References: <1661180814-19350-1-git-send-email-michael.chan@broadcom.com>
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

On Mon, 22 Aug 2022 11:06:50 -0400 Michael Chan wrote:
> This series includes 2 fixes for regressions introduced by the XDP
> multi-buffer feature, 1 devlink reload bug fix, and 1 SRIOV resource
> accounting bug fix.

Acked-by: Jakub Kicinski <kuba@kernel.org>
