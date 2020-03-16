Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF01867F9
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgCPJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:36:11 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:60191 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730399AbgCPJgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:36:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584351370; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7L7UKuTAuhuXkRBCotHyOMnhRFW+uaNbOdyf2oYjzlM=;
 b=mKhYpJCWtGiwVzipvlSCOfY4cDWosL+6fVL5iPYhgpibn4oayGdstocP8DjfAytva8RqpwlF
 /bPGGGYmQAOCxKtFfFksleQ/SeCPQlhmPnpX+nlbi/ey90Jy82rDwjVroSOyYTg0w3/opG2d
 iYeyjM2wBlktnQ7n8XhP3j6KUfU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6f4874.7f631d71c6f8-smtp-out-n01;
 Mon, 16 Mar 2020 09:35:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0197BC43637; Mon, 16 Mar 2020 09:35:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: xiaofeis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61C07C433CB;
        Mon, 16 Mar 2020 09:35:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 16 Mar 2020 17:35:47 +0800
From:   xiaofeis@codeaurora.org
To:     David Miller <davem@davemloft.net>
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH] net: dsa: input correct header length for skb_cow_head()
In-Reply-To: <20200316.020709.946201122435780659.davem@davemloft.net>
References: <1584320645-25041-1-git-send-email-xiaofeis@codeaurora.org>
 <20200316.020709.946201122435780659.davem@davemloft.net>
Message-ID: <13f503762fc8805f031c449127113407@codeaurora.org>
X-Sender: xiaofeis@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2020-03-16 17:07，David Miller 写道：
> From: xiaofeis <xiaofeis@codeaurora.org>
> Date: Mon, 16 Mar 2020 09:04:05 +0800
> 
>> We need to ensure there is enough headroom to push QCA header,
>> so input the QCA header length instead of 0.
>> 
>> Signed-off-by: xiaofeis <xiaofeis@codeaurora.org>
> 
> This was already fixed by:
> 
> commit 04fb91243a853dbde216d829c79d9632e52aa8d9
> Author: Per Forlin <per.forlin@axis.com>
> Date:   Thu Feb 13 15:37:09 2020 +0100
> 
>     net: dsa: tag_qca: Make sure there is headroom for tag
Ok, got it.
