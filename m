Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337FC644C1E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLFS6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLFS6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:58:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D72427B0D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31E496184D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 18:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BC5C433C1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670353113;
        bh=7cDvdtr/SbP/CDWL7MhjIoHZQ/eavIlc7tPk7eQ6Od8=;
        h=Date:From:To:Subject:From;
        b=jM6Y8sNHpLGxzaPvfW2qD+HuCPNfRGOACVdgXEcGfXKt+Dr/afsvGNp34rmarA8Le
         f4HAm4sTc0H4W0/XtM10cubcZnLqAEelUHVehbyBA/YeOvBCtaDcbTMhYDqvzGWdHf
         VQJz2LRGUgbkR6XjtQSewHMVwpVS4YVT55JtUDRYPMqlp/pCxAlvTBmW9ZZgm7/dRC
         Y9xfKSlwR5HSVFTnTDH6H8jLYi0cuOpo07UXoh4K4XDi68cftrOHV1y6Gu15dD1qhz
         LHH/MrEkVQYzM/i52FyZAFsHCRfAcy8JX5fgJiO1yd7mfiUHFkbCXM0HcL6q+blA6m
         1lg2igTnGL6kQ==
Date:   Tue, 6 Dec 2022 10:58:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Dec 2022 call minutes
Message-ID: <20221206105832.7ade246d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_05,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've added the meeting notes to this doc:

https://docs.google.com/document/d/1iq7vuleJVyFPZnO-Ey-N7AumxUTgLdnnfR8nuLuNLxw/

And will just use this doc going forward.


Thanks to Pavan for reviews last week, and nVidia's reviews which
are already flowing!
