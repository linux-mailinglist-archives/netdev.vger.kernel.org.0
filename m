Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA346DC8
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfFOCZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:25:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57430 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:25:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED71313411FFE;
        Fri, 14 Jun 2019 19:25:35 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:25:35 -0700 (PDT)
Message-Id: <20190614.192535.1798471759443678637.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] qed: iWARP fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613082943.5859-1-michal.kalderon@marvell.com>
References: <20190613082943.5859-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:25:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Thu, 13 Jun 2019 11:29:39 +0300

> This series contains a few small fixes related to iWARP.

Series applied.
