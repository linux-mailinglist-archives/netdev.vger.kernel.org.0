Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3F77BF2
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfG0VAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:00:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388035AbfG0VAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:00:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F088B126514AE;
        Sat, 27 Jul 2019 14:00:29 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:00:29 -0700 (PDT)
Message-Id: <20190727.140029.1705855810720310694.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next v2 1/2] qed: Add API for configuring NVM
 attributes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726155215.25151-2-skalluru@marvell.com>
References: <20190726155215.25151-1-skalluru@marvell.com>
        <20190726155215.25151-2-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:00:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Fri, 26 Jul 2019 08:52:14 -0700

> +int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
> +			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
> +			u32 len)
> +{
> +	u32 mb_param = 0, resp, param;
> +	int rc;
 ...
> +	rc = qed_mcp_nvm_wr_cmd(p_hwfn, p_ptt,
> +				DRV_MSG_CODE_SET_NVM_CFG_OPTION,
> +				mb_param, &resp, &param, len, (u32 *)p_buf);
> +
> +	return rc;

'rc' is completely unnecessary, please just return the function result
directly.

Thank you.
