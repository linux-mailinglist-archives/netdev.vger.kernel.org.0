Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9078601870
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJQUBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiJQUBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:01:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41CE3472D;
        Mon, 17 Oct 2022 13:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F78B81624;
        Mon, 17 Oct 2022 20:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A35C433D6;
        Mon, 17 Oct 2022 20:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666036869;
        bh=7KlSg8SpQFEJciR5s/+roAlWjZhs+AWUquJdqGL1TIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YsOo0neW6JNtTxxdU5j0mcKehwCVDNpf5Pj4flBAMPBK8MzJwRmw/2C5L102U4NDZ
         2/iv8TOMYmg4dqq6VKbbpRtU1v7uezp8b9j81XEUlo9NDe1lPjR57dQpD8ivEY8Owu
         KN7jo2i3vjXwxzrsNS0/BaRbNu6Z7rswDL9GSh2BIIr2jztCwofIqujaiwXLRJ2PJS
         9YYBgg8m8b2jScToiQCeqQkLzU40cUXCILChXkxBaS3CW7qZFXl09cgiXCqnPz65Tp
         t+00mhbVETQFH5gQPWDku8Zlr1mw2s9yfThp54E9tJFNt1/GBw4d57vwsOJ6WV8xrV
         Yhd7Wxv1JOMew==
Date:   Mon, 17 Oct 2022 13:01:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+9abe5ecc348676215427@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] upstream boot error: WARNING in __netif_set_xps_queue
Message-ID: <20221017130108.54a178db@kernel.org>
In-Reply-To: <0000000000004fc10b05eb318d60@google.com>
References: <0000000000004fc10b05eb318d60@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Oct 2022 19:15:40 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz dup: [syzbot] usb-testing boot error: WARNING in __netif_set_xps_queue
