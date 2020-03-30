Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD38A1983C0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgC3Sw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:52:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41330 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3Sw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:52:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12FB915C72E09;
        Mon, 30 Mar 2020 11:52:56 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:52:55 -0700 (PDT)
Message-Id: <20200330.115255.139938981581332254.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] split phylink PCS operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330174330.GH25745@shell.armlinux.org.uk>
References: <20200330174330.GH25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:52:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mon, 30 Mar 2020 18:43:30 +0100

> This series splits the phylink_mac_ops structure so that PCS can be
> supported separately with their own PCS operations, separating them
> from the MAC layer.  This may need adaption later as more users come
> along.
> 
> v2: change pcs_config() and associated called function prototypes to
> only pass the information that is required, and add some documention.
> 
> v3: change phylink_create() prototype

Series applied, thanks.
