Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3815EA47F7
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfIAGyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:54:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfIAGyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:54:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D47214CDC651;
        Sat, 31 Aug 2019 23:54:23 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:54:23 -0700 (PDT)
Message-Id: <20190831.235423.1538075953540344193.davem@davemloft.net>
To:     benwei@fb.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 net-next] net/ncsi: add response handlers for PLDM
 over NC-SI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CH2PR15MB3686A26D4BB64D8959B519B6A3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB3686A26D4BB64D8959B519B6A3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:54:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Wei <benwei@fb.com>
Date: Fri, 30 Aug 2019 20:50:51 +0000

> This patch adds handlers for PLDM over NC-SI command response.
> 
> This enables NC-SI driver recognizes the packet type so the responses
> don't get dropped as unknown packet type.
> 
> PLDM over NC-SI are not handled in kernel driver for now, but can be
> passed back to user space via Netlink for further handling.
> 
> Signed-off-by: Ben Wei <benwei@fb.com>
> ---
> Changes in v2 
>   - fix function definition spacing

Applied.
