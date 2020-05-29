Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63AA1E8884
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgE2UGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgE2UGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:06:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686ADC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 13:06:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAEA81283ECEF;
        Fri, 29 May 2020 13:06:11 -0700 (PDT)
Date:   Fri, 29 May 2020 13:06:11 -0700 (PDT)
Message-Id: <20200529.130611.331429956712543983.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2020-05-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 13:06:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 29 May 2020 13:03:53 +0200

> 1) Several fixes for ESP gro/gso in transport and beet mode when
>    IPv6 extension headers are present. From Xin Long.
> 
> 2) Fix a wrong comment on XFRMA_OFFLOAD_DEV.
>    From Antony Antony.
> 
> 3) Fix sk_destruct callback handling on ESP in TCP encapsulation.
>    From Sabrina Dubroca.
> 
> 4) Fix a use after free in xfrm_output_gso when used with vxlan.
>    From Xin Long.
> 
> 5) Fix secpath handling of VTI when used wiuth IPCOMP.
>    From Xin Long.
> 
> 6) Fix an oops when deleting a x-netns xfrm interface.
>    From Nicolas Dichtel.
> 
> 7) Fix a possible warning on policy updates. We had a case where it was
>    possible to add two policies with the same lookup keys.
>    From Xin Long.
> 
> Please pull or let me know if there are problems.

Applied, thanks Steffen.
