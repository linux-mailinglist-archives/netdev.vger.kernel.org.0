Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9731C0B73
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgEABDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgEABDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:03:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E90C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:03:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 197AC1274E61F;
        Thu, 30 Apr 2020 18:03:32 -0700 (PDT)
Date:   Thu, 30 Apr 2020 18:03:30 -0700 (PDT)
Message-Id: <20200430.180330.1316233991817889188.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 0/3] ionic: fw upgrade bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430213343.44124-1-snelson@pensando.io>
References: <20200430213343.44124-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 18:03:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 30 Apr 2020 14:33:40 -0700

> These patches address issues found in additional internal
> fw-upgrade testing.
> 
> Shannon Nelson (3):
>   ionic: no link check until after probe
>   ionic: refresh devinfo after fw-upgrade
>   ionic: add device reset to fw upgrade down
> 
> v2:
>  - replaced extra state flag with postponing first link check
>  - added device reset patch

Series applied, thank you.
