Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D691904CB
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXFP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:15:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXFP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:15:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36FF91581AD06;
        Mon, 23 Mar 2020 22:15:27 -0700 (PDT)
Date:   Mon, 23 Mar 2020 22:15:26 -0700 (PDT)
Message-Id: <20200323.221526.1694071401900753436.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, christian.herber@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] PTP_CLK pin configuration for SJA1105 DSA
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323225924.14347-1-olteanv@gmail.com>
References: <20200323225924.14347-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 22:15:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 24 Mar 2020 00:59:20 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support for the PTP_CLK pin on SJA1105 to be configured
> via the PTP subsystem, in the "periodic output" and "external timestamp
> input" modes.

Series applied, thanks.
