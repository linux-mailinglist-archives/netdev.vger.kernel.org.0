Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26371CC6E5
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfJEA2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:28:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEA2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:28:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFE1E14F2D926;
        Fri,  4 Oct 2019 17:27:59 -0700 (PDT)
Date:   Fri, 04 Oct 2019 17:27:59 -0700 (PDT)
Message-Id: <20191004.172759.987507160837677462.davem@davemloft.net>
To:     kai.heng.feng@canonical.com
Cc:     hayeswang@realtek.com, mario.limonciello@dell.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8152: Set macpassthru in reset_resume callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004125104.13202-1-kai.heng.feng@canonical.com>
References: <20191004125104.13202-1-kai.heng.feng@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 17:27:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri,  4 Oct 2019 20:51:04 +0800

> r8152 may fail to establish network connection after resume from system
> suspend.
> 
> If the USB port connects to r8152 lost its power during system suspend,
> the MAC address was written before is lost. The reason is that The MAC
> address doesn't get written again in its reset_resume callback.
> 
> So let's set MAC address again in reset_resume callback. Also remove
> unnecessary lock as no other locking attempt will happen during
> reset_resume.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Applied.
