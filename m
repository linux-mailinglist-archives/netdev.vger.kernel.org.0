Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2531116B87B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgBYETl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:19:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgBYETl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:19:41 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64AAA24676;
        Tue, 25 Feb 2020 04:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582604380;
        bh=ZIgEktPVBYiTLormynCjLEM9hhPocp2HlaVE4XEYKZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l2H4vfmyk8UibDEX+2J3L/QaRmwyoM5qlQTT66IaslxKukLr4IH5qPyzbq71V2PEo
         TxaskgAPjPSiIdvNEba+AxNjE7+iASjHLAXVAa6VLzVDCTCkx1eDmqWRqyeBYeEffA
         0zUFpdQNFZJBTk7YV//LlPg5nD1/57EQoKttlgcM=
Date:   Mon, 24 Feb 2020 20:19:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 02/10] devlink: add trap metadata type for
 cookie
Message-ID: <20200224201939.231937ce@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-3-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:50 +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Allow driver to indicate cookie metadata for registered traps.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
