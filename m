Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADB13B7FF
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOCyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:54:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbgAOCyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:54:24 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C644158099B7;
        Tue, 14 Jan 2020 18:54:12 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:54:05 -0800 (PST)
Message-Id: <20200114.185405.1408021207482379934.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/10] net: Add route offload indication
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:54:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 14 Jan 2020 13:23:08 +0200

> This patch set adds offload indication to IPv4 and IPv6 routes.
 ....

Series applied, thanks Ido.

