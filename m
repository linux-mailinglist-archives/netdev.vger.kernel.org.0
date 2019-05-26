Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84582AC26
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfEZUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:41:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfEZUls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 16:41:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D84D14249643;
        Sun, 26 May 2019 13:41:48 -0700 (PDT)
Date:   Sun, 26 May 2019 13:41:47 -0700 (PDT)
Message-Id: <20190526.134147.1633700720456673866.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net 0/3] dpaa2-eth: Fix smatch warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 13:41:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Fri, 24 May 2019 18:15:14 +0300

> Fix a couple of warnings reported by smatch.

Series applied.
