Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA031287B4
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLUF7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:59:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUF7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:59:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A32DE153DB04D;
        Fri, 20 Dec 2019 21:59:00 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:59:00 -0800 (PST)
Message-Id: <20191220.215900.1927724194222990221.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] sfc: fix bugs introduced by XDP patches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
References: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:59:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Fri, 20 Dec 2019 16:24:24 +0000

> Two fixes for bugs introduced by the XDP support in the sfc driver.

Series applied, thanks.
