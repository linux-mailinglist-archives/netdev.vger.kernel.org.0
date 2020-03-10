Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D9C17EE8C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCJC00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:26:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgCJC0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:26:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF53511E3C074;
        Mon,  9 Mar 2020 19:26:24 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:26:24 -0700 (PDT)
Message-Id: <20200309.192624.1038727270612185821.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, opensource@vdorst.com,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de
Subject: Re: [PATCH] net: dsa: mt7530: add support for port mirroring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306123535.7540-1-dqfext@gmail.com>
References: <20200306123535.7540-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:26:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Fri,  6 Mar 2020 20:35:35 +0800

> Add support for configuring port mirroring through the cls_matchall
> classifier. We do a full ingress and/or egress capture towards a
> capture port.
> MT7530 supports one monitor port and multiple mirrored ports.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied to net-next, thank you.
