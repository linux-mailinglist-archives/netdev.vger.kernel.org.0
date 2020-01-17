Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16C614081F
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgAQKih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:38:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgAQKig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:38:36 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC9F6155CB0BF;
        Fri, 17 Jan 2020 02:38:31 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:38:30 -0800 (PST)
Message-Id: <20200117.023830.92163389664105434.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2] net: phy: adin: const-ify static data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116141535.26561-1-alexandru.ardelean@analog.com>
References: <20200116141535.26561-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:38:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Thu, 16 Jan 2020 16:15:35 +0200

> Some bits of static data should have been made const from the start.
> This change adds the const qualifier where appropriate.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Applied to net-next, thanks.
