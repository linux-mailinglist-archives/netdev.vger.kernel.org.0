Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431455BE8FA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiITOab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiITOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E33F1C8;
        Tue, 20 Sep 2022 07:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8305AB82A47;
        Tue, 20 Sep 2022 14:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA9C433C1;
        Tue, 20 Sep 2022 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663684205;
        bh=I74h6Nr+i8FTSqMM2icXg4l/Z8d01teWye2vzkJV1Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tHarhIC2/v9gdXe8pFO5gXOuAP/7hsBnlKicHFa4HPoAj/rpPDrietRKjaL4T/Jh6
         ZdvbDq80prp81jUORiUO9QansekQg8YHYHrA/R14iIDhXbuZJ6QtnH7cqPeFWF3ztD
         hXqC/4Y/dT7gwvq0UdYzLgOqKA3n2d2nlyxTAiBUVFmdRu+VxNIRAFji/s14TQFyn8
         S8G767aHCoBNK/rt2XKGk+/82GueazboMFIICcJantWmx7ibIkRvX6LXAnU6dJkEYK
         ldsGZtRZ71AmJhh1Sqq26kmLwBrRPtpgwZqJozUz+lUd44jaF22Zy7BkoIoRfKrK5Y
         kNf+jquNSTU3w==
Date:   Tue, 20 Sep 2022 07:30:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Casper Andersson <casper.casan@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sparx5: Fix return type of sparx5_port_xmit_impl
Message-ID: <20220920073003.5dab2753@kernel.org>
In-Reply-To: <20220912214432.928989-1-nhuck@google.com>
References: <20220912214432.928989-1-nhuck@google.com>
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

On Mon, 12 Sep 2022 14:44:29 -0700 Nathan Huckleberry wrote:
> -int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
> +netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)

Similarly to mana this has a prototype.
