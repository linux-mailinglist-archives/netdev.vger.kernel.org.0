Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E35BEC04
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 08:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393090AbfIZGee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 02:34:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59373 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392999AbfIZGed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 02:34:33 -0400
Received: from marcel-macpro.fritz.box (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id C7ECACECDA;
        Thu, 26 Sep 2019 08:43:23 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net] Bluetooth: SMP: remove set but not used variable
 'smp'
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190923140516.166241-1-yuehaibing@huawei.com>
Date:   Thu, 26 Sep 2019 08:34:30 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1EA3AA11-946A-4C3C-9B87-1A6448B24627@holtmann.org>
References: <20190923140516.166241-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yue,

> On Sep 23, 2019, at 16:05, YueHaibing <yuehaibing@huawei.com> wrote:
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/bluetooth/smp.c: In function 'smp_irk_matches':
> net/bluetooth/smp.c:505:18: warning:
> variable 'smp' set but not used [-Wunused-but-set-variable]
> 
> net/bluetooth/smp.c: In function 'smp_generate_rpa':
> net/bluetooth/smp.c:526:18: warning:
> variable 'smp' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit 28a220aac596 ("bluetooth: switch
> to AES library")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> net/bluetooth/smp.c | 6 ------
> 1 file changed, 6 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

