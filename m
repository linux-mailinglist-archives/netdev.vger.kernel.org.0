Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C7161D9B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgBQWuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:50:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgBQWuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:50:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F01D15AABE88;
        Mon, 17 Feb 2020 14:50:39 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:50:38 -0800 (PST)
Message-Id: <20200217.145038.166421382667692636.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 0/6] net/smc: patches 2020-02-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217152455.15341-1-ubraun@linux.ibm.com>
References: <20200217152455.15341-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:50:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Mon, 17 Feb 2020 16:24:49 +0100

> here are patches for SMC making termination tasks more perfect.

Series applied, thanks.
