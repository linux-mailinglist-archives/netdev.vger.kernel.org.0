Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5347D1442D
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfEFExA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:53:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfEFExA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:53:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B91DE12DAD570;
        Sun,  5 May 2019 21:52:59 -0700 (PDT)
Date:   Sun, 05 May 2019 21:52:59 -0700 (PDT)
Message-Id: <20190505.215259.1525804779251332401.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/10] Traffic support for SJA1105 DSA
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:52:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun,  5 May 2019 13:19:19 +0300

> This patch set is a continuation of the "NXP SJA1105 DSA driver" v3
> series, which was split in multiple pieces for easier review.
 ...

Series applied.
