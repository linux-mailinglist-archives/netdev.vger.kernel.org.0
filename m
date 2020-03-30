Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADEC1973AB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgC3FJO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Mar 2020 01:09:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33262 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgC3FJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:09:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2775715C60D24;
        Sun, 29 Mar 2020 22:09:13 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:09:12 -0700 (PDT)
Message-Id: <20200329.220912.1139584750455036593.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        landen.chao@mediatek.com, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next] net: dsa: mt7530: use resolved link config in
 mac_link_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327144412.100913-1-opensource@vdorst.com>
References: <20200327144412.100913-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:09:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Fri, 27 Mar 2020 15:44:12 +0100

> Convert the mt7530 switch driver to use the finalised link
> parameters in mac_link_up() rather than the parameters in mac_config().
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>

Applied.
