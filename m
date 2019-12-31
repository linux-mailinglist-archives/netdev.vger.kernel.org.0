Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C712D629
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLaEb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:31:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaEb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:31:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDC8914047984;
        Mon, 30 Dec 2019 20:31:57 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:31:57 -0800 (PST)
Message-Id: <20191230.203157.1125329411445432472.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/3] Improvements to SJA1105 DSA RX
 timestamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227130230.21541-1-olteanv@gmail.com>
References: <20191227130230.21541-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:31:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 15:02:27 +0200

> This series makes the sja1105 DSA driver use a dedicated kernel thread
> for RX timestamping, a process which is time-sensitive and otherwise a
> bit fragile. This allows users to customize their system (probabil an
> embedded PTP switch) fully and allocate the CPU bandwidth for the driver
> to expedite the RX timestamps as quickly as possible.
> 
> While doing this conversion, add a function to the PTP core for
> cancelling this kernel thread (function which I found rather strange to
> be missing).

Series applied, thanks Vladimir.
