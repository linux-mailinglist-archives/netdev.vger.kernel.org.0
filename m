Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697626D44B
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391050AbfGRTAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:00:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfGRTAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:00:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5935C1527D7FB;
        Thu, 18 Jul 2019 12:00:39 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:00:38 -0700 (PDT)
Message-Id: <20190718.120038.732161301700227801.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-07-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87y30v1lub.fsf@kamboji.qca.qualcomm.com>
References: <87y30v1lub.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:00:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 18 Jul 2019 17:03:24 +0300

> here are first fixes which have accumulated during the merge window.
> This pull request is to net tree for 5.3. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
