Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A6E943D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfJ3Avt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:51:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJ3Avt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:51:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BB7E14053340;
        Tue, 29 Oct 2019 17:51:48 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:51:48 -0700 (PDT)
Message-Id: <20191029.175148.1513425500759326163.davem@davemloft.net>
To:     saurav.girepunje@gmail.com
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Subject: Re: [PATCH] broadcom: bnxt: Fix use true/false for bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028201634.GA29069@saurav>
References: <20191028201634.GA29069@saurav>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:51:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saurav Girepunje <saurav.girepunje@gmail.com>
Date: Tue, 29 Oct 2019 01:46:35 +0530

> Use true/false for bool type in bnxt_timer function.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Applied.
