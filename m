Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1849E4A5C32
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiBAM04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:26:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58182 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBAM0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:26:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1A6614D6;
        Tue,  1 Feb 2022 12:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93578C340EB;
        Tue,  1 Feb 2022 12:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643718403;
        bh=ZCMtkNJow1Q7THiTZDQP6MEpXtw8VBWLQ9QxgGvOuMA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OyXpJ/mUtb8a5xMWBJPDMEuGFSJ3PK7u5K2fvb5uoVjQlsoA18rIuf4ttkZ9mW2dS
         nhpxMyYaigmwLht0+uS+VvrrPT+AehvREiV85EkW/c2PH6ExtElpHcLfe/+knIuFG1
         5yi4TfjaMOEcwyjsgIhyvlUlC6x84TacgWl91NtRzZ9zabspxvtAAnjbezlKEazyCS
         mRDdB55WeYSD8+nBV7iOlkYhotCVqcZ2odPaDpqzJGzC3C0seHBiIMmirfBWp5uE5d
         9nCKkFk1TXUk2MjNrJ40N78jVhtBjVXKMJ9gP68kDfYG+RB5woMUvCfang+SeveXDj
         W/R4QeWfq0u4g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable
 ul_encalgo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220130223714.6999-1-colin.i.king@gmail.com>
References: <20220130223714.6999-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164371839993.16633.14924668742063969395.kvalo@kernel.org>
Date:   Tue,  1 Feb 2022 12:26:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Variable ul_encalgo is initialized with a value that is never read,
> it is being re-assigned a new value in every case in the following
> switch statement. The initialization is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

e80affde1720 rtlwifi: remove redundant initialization of variable ul_encalgo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220130223714.6999-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

