Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91414168
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfEERV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:21:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfEERV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:21:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E00EF14DA0307;
        Sun,  5 May 2019 10:21:54 -0700 (PDT)
Date:   Sun, 05 May 2019 10:21:54 -0700 (PDT)
Message-Id: <20190505.102154.2079817625143467430.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-05-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87bm0jk9tv.fsf@kamboji.qca.qualcomm.com>
References: <87bm0jk9tv.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:21:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 03 May 2019 15:21:16 +0300

> here's a pull request to net-next for 5.2, more information below. Also
> there's a conflict in iwlwifi again and this time I added the conflict
> resolution to the signed tag based on our discussion earlier this week.
> Please let me know what you think or there are any problems.

Pulled, looks great, thanks Kalle.
