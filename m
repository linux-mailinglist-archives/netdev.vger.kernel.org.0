Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB05024080
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfETSgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:36:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56156 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfETSgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:36:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 419CC14EC8402;
        Mon, 20 May 2019 11:36:46 -0700 (PDT)
Date:   Mon, 20 May 2019 11:36:45 -0700 (PDT)
Message-Id: <20190520.113645.324435405678472757.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, ereza@mellanox.com
Subject: Re: [PATCH net] net/mlx4_en: ethtool, Remove unsupported SFP
 EEPROM high pages query
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558363372-31719-1-git-send-email-tariqt@mellanox.com>
References: <1558363372-31719-1-git-send-email-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 11:36:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Mon, 20 May 2019 17:42:52 +0300

> From: Erez Alfasi <ereza@mellanox.com>
> 
> Querying EEPROM high pages data for SFP module is currently
> not supported by our driver but is still tried, resulting in
> invalid FW queries.
> 
> Set the EEPROM ethtool data length to 256 for SFP module to
> limit the reading for page 0 only and prevent invalid FW queries.
> 
> Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support")
> Signed-off-by: Erez Alfasi <ereza@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> ---
> 
> Hi Dave, please queue for -stable.

Applied and queued up for -stable, thanks Tariq.
