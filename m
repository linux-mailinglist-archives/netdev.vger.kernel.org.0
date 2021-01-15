Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21F42F705C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbhAOCJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbhAOCJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 21:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2734323A5A;
        Fri, 15 Jan 2021 02:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610676518;
        bh=rcRq46pn+nUjx1vJmbG3T+X9yuIw9cT5nQhnpMECJso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jSUmp7BkecOVTitvKj9w9PfHSw38fOBX2jsykoaN/KtR5Pepvfj2oiqINRhd0t8Sz
         9InCXgKHjBZmYa+nrAEGxCpf34Vf34oclUH8bKF3K5THhGf1qx9J5GaxECzsttsVr2
         E9T/zoGHQPvjmvNRHsliSZaUS2v6D5324QllGjG4Hx8Coz0jNEBMqJnc5o7rgWmaif
         l0kwLbJCWR/H8NCOY5pWQooqYc5Q6P+xLApMnnyVCXiMHm6YLbL2cGftmAxSyucXk8
         ZyyBLqo+a5unAIVDHaT30gKVV9zypPpdL0nwaRFixFPI73UPtxLML+nZ8eh62hcp34
         A73zz0csMHwxQ==
Date:   Thu, 14 Jan 2021 18:08:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>, Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
Message-ID: <20210114180837.793879ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
References: <20210113171532.19248-1-elder@linaro.org>
        <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 15:22:54 -0800 Saeed Mahameed wrote:
> On Wed, 2021-01-13 at 11:15 -0600, Alex Elder wrote:
> > This series implements some updates for the GSI interrupt code,
> > buliding on some bug fixes implemented last month.
> > 
> > The first two are simple changes made to improve readability and
> > consistency.  The third replaces all msleep() calls with comparable
> > usleep_range() calls.
> > 
> > The remainder make some more substantive changes to make the code
> > align with recommendations from Qualcomm.  The fourth implements a
> > much shorter timeout for completion GSI commands, and the fifth
> > implements a longer delay between retries of the STOP channel
> > command.  Finally, the last implements retries for stopping TX
> > channels (in addition to RX channels).
>
> A minor thing that bothers me about this series is that it looks like
> it is based on magic numbers and some redefined constant values
> according to some mysterious sources ;-) .. It would be nice to have
> some wording in the commit messages explaining reasoning and maybe
> "semi-official" sources behind the changes.
> 
> LGMT code style wise :) 
> 
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Dropped the fixes tags (since its not a series of fixes) and applied.

Thanks!
