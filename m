Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6D014D7FA
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 09:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgA3Iyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 03:54:41 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:14387 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3Iyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 03:54:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580374480; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=N4CNwBz5EJbDpyDW//KpaRAWD7Ad6mnXNFZjBhnIKVg=; b=ImQcH/RN8WHeu/mjbBsVD63xYeJG/esJ9LOsu2iJnIJ8jMlK8DJ0EMoOVuIxCX0bhMxq1cbG
 7XFBgYYuq5PZ5f3HWh5ler6gJqRJ5ILOibs+rMUpuGQnXw1ihLEoG2ArMM/Yj+HlUcROnoan
 OibiHaPixwfV14Swg5ADf86fl+0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3299cc.7eff5281b618-smtp-out-n01;
 Thu, 30 Jan 2020 08:54:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6C5AEC4479F; Thu, 30 Jan 2020 08:54:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A342C43383;
        Thu, 30 Jan 2020 08:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A342C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Ceresoli <luca@lucaceresoli.net>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iwlwifi: fix config variable name in comment
References: <20200130080622.1927-1-luca@lucaceresoli.net>
Date:   Thu, 30 Jan 2020 10:54:31 +0200
In-Reply-To: <20200130080622.1927-1-luca@lucaceresoli.net> (Luca Ceresoli's
        message of "Thu, 30 Jan 2020 09:06:22 +0100")
Message-ID: <877e19cojc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luca Ceresoli <luca@lucaceresoli.net> writes:

> The correct variable name was replaced here by mistake.
>
> Fixes: ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0
> and 11ac RF modules")

The Fixes tag should be all in one line. But TBH I'm not sure if it
makes sense to add that to a patch which has no functional changes like
this one.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
