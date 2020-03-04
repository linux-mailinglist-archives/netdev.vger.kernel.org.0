Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1D179A61
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgCDUra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:47:30 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:31802 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728539AbgCDUra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:47:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583354850; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GmllqlvU42cNoTyZPOXdp/yXFftS5cRjA+OkQHPvzXo=;
 b=Bn5xJui+Nj8dUEuPGhJfTU0BWT7jqRQGIlQzJ/rvkTM9kbO40uEJv84v0STGbLRqw0XWl7XT
 KuwAK3660jEPeoKkqjSooKeG9SrEomL9IG57NBgSjfoZ+0X4lm09uvEJcufKsNjrpueoVndO
 2Hy5SIx2giE0ifK5FY0bUH0oq2Q=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6013d9.7f983555b998-smtp-out-n01;
 Wed, 04 Mar 2020 20:47:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19AC3C4479F; Wed,  4 Mar 2020 20:47:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9567DC4479C;
        Wed,  4 Mar 2020 20:47:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Mar 2020 13:47:19 -0700
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: rmnet: print error message when command
 fails
In-Reply-To: <20200304075102.23430-1-ap420073@gmail.com>
References: <20200304075102.23430-1-ap420073@gmail.com>
Message-ID: <fe5c0e55af0e80ae11e93ef6be0fb3bf@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (rmnet_is_real_dev_registered(slave_dev)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "dev is already attached another rmnet dev");
> 
Hi Taehee

Can you make this change as well-
"slave cannot be another rmnet dev"


