Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45D58CE18
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiHHS4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiHHS4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03051834B
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 11:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7EB0B8105B
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 18:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23121C433D6;
        Mon,  8 Aug 2022 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659984976;
        bh=5QUv4I+eb/0Rq9D9QmVYbLy8J+PzGDU3sLmT4gpoM7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=feUQGM5BpuDaZ7JlvSojO9gZkyzqv2ANugutRmqC5vVxkbRr8d8p7Hnld4Qqfib7P
         WIlYgE8ZzUroZdI63m+d+muaHeYre50kQD5Grn/Y+uDRNHrxnlp6cd2iSJ32Pgr/dT
         HnYCQvyisD0D7tHM0pR4hintRrz/Y7bO2gelN69VBFRZzLLs/lEGrS0MM52ilKbUod
         fxLzHx8n189yzxTTTeXOJibfhOnebKtDSKkPowXSA0BLc4jo4uHS7Fc79so/Phc5CZ
         cuveEcLhspMDICzSbYx6FQs6SgGLswjyohcS68Ea9OEZnlHXyaL71965P1zEP/l0zf
         0wt0aF9d14PMA==
Date:   Mon, 8 Aug 2022 11:56:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next] net: ngbe: Add build support for ngbe
Message-ID: <20220808115615.0d9842fc@kernel.org>
In-Reply-To: <20220808094113.9434-1-mengyuanlou@net-swift.com>
References: <20220808094113.9434-1-mengyuanlou@net-swift.com>
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

On Mon,  8 Aug 2022 17:41:13 +0800 Mengyuan Lou wrote:
> Add build options and guidance doc.
> Initialize pci device access for Wangxun Gigabit Ethernet devices.

# Form letter - net-next is closed

We have already sent the networking pull request for 6.0
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
