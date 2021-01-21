Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123E32FE1BB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbhAUFbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbhAUFaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68FB23888;
        Thu, 21 Jan 2021 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611207012;
        bh=DrPQcdcy95tcB6v5oyx4vFnmU3C2q+sPX5y+ajrWW80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cQ4UNY0fJc6LwaynyNjmsuVg79kNf+JZfdNrxACXK4BqR8qe9LgVdH68DToK1Q8AL
         44cN9TbKPbtzcAbyK5TpO15AQsFVcyYAGbfT3qeT/bbRuzaq3JqnrTGW74Wdttwpfb
         +sHfvOcHJf4dqY5eMmbhtASQIi5KQ9DBY8lKagUVoGY6DUIzAlSrWnmyuZFRhESRyI
         j3NQycmmXCUr5Pf9ESJiqcH/FQc63hOsPbyhKX8ygxOIodE2C/EebUo7nCZiAMvYde
         sKg73YUVmmJpZ4VodCixvtFshgOkfoc5B1UplcSeQs2aH2NLLSHXNx+0Kb5rH0ED5o
         W9AhXXKxE8d0w==
Date:   Wed, 20 Jan 2021 21:30:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mhi: Set wwan device type
Message-ID: <20210120213010.4173718c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611150821-15698-1-git-send-email-loic.poulain@linaro.org>
References: <1611150821-15698-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 14:53:41 +0100 Loic Poulain wrote:
> The 'wwan' devtype is meant for devices that require additional
> configuration to be used, like WWAN specific APN setup over AT/QMI
> commands, rmnet link creation, etc. This is the case for MHI (Modem
> host Interface) netdev which targets modem/WWAN endpoints.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Patchwork says this does not apply to net-next.
