Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FFC2AA6AB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgKGQ2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:28:12 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:53133 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgKGQ2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:28:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604766490; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=8kmAMZ+csPrpMbMJNA/e5p7nRkQrNNS59KEPN5JBprA=; b=d0cNzxMMm1PfMCJaPFqvNaqnDyv/gkA7go/5R3NG536i6s3XKyCcL16h1tOFiAhFeqmyZvGU
 fpfjBrn9RCwTZHdHg3uaQbOfgLHlSuaq2XYorkiyIir+fmYXTFQE0YR1lLgJ+tB6Ni6Fx6ZK
 Vl9hLhUNh9JbiYBE5e8MlxGVAOY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fa6cb191d3980f7d6d08ae8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:28:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48261C433C8; Sat,  7 Nov 2020 16:28:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53D65C433C6;
        Sat,  7 Nov 2020 16:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53D65C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>
Subject: Re: [PATCH 41/41] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
References: <20201102112410.1049272-1-lee.jones@linaro.org>
        <20201102112410.1049272-42-lee.jones@linaro.org>
        <CA+ASDXOobW1_qL5SCGS86aoGvhKDMoBzjxbAwn+QjHfkqZhukw@mail.gmail.com>
        <20201103084453.GJ4488@dell>
Date:   Sat, 07 Nov 2020 18:28:02 +0200
In-Reply-To: <20201103084453.GJ4488@dell> (Lee Jones's message of "Tue, 3 Nov
        2020 08:44:53 +0000")
Message-ID: <87y2jd5dyl.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Mon, 02 Nov 2020, Brian Norris wrote:
>
>> On Mon, Nov 2, 2020 at 3:25 AM Lee Jones <lee.jones@linaro.org> wrote:
>> > --- a/drivers/net/wireless/realtek/rtw88/pci.h
>> > +++ b/drivers/net/wireless/realtek/rtw88/pci.h
>> > @@ -212,6 +212,10 @@ struct rtw_pci {
>> >         void __iomem *mmap;
>> >  };
>> >
>> > +int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
>> > +void rtw_pci_remove(struct pci_dev *pdev);
>> > +void rtw_pci_shutdown(struct pci_dev *pdev);
>> > +
>> >
>> 
>> These definitions are already in 4 other header files:
>> 
>> drivers/net/wireless/realtek/rtw88/rtw8723de.h
>> drivers/net/wireless/realtek/rtw88/rtw8821ce.h
>> drivers/net/wireless/realtek/rtw88/rtw8822be.h
>> drivers/net/wireless/realtek/rtw88/rtw8822ce.h
>> 
>> Seems like you should be moving them, not just adding yet another duplicate.
>
> I followed the current convention.
>
> Happy to optimise if that's what is required.

I agree with Brian, these and rtw_pm_ops should be moved to pci.h to
avoid code duplication.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
