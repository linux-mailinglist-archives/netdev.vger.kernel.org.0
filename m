Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E6A15275C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgBEIIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:08:17 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44606 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBEIIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 03:08:16 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1DC94CECC5;
        Wed,  5 Feb 2020 09:17:37 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2] net/bluetooth: remove __get_channel/dir and __dir
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1e76a7b8-c90a-56fe-96d7-4088dc7f6c38@linux.alibaba.com>
Date:   Wed, 5 Feb 2020 09:08:15 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <140CEF7E-7BE9-4EC0-8625-292D95C45E7B@holtmann.org>
References: <1579596583-258090-1-git-send-email-alex.shi@linux.alibaba.com>
 <8CA3EF63-F688-48B2-A21D-16FDBC809EDE@holtmann.org>
 <09359312-a1c8-c560-85ba-0f94be521b26@linux.alibaba.com>
 <2287CD53-58F4-40FD-B2F3-81A9F22F4731@holtmann.org>
 <1e76a7b8-c90a-56fe-96d7-4088dc7f6c38@linux.alibaba.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> These 3 macros are never used from first git commit Linux-2.6.12-rc2.
> let's remove them.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> net/bluetooth/rfcomm/core.c | 3 ---
> 1 file changed, 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

