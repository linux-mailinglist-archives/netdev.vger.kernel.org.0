Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2D18E38
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEIQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:37:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIQhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:37:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EFAF14D03A22;
        Thu,  9 May 2019 09:37:15 -0700 (PDT)
Date:   Thu, 09 May 2019 09:37:14 -0700 (PDT)
Message-Id: <20190509.093714.173209500732608157.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     dmitry.bezrukov@aquantia.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] aqc111: fix endianness issue in aqc111_change_mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509090818.9257-1-oneukum@suse.com>
References: <20190509090818.9257-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:37:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu,  9 May 2019 11:08:16 +0200

> If the MTU is large enough, the first write to the device
> is just repeated. On BE architectures, however, the first
> word of the command will be swapped a second time and garbage
> will be written. Avoid that.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied and queued up for -stable.
