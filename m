Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D0792AF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfG2R4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:56:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfG2R4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:56:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB7AE1401D383;
        Mon, 29 Jul 2019 10:56:23 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:56:23 -0700 (PDT)
Message-Id: <20190729.105623.1884187062066808743.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_ptp: Increase parsing depth when
 PTP is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727173532.7231-1-idosch@idosch.org>
References: <20190727173532.7231-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:56:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sat, 27 Jul 2019 20:35:32 +0300

> @@ -979,19 +979,36 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_port *mlxsw_sp_port,
>  {
>  	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
>  	struct mlxsw_sp_port *tmp;
> +	u16 orig_ing_types = 0;
> +	u16 orig_egr_types = 0;
>  	int i;
> +	int err;

Please preserve the reverse christmas tree here, thank you.
