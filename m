Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54BE51343C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346693AbiD1M4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiD1M4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:56:09 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E562AC068
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 05:52:49 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u3so6671914wrg.3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 05:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ayQ6jaj3HRG+TRst7apfV+X8rdJKniYU/+Iv6hoPCH4=;
        b=neUQ9n98qLiyxAF30ks330S4NOYEn6JgzJAsAJyzq7cCSGJ4/1qhjBSIQGnubem5CY
         7zC/UszUd9X/BRmuofbFuGJ5YETmhgAg1IKBvnRt1nqdKGedq6v1BgwnzGR/dpJ4+PVc
         UxtoxedLZD7YXkaRPNwICs4gAaVLiXNV+vWHDcyBCpQUAc/Zn2+d/2narT0ox4WxO0Ih
         6BHYaLCUq/DAJ0BKRmTZ6+QP61sthGr8Qv01y2V40f/1UTKTa9L7PXBBdXOuShgar7zO
         2pLAa22uq/fbPPMU82QZsypbefEIqSzOiD5fT37X+wkYE1Zg4WLa72GM3t9hQoBU99jA
         H2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ayQ6jaj3HRG+TRst7apfV+X8rdJKniYU/+Iv6hoPCH4=;
        b=bw+wUXuBSnDMdF4Zv3L49ZuF4KZE3iRwoImdoFj0pcR3hfb3VxmCJj8am6rxaeHBuA
         yEZ+0boV2QNcY0q4ks2MXgIsP/DLXPmSfcuqVl8awLxZZ9Cnz+rjrIYHu3PASaaSwqRf
         2tIztJB0rgEYnn6cS4BNBMdK6906SjYq/otZL61rPEpJjqa4g3fF6v/6ZNrjgTaTBjbY
         G8pym8l2Fbzk+ozZiymWnlbilgnB19upa8qRQvp1mHmV+sI0xT95h2XEaBa1tdEJlOhq
         den4NMQkdCfbpCKEBjaYATJsLZa55vqShReLb84IKqXwKE6+Vs72qV/z7UvPpgI5hLrE
         vujA==
X-Gm-Message-State: AOAM530ZJVQ+Exg4UiOSLtOpW9/pqJYg6v6KGUa39HCFeES8AFevbcRZ
        fwqGt0+rm3v5qE1djwE4DlVIOg==
X-Google-Smtp-Source: ABdhPJyXni+pnO58WLJMvNAZ5GvJqowWD7XR5Bkqz+BnKvdkV++wbybCGrCGM3JTOwVUIHX9yBwoAw==
X-Received: by 2002:a5d:5311:0:b0:20a:d007:b499 with SMTP id e17-20020a5d5311000000b0020ad007b499mr21956331wrv.258.1651150368164;
        Thu, 28 Apr 2022 05:52:48 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id c9-20020adfa309000000b0020ad4eae9b6sm12954975wrb.100.2022.04.28.05.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 05:52:47 -0700 (PDT)
Message-ID: <9a7490d2-7553-f0cb-8a57-9c8412259060@solid-run.com>
Date:   Thu, 28 Apr 2022 15:52:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 2/3] net: phy: adin: add support for clock output
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-3-josua@solid-run.com> <YmqGwjGt/Fbeu2kJ@lunn.ch>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <YmqGwjGt/Fbeu2kJ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

Am 28.04.22 um 15:21 schrieb Andrew Lunn:
>> +static int adin_config_clk_out(struct phy_device *phydev)
>> +{
>> +	struct device *dev = &phydev->mdio.dev;
>> +	const char *val = NULL;
>> +	u8 sel = 0;
>> +
>> +	device_property_read_string(dev, "adi,phy-output-clock", &val);
>> +	if(!val) {
> I'm pretty sure the coding style requires a space between if and (.
In fact it does :(
>
> Did you use checkpatch on this?
I remember doing it, but my mind is playing tricks on me - as right now
checkpatch is clearly telling me 7 occurences of this style violation ...

Thank you for the fast reply, I'll make sure to fix this in a v4, if any.
Do you want a v4 for this? Or is it worth waiting for more feedback now?

sincerely
Josua Mayer

