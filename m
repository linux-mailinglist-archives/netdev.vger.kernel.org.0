Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B7433A82F
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 22:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhCNV1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 17:27:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53298 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhCNV1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 17:27:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4E9B74CBDE068;
        Sun, 14 Mar 2021 14:27:05 -0700 (PDT)
Date:   Sun, 14 Mar 2021 14:27:01 -0700 (PDT)
Message-Id: <20210314.142701.2294646546411779456.davem@davemloft.net>
To:     robert.hancock@calian.com
Cc:     radhey.shyam.pandey@xilinx.com, kuba@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] axienet clock additions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210311201117.3802311-1-robert.hancock@calian.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 14 Mar 2021 14:27:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 11 Mar 2021 14:11:15 -0600

> Add support to the axienet driver for controlling all of the clocks that
> the logic core may utilize.

This series does not apply to net-next, please respin.

Thanks.
