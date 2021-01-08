Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDE52EFAE9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbhAHWMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAHWMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:12:15 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C47C061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 14:11:35 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q20so3832358pfu.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4I0tJAk+cUmn2wC4VdkdEug/HHsCWzDOcLJuPn0EcSY=;
        b=qO3t7ZI38xq6gLK/NwYJnJuvRK8ReteAU/NZkrvi/fSXJqSD8J8sDASTY1moxfLejg
         Q6wpR3hW406Lw9NzLTxOm0MKgWdbEN+B1SiwNJ8TO1CSyKbkgyxB2V+2rJeE76jGgq8X
         +tRKDfhkczyERfx9LBygXOveBG+pGMFA9EVx4FU/lbH1kZrqjdZxw5DoKVuPDF1tIzEM
         EmU8YNd9rDTMr/mOunZZiOs/j0FGwWopiKisEZqgM8q8FYCE04LOB0290jDTgPZPgP1C
         ylc7YJSmDEASg51FsKB+Y4em0//RFcvechcZac0MXUr2JAr9Jr+HwzgMbsZXL6nhh+zp
         PaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4I0tJAk+cUmn2wC4VdkdEug/HHsCWzDOcLJuPn0EcSY=;
        b=A5trjh0X2H8fUDjRoYlZDMFGtlP1wJzWn5E6U7CYFyc/3zjXDE0/BynZ415ZxzsAaO
         2G20CjtTwQ0P6B8V5W2+cqkvq/BuWz2pOeRjul12WsuMxR6zkG2eHa5Rng+JTlPQyGfF
         4N5RCnOHCVnY6/OdxJiHM3RqKWlOPyC5XXdPKqRjnEF0Io8P28SaiGPJFiwwxwb0LN0k
         Xkt9nFnBH8DlO5TerDlABmVpt+Z2ojjIqRUeP7frlmRJGOJK7I9n8vlxD3gPIa8AzR38
         cX+WPK0UEl2Fu3ONp0MXB8j0Sv820YIZ6RSmoD17NeX8cGHSD+51yAsJCtKryflRwCVE
         XbJQ==
X-Gm-Message-State: AOAM5326jnRHeSWWDVe4hqzaUxWXhLqyVQXboJcu18xKXz4qxop8OU8l
        uLj28v/+Xrr28LmChZwcHCCEuanDCAg=
X-Google-Smtp-Source: ABdhPJwi3x+YySoXci4S9BLNc6TRUrMzoZCg91AiSDyhSPYlrDhRnHQHBuenY3riqF73Mf+q5VcUDQ==
X-Received: by 2002:a63:752:: with SMTP id 79mr8927990pgh.272.1610143894269;
        Fri, 08 Jan 2021 14:11:34 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2sm5673926pjd.29.2021.01.08.14.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 14:11:33 -0800 (PST)
Subject: Re: MDIO over I2C driver driver probe dependency issue
To:     Andrew Lunn <andrew@lunn.ch>,
        Brian Silverman <silvermanbri@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
 <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com> <X/hhT4Sz9FU4kiDe@lunn.ch>
 <CAJKO-jYwineOM5wc+FX=Nj3AOfKK06qK-iqQSP3uQufNRnuGWQ@mail.gmail.com>
 <X/jIx/brD6Aw+4sk@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <68bfbe38-5a3a-598c-25d7-dad33253ee9f@gmail.com>
Date:   Fri, 8 Jan 2021 14:11:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/jIx/brD6Aw+4sk@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 1:04 PM, Andrew Lunn wrote:
> On Fri, Jan 08, 2021 at 03:02:52PM -0500, Brian Silverman wrote:
>> Thanks for the responses - I now have a more clear picture of what's going on.
>>  (Note: I'm using Xilinx's 2019.2 kernel (based off 4.19).  I believe it would
>> be similar to latest kernels, but I could be wrong.)
> 
> Hi Brian
> 
> macb_main has had a lot of changes with respect to PHYs. Please try
> something modern, like 5.10.

It does not seem to me like 5.10 will be much better, because we have
the following in PHYLINK:

int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
                             u32 flags)
...
          phy_dev = of_phy_find_device(phy_node);
          /* We're done with the phy_node handle */
          of_node_put(phy_node);
          if (!phy_dev)
                  return -ENODEV;

Given Brian's configuration we should be returning -EPROBE_DEFER here,
but doing that would likely break a number of systems that do expect
-ENODEV to be returned. However there may be hope with fw_devlink to
create an appropriate graph of probing orders and solve the
consumer/provider order generically.

Up until now we did not really have a situation like this one where the
MDIO/PHY subsystem depended upon an another one to be available. The
problem does exist, however it is not clear to me yet how to best solve it.
-- 
Florian
