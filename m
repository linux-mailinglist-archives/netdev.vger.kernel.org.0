Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98D130A51
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgAEWtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:49:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:49:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24C9C1557294B;
        Sun,  5 Jan 2020 14:49:08 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:49:07 -0800 (PST)
Message-Id: <20200105.144907.691410670118475613.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     linux-kernel@vger.kernel.org, bh74.an@samsung.com,
        ks.giri@samsung.com, vipul.pandya@samsung.com, andrew@lunn.ch,
        kstewart@linuxfoundation.org, info@metux.net,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 18/19] net: ethernet: sxgbe: Rename Samsung to lowercase
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103171131.9900-19-krzk@kernel.org>
References: <20200103171131.9900-1-krzk@kernel.org>
        <20200103171131.9900-19-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:49:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Fri,  3 Jan 2020 18:11:30 +0100

> Fix up inconsistent usage of upper and lowercase letters in "Samsung"
> name.
> 
> "SAMSUNG" is not an abbreviation but a regular trademarked name.
> Therefore it should be written with lowercase letters starting with
> capital letter.
> 
> Although advertisement materials usually use uppercase "SAMSUNG", the
> lowercase version is used in all legal aspects (e.g. on Wikipedia and in
> privacy/legal statements on
> https://www.samsung.com/semiconductor/privacy-global/).
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied, thanks.
