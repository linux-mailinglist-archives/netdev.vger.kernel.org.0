Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7909F476D3
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfFPUsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:48:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFPUsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 16:48:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB2EB151C285C;
        Sun, 16 Jun 2019 13:48:49 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:48:49 -0700 (PDT)
Message-Id: <20190616.134849.518666907088993244.davem@davemloft.net>
To:     ivecera@redhat.com
Cc:     netdev@vger.kernel.org, tizhao@redhat.com,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] be2net: Fix number of Rx queues used for flow
 hashing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614154836.22172-1-ivecera@redhat.com>
References: <20190614154836.22172-1-ivecera@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 13:48:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Fri, 14 Jun 2019 17:48:36 +0200

> Number of Rx queues used for flow hashing returned by the driver is
> incorrect and this bug prevents user to use the last Rx queue in
> indirection table.
 ...
> Fixes: 594ad54a2c3b ("be2net: Add support for setting and getting rx flow hash options")
> Reported-by: Tianhao <tizhao@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Applied and queued up for -stable, thanks.
