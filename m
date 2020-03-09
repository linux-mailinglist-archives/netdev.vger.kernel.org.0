Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE817D8AA
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgCIEzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:55:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIEzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:55:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E266158B6F10;
        Sun,  8 Mar 2020 21:55:02 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:55:01 -0700 (PDT)
Message-Id: <20200308.215501.1175218845479793622.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] bnxt_en: Updates.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:55:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun,  8 Mar 2020 18:45:46 -0400

> This series includes simplification and improvement of NAPI polling
> logic in bnxt_poll_p5().  The improvements will prevent starving the
> async events from firmware if we are in continuous NAPI polling.
> The rest of the patches include cleanups, a better return code for
> firmware busy, and to clear devlink port type more properly.

Series applied, thanks Michael.
