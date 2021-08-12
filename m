Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA73E9DED
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhHLFaE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Aug 2021 01:30:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34894 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhHLF3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:29:53 -0400
Received: from smtpclient.apple (tmo-100-163.customers.d1-online.com [80.187.100.163])
        by mail.holtmann.org (Postfix) with ESMTPSA id 059AECECDD;
        Thu, 12 Aug 2021 07:29:22 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] Bluetooth: msft: add a bluetooth parameter, msft_enable
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210812042305.277642-1-koba.ko@canonical.com>
Date:   Thu, 12 Aug 2021 07:29:21 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Archie Pusaka <apusaka@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4374EE78-86B9-43BF-B387-8C51C15CB943@holtmann.org>
References: <20210812042305.277642-1-koba.ko@canonical.com>
To:     Koba Ko <koba.ko@canonical.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Koba,

> With Intel AC9560, follow this scenario and can't turn on bt since.
> 1. turn off BT
> 2. then suspend&resume multiple times
> 3. turn on BT
> 
> Get this error message after turn on bt.
> [ 877.194032] Bluetooth: hci0: urb 0000000061b9a002 failed to resubmit (113)
> [ 886.941327] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> 
> Remove msft from compilation would be helpful.
> Turn off msft would be also helpful.
> 
> Because msft is enabled as default and can't turn off without
> compliation,
> Introduce a bluetooth parameter, msft_enable, to control.
> 
> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> ---
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         | 16 ++++++++++++++++
> net/bluetooth/msft.c             | 30 +++++++++++++++++++++++++++++-
> 3 files changed, 46 insertions(+), 1 deletion(-)

NAK.

This is for the Intel guys to figure out. Otherwise I am going to disable MSFT extension for AC9560 completely. What is your hw_variant for that hardware?

Regards

Marcel

