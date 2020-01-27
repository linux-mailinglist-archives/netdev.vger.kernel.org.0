Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8850014A52D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgA0Nd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:33:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA0Nd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:33:58 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 340001570D63C;
        Mon, 27 Jan 2020 05:33:56 -0800 (PST)
Date:   Mon, 27 Jan 2020 14:33:54 +0100 (CET)
Message-Id: <20200127.143354.920658271738682867.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, sgoutham@marvell.com
Subject: Re: [PATCH v6 00/17] octeontx2-pf: Add network driver for physical
 function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 05:33:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Mon, 27 Jan 2020 18:35:14 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> OcteonTX2 SOC's resource virtualization unit (RVU) supports
> multiple physical and virtual functions. Each of the PF's
> functionality is determined by what kind of resources are attached
> to it. If NPA and NIX blocks are attached to a PF it can function
> as a highly capable network device.
> 
> This patch series add a network driver for the PF. Initial set of
> patches adds mailbox communication with admin function (RVU AF)
> and configuration of queues. Followed by Rx and tx pkts NAPI
> handler and then support for HW offloads like RSS, TSO, Rxhash etc.
> Ethtool support to extract stats, config RSS, queue sizes, queue
> count is also added.
> 
> Added documentation to give a high level overview of HW and
> different drivers which will be upstreamed and how they interact.
 ...

Series applied.
