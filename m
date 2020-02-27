Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ADF1728EA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgB0TpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:45:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbgB0TpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:45:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DBF3A121633BB;
        Thu, 27 Feb 2020 11:45:24 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:45:24 -0800 (PST)
Message-Id: <20200227.114524.55956544193905668.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, subashab@codeaurora.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/8] net: rmnet: fix several bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227122324.18855-1-ap420073@gmail.com>
References: <20200227122324.18855-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:45:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu, 27 Feb 2020 12:23:24 +0000

> This patchset is to fix several bugs in RMNET module.

Series applied, thank you.
