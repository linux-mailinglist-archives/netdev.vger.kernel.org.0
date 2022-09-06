Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D15ADC59
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiIFAZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 20:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIFAZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 20:25:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9A8237F8
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 17:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6mg7Z+kUsfd5BvDbtwKnpE9/oi/A+r1iUYj8CmFMbDM=; b=3oLLc1Fj44FAYNav2kdHq9TrTk
        i7YxfCpxgArD8zIKjVb7DNOvSQeBpKrsiWlyIsOqMRlWrHMKutoyN1z7N9loKi8tKnnPvaPbp9kO9
        SP3hrpCUQXHp47o59fduVA7zOopoJJ1NQMWHWENvLTcBbRs9sokq8Tb27pF20qD8fX7E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVMOy-00FhZ9-2B; Tue, 06 Sep 2022 02:25:16 +0200
Date:   Tue, 6 Sep 2022 02:25:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: ftmac100: fix endianness-related issues
 from 'sparse'
Message-ID: <YxaTbDoCOA1+23zP@lunn.ch>
References: <20220902113749.1408562-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902113749.1408562-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 02:37:49PM +0300, Sergei Antonov wrote:
> Sparse found a number of endianness-related issues of these kinds:
> 
> .../ftmac100.c:192:32: warning: restricted __le32 degrades to integer
> 
> .../ftmac100.c:208:23: warning: incorrect type in assignment (different base types)
> .../ftmac100.c:208:23:    expected unsigned int rxdes0
> .../ftmac100.c:208:23:    got restricted __le32 [usertype]
> 
> .../ftmac100.c:249:23: warning: invalid assignment: &=
> .../ftmac100.c:249:23:    left side has type unsigned int
> .../ftmac100.c:249:23:    right side has type restricted __le32
> 
> .../ftmac100.c:527:16: warning: cast to restricted __le32
> 
> Change type of some fields from 'unsigned int' to '__le32' to fix it.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
