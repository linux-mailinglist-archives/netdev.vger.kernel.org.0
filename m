Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D96E7A9F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfJ1U6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:58:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfJ1U6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:58:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C379714B7B5ED;
        Mon, 28 Oct 2019 13:58:39 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:58:39 -0700 (PDT)
Message-Id: <20191028.135839.1017804880218725836.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/2] net: dsa: b53: Add support for MDB
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024194508.32603-1-f.fainelli@gmail.com>
References: <20191024194508.32603-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:58:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 24 Oct 2019 12:45:06 -0700

> This patch series adds support for programming multicast database
> entries on b53 and bcm_sf2. This is extracted from a previously
> submitted series that added managed mode support, but these patches are
> usable in isolation. The larger series still needs to be reworked.

Series applied, thanks Florian.
