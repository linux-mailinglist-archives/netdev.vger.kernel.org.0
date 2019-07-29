Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DD7792C1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfG2SDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:03:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfG2SDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:03:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15985140505C4;
        Mon, 29 Jul 2019 11:03:43 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:03:42 -0700 (PDT)
Message-Id: <20190729.110342.703558396264560468.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next v3 2/2] qed: Add driver API for flashing the
 config attributes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190728015549.27051-3-skalluru@marvell.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
        <20190728015549.27051-3-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 11:03:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Sat, 27 Jul 2019 18:55:49 -0700

> @@ -2268,6 +2330,9 @@ static int qed_nvm_flash(struct qed_dev *cdev, const char *name)
>  			rc = qed_nvm_flash_image_access(cdev, &data,
>  							&check_resp);
>  			break;
> +		case QED_NVM_FLASH_CMD_NVM_CFG_ID:
> +			rc = qed_nvm_flash_cfg_write(cdev, &data);
> +			break;
>  		default:
>  			DP_ERR(cdev, "Unknown command %08x\n", cmd_type);

I don't see how any existing portable interface can cause this new code to
actually be used.

You have to explain this to me.
