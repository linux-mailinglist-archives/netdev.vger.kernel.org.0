Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D999196F
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 22:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfHRUG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 16:06:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfHRUG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 16:06:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 933EB144B2EFD;
        Sun, 18 Aug 2019 13:06:25 -0700 (PDT)
Date:   Sun, 18 Aug 2019 13:06:25 -0700 (PDT)
Message-Id: <20190818.130625.197392907101409922.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/6] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 13:06:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri, 16 Aug 2019 18:33:31 -0400

> 2 Bug fixes related to 57500 shutdown sequence and doorbell sequence,
> 2 TC Flower bug fixes related to the setting of the flow direction,
> 1 NVRAM update bug fix, and a minor fix to suppress an unnecessary
> error message.  Please queue for -stable as well.  Thanks.

Series applied and queued up for -stable, thanks.
