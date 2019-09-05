Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717CBA9C03
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfIEHip convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Sep 2019 03:38:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIEHip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:38:45 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4712315385180;
        Thu,  5 Sep 2019 00:38:44 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:38:43 -0700 (PDT)
Message-Id: <20190905.003843.1778157180987159235.davem@davemloft.net>
To:     dave.taht@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Convert usage of IN_MULTICAST to
 ipv4_is_multicast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567466976-1351-1-git-send-email-dave.taht@gmail.com>
References: <1567466976-1351-1-git-send-email-dave.taht@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:38:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Taht <dave.taht@gmail.com>
Date: Mon,  2 Sep 2019 16:29:36 -0700

> IN_MULTICAST's primary intent is as a uapi macro.
> 
> Elsewhere in the kernel we use ipv4_is_multicast consistently.
> 
> This patch unifies linux's multicast checks to use that function
> rather than this macro.
> 
> Signed-off-by: Dave Taht <dave.taht@gmail.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>

Applied.
