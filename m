Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7206811581A
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 21:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLFUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 15:05:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfLFUFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 15:05:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A058150AE492;
        Fri,  6 Dec 2019 12:05:19 -0800 (PST)
Date:   Fri, 06 Dec 2019 12:05:18 -0800 (PST)
Message-Id: <20191206.120518.480573416537037925.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: mdio-thunder: add missed pci_release_regions in
 remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206075446.18469-1-hslester96@gmail.com>
References: <20191206075446.18469-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 12:05:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Fri,  6 Dec 2019 15:54:46 +0800

> The driver forgets to call pci_release_regions() in remove like that
> in probe failure.
> Add the missed call to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
