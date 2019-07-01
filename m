Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61E45C52E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGAVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:51:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38858 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGAVvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:51:12 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hi4CZ-0000Q8-Vs; Mon, 01 Jul 2019 21:51:08 +0000
Date:   Mon, 1 Jul 2019 22:51:07 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: fix ntohs/htons sparse warnings
Message-ID: <20190701215107.GF17978@ZenIV.linux.org.uk>
References: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
 <20190701195621.GC17978@ZenIV.linux.org.uk>
 <81c45b3c-bbaa-c619-981c-8b8f4b73d5c5@gmail.com>
 <20190701211356.GD17978@ZenIV.linux.org.uk>
 <20190701214649.GE17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701214649.GE17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:46:49PM +0100, Al Viro wrote:
> already done cpu_to_le32 to the containing 32bit word.  So the
               le32_to_cpu, sorry
