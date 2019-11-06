Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB329F1D3A
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfKFSMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:12:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52584 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfKFSMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:12:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 723BD1537B3BA;
        Wed,  6 Nov 2019 10:12:17 -0800 (PST)
Date:   Wed, 06 Nov 2019 10:12:14 -0800 (PST)
Message-Id: <20191106.101214.1078731997369268318.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] netdevsim: fix tests and netdevsim
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105212612.10737-1-jakub.kicinski@netronome.com>
References: <20191105212612.10737-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 10:12:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue,  5 Nov 2019 13:26:10 -0800

> The first patch fixes a merge which brought back some dead
> code. Next a tiny re-write of the main test using netdevsim
> aims to ease debugging.

Series applied, thanks Jakub.
