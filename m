Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC999C2FE8
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfJAJTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:19:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730036AbfJAJTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:19:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 10F7A6118C; Tue,  1 Oct 2019 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921579;
        bh=3i/agFOHNinhtrXujs6/HZMwbB8cfVfC84lk9YRPXaI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FKlmIh37b/PlS3XrmNmd5X90kzV1Ddu8WbAEMVArgsNVB7pYau1PKIcBDvjvjKTFu
         Aw5Q1RHKizLt2th0jPR6Wn+ckOdqkf8/DaQz8icFuFabH1FXvm+yBYRH0HlPIPJdiO
         FlampZwp8/l2Cc5XxacgrzTXAEY8vjGTKDTBBt9k=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 239DD608CE;
        Tue,  1 Oct 2019 09:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921577;
        bh=3i/agFOHNinhtrXujs6/HZMwbB8cfVfC84lk9YRPXaI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ObeHhhprxMO9pBxZOOtN/0eSCD3YT4MGn53bWGlSAsjm1SwyoNL9uaDce2pX4n2yT
         F9bAUacfi6XeX+uGgOOfKbiE6tqahHJhmP9QfTIqgocbANMHQsrBMn8rRDhLN9OxAa
         XoDKECLoLJfLvySpCF2VEyAH7zaBuYpvvywhuvlg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 239DD608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <9a33455c19ef6ec0427b45b2e7f7053cf7353fe8.1569055057.git.lorenzo@kernel.org>
References: <9a33455c19ef6ec0427b45b2e7f7053cf7353fe8.1569055057.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kubakici@wp.pl
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001091939.10F7A6118C@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:19:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Fix bbp ready check in mt7601u_wait_bbp_ready. The issue is reported by
> coverity with the following error:
> 
> Logical vs. bitwise operator
> The expression's value does not depend on the operands; inadvertent use
> of the wrong operator is a likely logic error.
> 
> Addresses-Coverity-ID: 1309441 ("Logical vs. bitwise operator")
> Fixes: c869f77d6abb ("add mt7601u driver")
> Acked-by: Jakub Kicinski <kubakici@wp.pl>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

15e14f76f85f mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

-- 
https://patchwork.kernel.org/patch/11155381/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

