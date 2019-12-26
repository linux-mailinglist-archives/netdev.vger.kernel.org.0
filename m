Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C87712AEC1
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfLZVNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:13:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:13:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D3E6151114F8;
        Thu, 26 Dec 2019 13:13:40 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:13:39 -0800 (PST)
Message-Id: <20191226.131339.190470274423784289.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] mlxsw: spectrum_router: Cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226164117.53794-1-idosch@idosch.org>
References: <20191226164117.53794-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:13:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 26 Dec 2019 18:41:12 +0200

> This patch set removes from mlxsw code that is no longer necessary after
> the simplification of the IPv4 and IPv6 route offload API.
> 
> The patches eliminate unnecessary code by taking advantage of the fact
> that mlxsw no longer needs to maintain a list of identical routes,
> following recent changes in route offload API.

Series applied, thank you.
