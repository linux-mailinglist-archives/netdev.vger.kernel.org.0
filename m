Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B350813335A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAGVSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:18:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgAGVFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:05:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E02ED15A15BB7;
        Tue,  7 Jan 2020 13:05:20 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:05:20 -0800 (PST)
Message-Id: <20200107.130520.1320576842017627906.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/4] ionic: driver updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107034349.59268-1-snelson@pensando.io>
References: <20200107034349.59268-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:05:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon,  6 Jan 2020 19:43:45 -0800

> These are a few little updates for the ionic network driver.
> 
> v2: dropped IBM msi patch
>     added fix for a compiler warning

Series applied, thanks.
