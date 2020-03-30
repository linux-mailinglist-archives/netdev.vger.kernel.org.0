Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4063F1987ED
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgC3XRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgC3XRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:17:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9050020409;
        Mon, 30 Mar 2020 23:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585610271;
        bh=3rGjnSEI/BL9tSBYS53yu3mrOB2S9RYHWd9d+9ncCP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vJogFg4DJjWMu/Dmq+eIpWndtXlrUB4tED/2B7zrN/En9wxHNOEFLhp4d6mxGk9oT
         tJ+pnR3ZqnJk34Ib32Xmrl2Xi88eS9FX2Ej3I0owDar1mpyZexT5uOuXM19VjlEhGy
         pwAhu/VxYblLREFZZvud2TqKL4/VmSTFv+weirQk=
Date:   Mon, 30 Mar 2020 16:17:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 03/15] netdevsim: Add devlink-trap policer
 support
Message-ID: <20200330161749.72ff0309@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330193832.2359876-4-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
        <20200330193832.2359876-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 22:38:20 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Register three dummy packet trap policers with devlink and implement
> callbacks to change their parameters and read their counters.
> 
> This will be used later on in the series to test the devlink-trap
> policer infrastructure.
> 
> v2:
> * Remove check about burst size being a power of 2 and instead add a
>   debugfs knob to fail the operation
> * Provide max/min rate/burst size when registering policers and remove
>   the validity checks from nsim_dev_devlink_trap_policer_set()
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
