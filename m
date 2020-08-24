Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98889250BF7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgHXW5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXW5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:57:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B93C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 15:57:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 100001290D458;
        Mon, 24 Aug 2020 15:40:32 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:57:17 -0700 (PDT)
Message-Id: <20200824.155717.1039756430861840951.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Fix use-after-free of VNIC login
 response buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598035141-25974-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598035141-25974-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:40:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Fri, 21 Aug 2020 13:39:01 -0500

> The login response buffer is freed after it is received
> and parsed, but other functions in the driver still attempt
> to read it, such as when the device is opened, causing the
> Oops below. Store relevant information in the driver's
> private data structures and use those instead.
 ...
> Fixes: f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct")
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied, thanks.
