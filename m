Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9A919A9
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfHRVOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:14:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:14:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA148145D4409;
        Sun, 18 Aug 2019 14:14:44 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:14:44 -0700 (PDT)
Message-Id: <20190818.141444.666954468430145928.davem@davemloft.net>
To:     ivecera@redhat.com
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        poros@redhat.com, sriharsha.basavapatna@broadcom.com
Subject: Re: [PATCH] be2net: eliminate enable field from be_aic_obj
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816071535.28349-1-ivecera@redhat.com>
References: <20190816071535.28349-1-ivecera@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:14:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Fri, 16 Aug 2019 09:15:35 +0200

> Adaptive coalescing is managed per adapter not per event queue so it
> does not needed to store 'enable' flag for each event queue.
> 
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Applied to net-next.

 
