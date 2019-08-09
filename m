Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E2888396
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfHIT7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:59:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfHIT7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:59:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32B71144B2EE2;
        Fri,  9 Aug 2019 12:59:09 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:59:08 -0700 (PDT)
Message-Id: <20190809.125908.1344142027833258982.davem@davemloft.net>
To:     johunt@akamai.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565221950-1376-2-git-send-email-johunt@akamai.com>
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
        <1565221950-1376-2-git-send-email-johunt@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:59:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Wed,  7 Aug 2019 19:52:30 -0400

> TCP_BASE_MSS is used as the default initial MSS value when MTU probing is
> enabled. Update the comment to reflect this.
> 
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Applied.
