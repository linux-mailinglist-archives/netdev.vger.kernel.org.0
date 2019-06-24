Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD18C50F20
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfFXOvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:51:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfFXOvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:51:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E917815042E85;
        Mon, 24 Jun 2019 07:51:32 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:51:32 -0700 (PDT)
Message-Id: <20190624.075132.2137301224911651949.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH v2 net-next 0/4] cxgb4: Reference count MPS TCAM
 entries within a PF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624085037.2358-1-rajur@chelsio.com>
References: <20190624085037.2358-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:51:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Mon, 24 Jun 2019 14:20:33 +0530

> Firmware reference counts the MPS TCAM entries by PF and VF,
> but it does not do it for usage within a PF or VF. This patch
> adds the support to track MPS TCAM entries within a PF.
> 
> v1->v2:
>  Use refcount_t type instead of atomic_t for mps reference count

Series applied, thanks.
