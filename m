Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A00437C13
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbfFFSSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:18:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:18:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 355E314DE0C5C;
        Thu,  6 Jun 2019 11:18:43 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:18:42 -0700 (PDT)
Message-Id: <20190606.111842.846097372323091363.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] usb: hso: correct debug message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606125548.18315-1-oneukum@suse.com>
References: <20190606125548.18315-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:18:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Oliver, can you please start providing proper header postings with
your patch series that explains at a high level what the patch series
is doing, how it is doing it, and why it is doing it that way?

Also, you need to tag your Subject lines properly with what tree
you are targetting with these changes.  Either net or net-next.

Thank you.
