Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9217CC5B
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 06:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgCGFz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 00:55:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCGFz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 00:55:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B05A8154A86D9;
        Fri,  6 Mar 2020 21:55:55 -0800 (PST)
Date:   Fri, 06 Mar 2020 21:55:55 -0800 (PST)
Message-Id: <20200306.215555.785167440232291311.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/4] QorIQ DPAA FMan erratum A050385 workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 21:55:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Wed,  4 Mar 2020 18:04:24 +0200

 ...
> The patch set implements the workaround for FMan erratum A050385:
 ...

Series applied, thanks.
