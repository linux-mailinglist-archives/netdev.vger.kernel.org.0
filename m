Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0835CE3D8
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfJGNhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:37:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGNhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:37:52 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43E7A140C3681;
        Mon,  7 Oct 2019 06:37:50 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:37:49 +0200 (CEST)
Message-Id: <20191007.153749.301390733439111734.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: change return type of
 pskb_may_pull to bool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8c993693-cbef-e401-bfc3-c2a915621c51@gmail.com>
References: <8c993693-cbef-e401-bfc3-c2a915621c51@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:37:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 6 Oct 2019 18:19:54 +0200

> This function de-facto returns a bool, so let's change the return type
> accordingly.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
