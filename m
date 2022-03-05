Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F8F4CE684
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 20:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiCETMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 14:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiCETMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 14:12:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78C1288;
        Sat,  5 Mar 2022 11:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SLP0WyqEvad0PO6hlENZXK4ND7Ul3v2jz3TLWVZXQQM=; b=Yr+W3sDBiz9o4jAIl/CgKgz4L8
        eOq+yh2Q3zHNfvpxWHOifyr6M8oLmW0GvQJD3AXARtxa2Asmu9WuuPb58yaIuJAPDUKaYJMZxSaeZ
        Kyy/2QK8ndqysfsj/SPARb724nIwywqx5n60M/NDE8REXbFR54Av4CYHLp47wxassgm4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQZo2-009PSY-8Q; Sat, 05 Mar 2022 20:11:06 +0100
Date:   Sat, 5 Mar 2022 20:11:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     trix@redhat.com
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] net: dsa: return success if there was nothing to do
Message-ID: <YiO1yrlc2lLOx2KR@lunn.ch>
References: <20220305171448.692839-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305171448.692839-1-trix@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 09:14:48AM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative issue
> dsa.c:486:2: warning: Undefined or garbage value
>   returned to caller
>   return err;
>   ^~~~~~~~~~
> 
> err is only set in the loop.  If the loop is empty,
> garbage will be returned.  So initialize err to 0
> to handle this noop case.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
