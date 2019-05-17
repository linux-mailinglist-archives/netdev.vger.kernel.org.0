Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E6921D92
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfEQSk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:40:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfEQSkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:40:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B6AF13F18517;
        Fri, 17 May 2019 11:40:55 -0700 (PDT)
Date:   Fri, 17 May 2019 11:40:54 -0700 (PDT)
Message-Id: <20190517.114054.1205743428379284975.davem@davemloft.net>
To:     philippe.mazenauer@outlook.de
Cc:     lee.jones@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: Correct comment of prandom_seed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <AM0PR07MB44176BAB0BA6ACAAA8C6DC88FD0B0@AM0PR07MB4417.eurprd07.prod.outlook.com>
References: <AM0PR07MB44176BAB0BA6ACAAA8C6DC88FD0B0@AM0PR07MB4417.eurprd07.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 11:40:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Philippe Mazenauer <philippe.mazenauer@outlook.de>
Date: Fri, 17 May 2019 10:44:44 +0000

> Variable 'entropy' was wrongly documented as 'seed', changed comment to
> reflect actual variable name.
> 
> ../lib/random32.c:179: warning: Function parameter or member 'entropy' not described in 'prandom_seed'
> ../lib/random32.c:179: warning: Excess function parameter 'seed' description in 'prandom_seed'
> 
> Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>

Applied.
