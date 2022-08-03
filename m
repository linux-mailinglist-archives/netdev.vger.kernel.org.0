Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E160589236
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiHCSY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 14:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiHCSYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 14:24:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776A1A81B;
        Wed,  3 Aug 2022 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U+pZAt+03n4M/57/5mcFyucbdPfZpXw4ftAJua0/l+c=; b=X19H3L/oBBa6iDbkLjtYBELFBy
        KHeac8DchWOnDab6QhjQbMq1yUenwo7v2Fw08EwEq0v0/io7xD2nN/NqzXZpMyogp26wYkwE/6w/c
        S5X5iU5Ihu/KPHfIWld8UZbpG3IhxTowhGXISmAvyr6WtNpr9xp6iYEFFD+jn7QfQpfM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJJ2C-00CMaM-4v; Wed, 03 Aug 2022 20:23:56 +0200
Date:   Wed, 3 Aug 2022 20:23:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Message-ID: <Yuq9PMIfmX0UsYtL@lunn.ch>
References: <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
 <20220803164045.3585187-2-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803164045.3585187-2-adel.abushaev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Statistics
> +==========
> +
> +QUIC Tx offload to the kernel has counters reflected in /proc/net/quic_stat:
> +
> +  QuicCurrTxSw  - number of currently active kernel offloaded QUIC connections
> +  QuicTxSw      - accumulative total number of offloaded QUIC connections
> +  QuicTxSwError - accumulative total number of errors during QUIC Tx offload to
> +                  kernel

netlink messages please, not /proc for statistics. netlink is the
preferred way to configure and report about the network stack.

	 Andrew
