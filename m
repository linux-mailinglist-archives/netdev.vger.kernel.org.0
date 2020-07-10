Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF92C21BF44
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgGJVcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgGJVcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:32:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948CAC08C5DC;
        Fri, 10 Jul 2020 14:32:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 517CC12868394;
        Fri, 10 Jul 2020 14:32:18 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:32:17 -0700 (PDT)
Message-Id: <20200710.143217.2221359404710785971.davem@davemloft.net>
To:     moshe@mellanox.com
Cc:     kuba@kernel.org, jiri@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/7] Add devlink-health support for devlink
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:32:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>
Date: Fri, 10 Jul 2020 15:25:06 +0300

> Implement support for devlink health reporters on per-port basis.

Series applied, thank you.
