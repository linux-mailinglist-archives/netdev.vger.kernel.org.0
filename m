Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3616EF5A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbgBYTpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:45:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgBYTpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:45:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D98F13C43B30;
        Tue, 25 Feb 2020 11:45:46 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:45:44 -0800 (PST)
Message-Id: <20200225.114544.1730081330061687105.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        kernel-team@fb.com, kuba@kernel.org
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
        <20200224.153254.1115312677901381309.davem@davemloft.net>
        <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 11:45:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jonathan Lemon" <jonathan.lemon@gmail.com>
Date: Tue, 25 Feb 2020 08:16:35 -0800

> There should be a single posting on the list, are you telling me
> otherwise?

There were three postings:

https://patchwork.ozlabs.org/patch/1243698/
https://patchwork.ozlabs.org/patch/1243701/
https://patchwork.ozlabs.org/patch/1243702/
