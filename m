Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEE913CF61
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgAOVpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:45:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgAOVpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:45:05 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22C9E15A0E661;
        Wed, 15 Jan 2020 13:45:03 -0800 (PST)
Date:   Wed, 15 Jan 2020 13:45:02 -0800 (PST)
Message-Id: <20200115.134502.1655641866201079006.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/1] pull request for net: batman-adv 2020-01-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114141646.23598-1-sw@simonwunderlich.de>
References: <20200114141646.23598-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 13:45:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 14 Jan 2020 15:16:45 +0100

> here is a bugfix which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
