Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44EE43DBEA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ1H05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:26:57 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21306 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhJ1H04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:26:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635405870; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=jrehSSYLKeNPQqrmD7n/sxukHCpfxHWg81aqT6+joGs=; b=sxremxW8qQF56BBwRzHuAlbPVgFn5qu2Kw0s16+ZRabnDRXmjmc9YUZT2grcsBFkpZHS3S1n
 V4yTbGMitGZP+3d90hNET2vyg3QkwmSF+X2FQBVIQ5xm+08xyBY4n+ouXp35Zfl6p2BoUjew
 O+FobmD7akh6u2EV4BqRUPnZGNY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 617a5025648aeeca5cc2e34e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 07:24:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF68FC4361A; Thu, 28 Oct 2021 07:24:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 501E7C43460;
        Thu, 28 Oct 2021 07:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 501E7C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v20 2/2] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20211018100143.7565-1-srini.raju@purelifi.com>
        <20211018100143.7565-3-srini.raju@purelifi.com>
        <20211027123839.6h3rgxsgk6p4ydg3@kari-VirtualBox>
Date:   Thu, 28 Oct 2021 10:24:13 +0300
In-Reply-To: <20211027123839.6h3rgxsgk6p4ydg3@kari-VirtualBox> (Kari
        Argillander's message of "Wed, 27 Oct 2021 15:38:39 +0300")
Message-ID: <87tuh1628y.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kari Argillander <kari.argillander@gmail.com> writes:

> On Mon, Oct 18, 2021 at 11:00:55AM +0100, Srinivasan Raju wrote:
>> This driver implementation has been based on the zd1211rw driver
>> 
>> Driver is based on 802.11 softMAC Architecture and uses
>> native 802.11 for configuration and management
>> 
>> The driver is compiled and tested in ARM, x86 architectures and
>> compiled in powerpc architecture
>
> Just small style issues in this review.

Very good review comments, kiitos :)

>> +static const struct ieee80211_ops plfxlc_ops = {
>> +	.tx                 = plfxlc_op_tx,
>> +	.start              = plfxlc_op_start,
>> +	.stop               = plfxlc_op_stop,
>> +	.add_interface      = plfxlc_op_add_interface,
>> +	.remove_interface   = plfxlc_op_remove_interface,
>> +	.set_rts_threshold  = purelifi_set_rts_threshold,
>> +	.config             = plfxlc_op_config,
>> +	.configure_filter   = plfxlc_op_configure_filter,
>> +	.bss_info_changed   = plfxlc_op_bss_info_changed,
>> +	.get_stats          = purelifi_get_stats,
>> +	.get_et_sset_count  = purelifi_get_et_sset_count,
>> +	.get_et_stats       = purelifi_get_et_stats,
>> +	.get_et_strings     = purelifi_get_et_strings,
>> +};
>
> Just asking why some prefixes are purelifi and some are plfxlc?

Good point, I guess this is because the driver was called purelifi
before. I think throughout the driver "plfxlc_" should be used and
"purelifi_" should be dropped altogether.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
