Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695FBE7A5E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfJ1Um6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:42:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1Um6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:42:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF43014B79F89;
        Mon, 28 Oct 2019 13:42:57 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:42:57 -0700 (PDT)
Message-Id: <20191028.134257.2207530545679115514.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     isdn@linux-pingi.de, trivial@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] isdn: hfcsusb: Spelling and grammar fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024153155.31162-1-geert+renesas@glider.be>
References: <20191024153155.31162-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:42:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 24 Oct 2019 17:31:55 +0200

> Fix misspellings of "endpoints", "configuration", and "device's".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next.
