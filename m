Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2937096D
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbfGVTNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:13:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfGVTNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:13:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51A4B15258BBE;
        Mon, 22 Jul 2019 12:13:17 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:13:16 -0700 (PDT)
Message-Id: <20190722.121316.472654771974510671.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan78xx: Merge memcpy + lexx_to_cpus to
 get_unaligned_lexx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719073614.1850-1-hslester96@gmail.com>
References: <20190719073614.1850-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:13:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Fri, 19 Jul 2019 15:36:15 +0800

> Merge the combo use of memcpy and lexx_to_cpus.
> Use get_unaligned_lexx instead.
> This simplifies the code.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
