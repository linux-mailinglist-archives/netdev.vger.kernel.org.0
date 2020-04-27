Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE081BAD10
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgD0Spp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgD0Spo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:45:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB11C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:45:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5A8115D5868D;
        Mon, 27 Apr 2020 11:45:43 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:45:42 -0700 (PDT)
Message-Id: <20200427.114542.1743612410421645517.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:45:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 26 Apr 2020 16:24:37 -0400

> A collection of 5 miscellaneous bug fixes covering VF anti-spoof setup
> issues, devlink MSIX max value, AER, context memory allocation error
> path, and VLAN acceleration logic.
> 
> Please queue for -stable.  Thanks.

Applied and queued up for -stable, thanks.
