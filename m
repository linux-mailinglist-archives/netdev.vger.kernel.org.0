Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C59022B914
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgGWWA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgGWWA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:00:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ABFC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:00:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A991011E48C62;
        Thu, 23 Jul 2020 14:43:41 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:00:25 -0700 (PDT)
Message-Id: <20200723.150025.1966416182386618182.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH net-next] net: Enabled MPLS support for devices of type
 ARPHRD_NONE.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595434401-6345-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1595434401-6345-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 14:43:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Wed, 22 Jul 2020 21:43:21 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> This change enables forwarding of MPLS packets from bareudp tunnel
> device which is of type ARPHRD_NONE.
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

This restriction looks just like a massive guessing game.

What is needed by MPLS by a device specifically, and can therefore
this restrictive test be removed entirely?
