Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0591939946B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFBUTr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Jun 2021 16:19:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42666 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBUTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:19:46 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 69834CED0B;
        Wed,  2 Jun 2021 22:25:59 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2 00/12] net/Bluetooth: correct the use of print format
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
Date:   Wed, 2 Jun 2021 22:18:01 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <29FB1C65-7FA6-4110-B953-5281C0587CAF@holtmann.org>
References: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
To:     Kai Ye <yekai13@huawei.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

> According to Documentation/core-api/printk-formats.rst,
> Use the correct print format. 
> 1. Printing an unsigned int value should use %u instead of %d.
> 2. Printing an unsigned long value should use %lu instead of %ld.
> Otherwise printk() might end up displaying negative numbers.
> 
> changes v1 -> v2:
> 	fix some style problems
> 
> Kai Ye (12):
>  net/Bluetooth/bnep - use the correct print format
>  net/Bluetooth/cmtp - use the correct print format
>  net/Bluetooth/hidp - use the correct print format
>  net/Bluetooth/rfcomm - use the correct print format
>  net/Bluetooth/6lowpan - use the correct print format
>  net/Bluetooth/a2mp - use the correct print format
>  net/Bluetooth/amp - use the correct print format
>  net/Bluetooth/hci - use the correct print format
>  net/Bluetooth/mgmt - use the correct print format
>  net/Bluetooth/msft - use the correct print format
>  net/Bluetooth/sco - use the correct print format
>  net/Bluetooth/smp - use the correct print format

please fix the commit message to apply with expected style. Fixing up 12 patches manually is not something I am going to do.

Regards

Marcel

