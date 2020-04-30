Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD6C1C07CF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgD3UYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgD3UYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:24:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD7EC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:24:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4239128AD8C4;
        Thu, 30 Apr 2020 13:24:34 -0700 (PDT)
Date:   Thu, 30 Apr 2020 13:24:33 -0700 (PDT)
Message-Id: <20200430.132433.1100258513284854034.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/3] tcp: sack compression changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430173543.41026-1-edumazet@google.com>
References: <20200430173543.41026-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 13:24:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 30 Apr 2020 10:35:40 -0700

> Patch series refines SACK compression.
> 
> We had issues with missing SACK when TCP option space is tight.
> 
> Uses hrtimer slack to improve performance.

Series applied, thanks Eric.
