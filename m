Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92B7281CFA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgJBUfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBUfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:35:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89724C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:35:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D1A511E3E4C6;
        Fri,  2 Oct 2020 13:18:12 -0700 (PDT)
Date:   Fri, 02 Oct 2020 13:34:59 -0700 (PDT)
Message-Id: <20201002.133459.170176193993294293.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2020-10-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 13:18:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Fri, 2 Oct 2020 07:01:06 +0200

> 1) Add a full xfrm compatible layer for 32-bit applications on
>    64-bit kernels. From Dmitry Safonov.
> 
> Please pull or let me know if there are problems.

Pulled, thanks so much.
