Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBA77317
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfGZVAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:00:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfGZVAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:00:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75DB7126514B9;
        Fri, 26 Jul 2019 14:00:17 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:00:16 -0700 (PDT)
Message-Id: <20190726.140016.1677143432942080493.davem@davemloft.net>
To:     angus@akkea.ca
Cc:     kernel@puri.sm, bjorn@mork.no, johan@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        bob.ham@puri.sm
Subject: Re: [PATCH 2/2] net: usb: qmi_wwan: Add the BroadMobi BM818 card
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724145227.27169-3-angus@akkea.ca>
References: <20190724145227.27169-1-angus@akkea.ca>
        <20190724145227.27169-3-angus@akkea.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:00:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Angus Ainslie (Purism)" <angus@akkea.ca>
Date: Wed, 24 Jul 2019 07:52:27 -0700

> From: Bob Ham <bob.ham@puri.sm>
> 
> The BroadMobi BM818 M.2 card uses the QMI protocol
> 
> Signed-off-by: Bob Ham <bob.ham@puri.sm>
> Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>

Applied, thanks.
