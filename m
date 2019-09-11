Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3FBAF792
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfIKISD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:18:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKISD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:18:03 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEAB115567343;
        Wed, 11 Sep 2019 01:18:00 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:17:59 +0200 (CEST)
Message-Id: <20190911.101759.1557703938346599792.davem@davemloft.net>
To:     poeschel@lemonage.de
Cc:     allison@lohutok.net, keescook@chromium.org, opensource@jilayne.com,
        swinslow@gmail.com, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, tglx@linutronix.de,
        kstewart@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v7 6/7] nfc: pn533: Add autopoll capability
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910093415.2186-1-poeschel@lemonage.de>
References: <20190910093415.2186-1-poeschel@lemonage.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:18:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>
Date: Tue, 10 Sep 2019 11:34:12 +0200

> +static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
> +			       struct sk_buff *resp)
> +{
> +	u8 nbtg;
> +	int rc;
> +	struct pn532_autopoll_resp *apr;
> +	struct nfc_target nfc_tgt;

Need reverse christmas tree here.

> @@ -1534,6 +1655,7 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
>  	struct pn533_poll_modulations *cur_mod;
>  	u8 rand_mod;
>  	int rc;
> +	struct sk_buff *skb;

Likewise.
