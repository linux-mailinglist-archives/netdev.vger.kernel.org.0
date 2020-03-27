Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46952196157
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgC0Wle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:41:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgC0Wle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:41:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CE0A15BB6505;
        Fri, 27 Mar 2020 15:41:34 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:41:33 -0700 (PDT)
Message-Id: <20200327.154133.281200586896043805.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-03-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327110416.4F051C44791@smtp.codeaurora.org>
References: <20200327110416.4F051C44791@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:41:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 27 Mar 2020 11:04:16 +0000 (UTC)

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Pulled, thanks for the merge conflict resolution guidance.
