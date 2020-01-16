Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36813DABF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgAPM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:59:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAPM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:59:17 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52F8915B5D399;
        Thu, 16 Jan 2020 04:59:15 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:59:14 -0800 (PST)
Message-Id: <20200116.045914.623230506580275299.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_gswip: fix typo in tagger name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115085438.11948-1-alobakin@dlink.ru>
References: <20200115085438.11948-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:59:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Wed, 15 Jan 2020 11:54:38 +0300

> The correct name is GSWIP (Gigabit Switch IP). Typo was introduced in
> 875138f81d71a ("dsa: Move tagger name into its ops structure") while
> moving tagger names to their structures.
> 
> Fixes: 875138f81d71a ("dsa: Move tagger name into its ops structure")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Applied and queued up for -stable, thanks.
