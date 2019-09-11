Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2FBAF78C
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfIKIRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:17:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfIKIRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:17:36 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 660301556733A;
        Wed, 11 Sep 2019 01:17:34 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:17:32 +0200 (CEST)
Message-Id: <20190911.101732.1453519960272118746.davem@davemloft.net>
To:     poeschel@lemonage.de
Cc:     gregkh@linuxfoundation.org, tglx@linutronix.de,
        kstewart@linuxfoundation.org, swinslow@gmail.com,
        allison@lohutok.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, johan@kernel.org,
        Claudiu.Beznea@microchip.com
Subject: Re: [PATCH v7 5/7] nfc: pn533: add UART phy driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910093359.2110-1-poeschel@lemonage.de>
References: <20190910093359.2110-1-poeschel@lemonage.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:17:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>
Date: Tue, 10 Sep 2019 11:33:50 +0200

> +static int pn532_uart_send_ack(struct pn533 *dev, gfp_t flags)
> +{
> +	struct pn532_uart_phy *pn532 = dev->phy;
> +	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
> +	static const u8 ack[PN533_STD_FRAME_ACK_SIZE] = {
> +			0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
> +	int err;

Reverse christmas tree ordering for the local variables please.

> +static int pn532_uart_rx_is_frame(struct sk_buff *skb)
> +{
> +	int i;
> +	u16 frame_len;
> +	struct pn533_std_frame *std;
> +	struct pn533_ext_frame *ext;

Likewise.
