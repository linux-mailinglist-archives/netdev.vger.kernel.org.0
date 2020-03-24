Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD958190430
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgCXEMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:12:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXEMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:12:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42526155F4F75;
        Mon, 23 Mar 2020 21:12:01 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:12:00 -0700 (PDT)
Message-Id: <20200323.211200.284312949396835611.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, sgoutham@marvell.com
Subject: Re: [PATCH v4 net-next 0/8] octeontx2-vf: Add network driver for
 virtual function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:12:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Sat, 21 Mar 2020 00:27:18 +0530

> This patch series adds  network driver for the virtual functions of
> OcteonTX2 SOC's resource virtualization unit (RVU).
 ...

Series applied, thank you.
