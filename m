Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1520117D8B3
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIFD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:03:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIFD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:03:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97C8B158B8420;
        Sun,  8 Mar 2020 22:03:26 -0700 (PDT)
Date:   Sun, 08 Mar 2020 22:03:25 -0700 (PDT)
Message-Id: <20200308.220325.898499304583783075.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH net-next v3 0/3] QorIQ DPAA: Use random MAC address
 when none is given
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 22:03:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Thu,  5 Mar 2020 19:08:55 +0200

> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Use random MAC addresses when they are not provided in the device tree.
> Tested on LS1046ARDB.
> 
> Changes in v3:
>  addressed all MAC types, removed some redundant code in dtsec in
>  the process

Series applied, thanks.
