Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C16356233
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 05:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348424AbhDGDvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 23:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348470AbhDGDui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 23:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367006139E;
        Wed,  7 Apr 2021 03:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617767422;
        bh=+hV6StB2m1WzLoc3aZpUAwuN3oAopFY5hUem98F9tOU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pOTizx6PgwdxmN/qgW3gkF+2z8ALTpmVTL28KHbk+8VJaqtE0VoIWrXhUVXvDFUHn
         KlL+mdTPBTJ3v/eOO7sslhRQyU8bPzkeY5nrrs5yx52Up+IykF6ekcEsqxGUjFF9MT
         jiVl7/a9Qki6+Ui8X7t8VNEK+56Xw/p7eQHqax/FW7cnhDIHJCeg3lx5jVh1h+1gu0
         M30s54Vji76zWFiK/wFAkz7It7Lu2c393QXEkLm5e6z5pRBexamG1fdpfYeiFod95H
         sy8yuMEHIDGMcnlm5JsH8cDUPFCTuSJkw1n5Dm4WZIOp5GwxjS5ednD9rMf48r/LAq
         AW34aGj+InajQ==
Message-ID: <2dc3c870b5070ee6aa0f79394403ec3e342a45d2.camel@kernel.org>
Subject: Re: [PATCH net-next 0/3] net/mlx5: Fix some coding-style issues
From:   Saeed Mahameed <saeed@kernel.org>
To:     Weihang Li <liweihang@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, leon@kernel.org, linuxarm@huawei.com
Date:   Tue, 06 Apr 2021 20:50:21 -0700
In-Reply-To: <1617282463-47124-1-git-send-email-liweihang@huawei.com>
References: <1617282463-47124-1-git-send-email-liweihang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-01 at 21:07 +0800, Weihang Li wrote:
> Just make some cleanups according to the coding style of kernel.
> 
> Wenpeng Liang (3):
>   net/mlx5: Add a blank line after declarations.
>   net/mlx5: Remove return statement exist at the end of void function
>   net/mlx5: Replace spaces with tab at the start of a line
> 


Applied to net-next-mlx5, Thanks!

