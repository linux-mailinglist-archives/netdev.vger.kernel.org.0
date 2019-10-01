Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B1EC2FFA
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfJAJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:20:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733166AbfJAJUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:20:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 71E8460A30; Tue,  1 Oct 2019 09:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921647;
        bh=OQx15RJQONQOmfYTU4zg/YJHQVouYlwdvP4toHfwKCs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=e8+0BDzSA2ZZPoi5QTa853MVDK7PrDs6rfyu/oDkOPlSVw11nqG8GXJAFaC+IEoGO
         56Ci96fjPsS5xHT/NBHMyK286vKDXauliqC5hrExlWOzC06HMzAvxoBAhIcf0ol3Ig
         7BD8LctB9YpTThvDqaIwtCSceXwDbtL657QthrGw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E1A3E6081C;
        Tue,  1 Oct 2019 09:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921647;
        bh=OQx15RJQONQOmfYTU4zg/YJHQVouYlwdvP4toHfwKCs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TlEO+8GWX8n1eA/Tr5jGawB8HZca0J/r+En0Z8qYZdDYFQpXwOdcC95oBAY2V0RVL
         6ix35ouOrkSRxJZl3VdxmGSOhexgjVDE1IfCP3AJrUgge3aZhMs93LSCt2fPVql2gt
         8YVW9WWGHx9SbP3vY7CoDZoAqiH5dvdaH8CaQG80=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E1A3E6081C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: prevent memory leak in rtl_usb_probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190925012022.13727-1-navid.emamdoost@gmail.com>
References: <20190925012022.13727-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001092047.71E8460A30@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:20:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In rtl_usb_probe if allocation for usb_data fails the allocated hw
> should be released. In addition the allocated rtlpriv->usb_data should
> be released on error handling path.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

3f9361695113 rtlwifi: prevent memory leak in rtl_usb_probe

-- 
https://patchwork.kernel.org/patch/11159885/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

