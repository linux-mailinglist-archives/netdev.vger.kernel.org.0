Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC56EDA18
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjDYB5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjDYB5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C119BF
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F06BF62AE6
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB6BC433EF;
        Tue, 25 Apr 2023 01:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682387828;
        bh=Qvf2WKyuzrdMLiVE0vN8W8R9KBvVkblnjRQ5igMNM/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MW60PkB29+zzCerNSvPwc+MiPnuhMGm6H7JGmGt1xz9ADHY3Lj5ozXbaqOi54bzoB
         YM+izLIVmzAp2YfZWnb3ji7NIkTHt0ftS9eFHmA+gFtUHBznroeKtZYr20aTOXKAtW
         jY/pMjgw5Xf0VJmiWDXHQAF09FFmhDSUnuK9uzo1B/tDGOxoFU57UL6UuEymb+eftB
         rWQVHk6zOyN7GIUrOR8fQcmGnUwzU2y3jMf7sybFjDU7aKvOeq8gw4X7FU6t9H8HVO
         XY7+W9ABcUwDQrfRyt5h4hNHEwtyOzJD6YdSUqkqpSXsjsn7gbVGufxr9a0pCVRvbt
         kRROMo11zd2kA==
Date:   Mon, 24 Apr 2023 18:57:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        linyunsheng@huawei.com
Subject: Re: [PATCH net-next 0/7] Wangxun netdev features support
Message-ID: <20230424185707.73b1dbc1@kernel.org>
In-Reply-To: <20230425015011.19980-1-mengyuanlou@net-swift.com>
References: <20230425015011.19980-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 09:50:04 +0800 Mengyuan Lou wrote:
> Implement tx_csum and rx_csum to support hardware checksum offload.
> Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
> Enable macros in netdev features which wangxun can support.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.
-- 
pw-bot: defer
