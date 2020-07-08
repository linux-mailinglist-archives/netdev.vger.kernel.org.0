Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE596218E05
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgGHROX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgGHROX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:14:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D1C061A0B;
        Wed,  8 Jul 2020 10:14:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B563F12747A2D;
        Wed,  8 Jul 2020 10:14:22 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:14:22 -0700 (PDT)
Message-Id: <20200708.101422.230283834226022863.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: loop: Print when registration is
 successful
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708044513.91534-1-f.fainelli@gmail.com>
References: <20200708044513.91534-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 10:14:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue,  7 Jul 2020 21:45:13 -0700

> We have a number of error conditions that can lead to the driver not
> probing successfully, move the print when we are sure
> dsa_register_switch() has suceeded. This avoids repeated prints in case
> of probe deferral for instance.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
