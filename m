Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D6F151907
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgBDKzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:55:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgBDKzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:55:18 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7233C12DE6612;
        Tue,  4 Feb 2020 02:55:17 -0800 (PST)
Date:   Tue, 04 Feb 2020 11:55:16 +0100 (CET)
Message-Id: <20200204.115516.1053407271785679261.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: Re: [stable] bnxt_en: Move devlink_register before registering
 netdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CACKFLi=8uYrOx9GM412hArXzFHZW7WpD3P4F_hT5S0bgf_YTjA@mail.gmail.com>
References: <CACKFLi=8uYrOx9GM412hArXzFHZW7WpD3P4F_hT5S0bgf_YTjA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 02:55:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 2 Feb 2020 23:42:00 -0800

> David, I'd like to request this patch for 5.4 and 5.5 stable kernels.
> Without this patch, the phys_port_name may not be registered in time
> for the netdev and some users report seeing inconsistent naming of the
> device.  Thanks.

Queued up, thanks Michael.
