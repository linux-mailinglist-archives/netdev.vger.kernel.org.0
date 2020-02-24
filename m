Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6D16B236
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBXV2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:28:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBXV2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:28:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB1E8121A82E7;
        Mon, 24 Feb 2020 13:28:42 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:28:42 -0800 (PST)
Message-Id: <20200224.132842.2112142868734722035.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 04/30] sctp: Add missing annotation for
 sctp_err_finish()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200223231711.157699-5-jbi.octave@gmail.com>
References: <0/30>
        <20200223231711.157699-1-jbi.octave@gmail.com>
        <20200223231711.157699-5-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:28:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:45 +0000

> Sparse reports a warning at sctp_err_finish()
> warning: context imbalance in sctp_err_finish() - unexpected unlock
> 
> The root cause is a missing annotation at sctp_err_finish()
> Add the missing  __releases(&((__sk)->sk_lock.slock)) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.
