Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6812A66D
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfLYGiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:38:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYGiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:38:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48793154D8950;
        Tue, 24 Dec 2019 22:38:02 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:38:01 -0800 (PST)
Message-Id: <20191224.223801.1418400073780159879.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/9] Simplify IPv6 route offload API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223132820.888247-1-idosch@idosch.org>
References: <20191223132820.888247-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:38:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 23 Dec 2019 15:28:11 +0200

> This is the IPv6 counterpart of "Simplify IPv4 route offload API" [1].
 ...

Series applied, thanks Ido.
