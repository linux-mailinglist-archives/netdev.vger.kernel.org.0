Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66B5F0C0C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfKFCcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:32:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42330 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:32:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FBDB1510CC26;
        Tue,  5 Nov 2019 18:32:19 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:32:18 -0800 (PST)
Message-Id: <20191105.183218.1289105160253580168.davem@davemloft.net>
To:     bianpan2016@163.com
Cc:     allison@lohutok.net, gregkh@linuxfoundation.org,
        tglx@linutronix.de, rfontana@redhat.com,
        kstewart@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: fdp: fix incorrect free object
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572942847-35209-1-git-send-email-bianpan2016@163.com>
References: <1572942847-35209-1-git-send-email-bianpan2016@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:32:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>
Date: Tue,  5 Nov 2019 16:34:07 +0800

> The address of fw_vsc_cfg is on stack. Releasing it with devm_kfree() is
> incorrect, which may result in a system crash or other security impacts.
> The expected object to free is *fw_vsc_cfg.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Applied and queued up for -stable, thanks.
