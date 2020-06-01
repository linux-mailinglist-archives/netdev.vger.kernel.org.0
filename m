Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501511EAF78
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgFATKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgFATKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:10:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B940AC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:10:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1097B120477C4;
        Mon,  1 Jun 2020 12:10:14 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:10:13 -0700 (PDT)
Message-Id: <20200601.121013.1917184371162389839.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:10:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sun, 31 May 2020 05:36:05 -0700

> This series contains updates to the ice driver only.

Pulled, thanks Jeff.
