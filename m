Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A437D22B635
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgGWSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGWSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:54:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5761AC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:54:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C96C139DEC88;
        Thu, 23 Jul 2020 11:38:14 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:54:58 -0700 (PDT)
Message-Id: <20200723.115458.2252390686193328978.davem@davemloft.net>
To:     jchapman@katalix.com
Cc:     tparkin@katalix.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] l2tp: further checkpatch.pl cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5546fc8d-4c5e-c009-455d-4349833fd8c5@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
        <5546fc8d-4c5e-c009-455d-4349833fd8c5@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:38:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Thu, 23 Jul 2020 19:00:02 +0100

> On 23/07/2020 12:29, Tom Parkin wrote:
>> l2tp hasn't been kept up to date with the static analysis checks offered
>> by checkpatch.pl.
>>
>> This patchset builds on the series "l2tp: cleanup checkpatch.pl
>> warnings".  It includes small refactoring changes which improve code
>> quality and resolve a subset of the checkpatch warnings for the l2tp
>> codebase.
 ...
> Reviewed-by: James Chapman <jchapman@katalix.com>

Series applied.
