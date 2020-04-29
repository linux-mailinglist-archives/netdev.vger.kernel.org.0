Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226D61BE9D2
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgD2VYU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 17:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2VYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 17:24:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2D2C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 14:24:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AC0E121938E4;
        Wed, 29 Apr 2020 14:24:19 -0700 (PDT)
Date:   Wed, 29 Apr 2020 14:24:18 -0700 (PDT)
Message-Id: <20200429.142418.916531268885005041.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] wireguard fixes for 5.7-rc4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429205922.295361-1-Jason@zx2c4.com>
References: <20200429205922.295361-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 14:24:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 29 Apr 2020 14:59:19 -0600

> Hi Dave,
> 
> This series contains two fixes and a cleanup for wireguard:
> 
> 1) Removal of a spurious newline, from Sultan Alsawaf.
> 
> 2) Fix for a memory leak in an error path, in which memory allocated
>    prior to the error wasn't freed, reported by Sultan Alsawaf.
> 
> 3) Fix to ECN support to use RFC6040 properly like all the other tunnel
>    drivers, from Toke Høiland-Jørgensen.

Series applied, and patches #2 and #3 queued up for -stable.
