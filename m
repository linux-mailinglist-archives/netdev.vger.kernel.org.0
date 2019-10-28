Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF2E7D20
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfJ1Xj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:39:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfJ1Xj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:39:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B55714BF4677;
        Mon, 28 Oct 2019 16:39:28 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:39:27 -0700 (PDT)
Message-Id: <20191028.163927.342985748289780496.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/2] pull request for net: batman-adv 2019-10-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025092216.12791-1-sw@simonwunderlich.de>
References: <20191025092216.12791-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:39:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 25 Oct 2019 11:22:14 +0200

> here are two bugfixes which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
