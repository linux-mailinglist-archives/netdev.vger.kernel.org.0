Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74418182899
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgCLFyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:54:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387677AbgCLFyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:54:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B60214C7E034;
        Wed, 11 Mar 2020 22:54:41 -0700 (PDT)
Date:   Wed, 11 Mar 2020 22:54:40 -0700 (PDT)
Message-Id: <20200311.225440.1308156134613675721.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, ap420073@gmail.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v2] bareudp: Fixed bareudp receive handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583982231-20060-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1583982231-20060-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 22:54:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Thu, 12 Mar 2020 08:33:51 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> Reverted commit "2baecda bareudp: remove unnecessary udp_encap_enable() in
> bareudp_socket_create()"
> 
> An explicit call to udp_encap_enable is needed as the setup_udp_tunnel_sock
> does not call udp_encap_enable if the if the socket is of type v6.
> 
> Bareudp device uses v6 socket to receive v4 & v6 traffic
> 
> CC: Taehee Yoo <ap420073@gmail.com>
> Fixes: 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>     - Add Comments in the code.

Applied, thanks Martin.
