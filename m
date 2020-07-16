Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D6221A7F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgGPDEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgGPDEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:04:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5169CC061755;
        Wed, 15 Jul 2020 20:04:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a14so3012050pfi.2;
        Wed, 15 Jul 2020 20:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1/J03KgFHpPtRfMDaSZSE2XRpRA4E0Gmujh6HvBzkE=;
        b=rn91M+nIEakUqiUciisLcH1MenR7mS9GDonjEK3HFqrRnJcBxUH74295Wx9A1w6hjy
         CaYY0kC8IHsTSEthPrOWRbeqv2a5azikLT5/BtLEcN4NqiEGwtnFTn/L2Wq0T4xrBAmu
         Vo4wAMMAvvtGOQOOxZ/+4gy1vl87JgDn//zzY6fQn3h6nIxp4aHwySWqmLyMM13B1iVr
         em2BicO1LTQD+AFypt4r/P1AiUw3AeceddJwZEqMM8EUOtA3gRNwF/4/vnjmAlO3ugCo
         PhuyBen/kPHNFoCjVj8Af/jw86czRiW9GAt9YlVhcpXvNooJwBbGskMAkkvrx2QMDgm2
         v+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1/J03KgFHpPtRfMDaSZSE2XRpRA4E0Gmujh6HvBzkE=;
        b=bRcJxs+oTJvKNkoqCg/aMIweXSTTki1NH9kYd5ILDOPJQq1GDlpu6RcxWvM54vDwE1
         Mqbyr8J+7lx/LkvoccIrOsyQIuTlQFqoCgEUL+xd2MS0L1TjWUlcnXafSxAGcXwpk1wT
         emsACX5DSJsan3DMY3DlxMpCLuNOOgttLbOPI0QAWZCB0DnWoUwzTVKuUbSyhATaKGvO
         393tnAFOlxi7R2FSvSPQjEmy7hD5nIvemqp4Z1w+HfwfLycYZ7NwA33rjZnr4y+RbsrU
         sWHpP/BJte3rUncDnB57qU3gbYD4NS41yCNCBi69y16Rs/JRFAOxy/3SOzkwSpKN9U41
         0t2A==
X-Gm-Message-State: AOAM533zdUcbhFyLPf6s4EiSYRBvClS70a8fwcDzDwB2xbSrLP8KbC12
        JWNYGXb1dn1Gq/K/j1XstTz8pjJ6
X-Google-Smtp-Source: ABdhPJwE3iRm0v+5k4sHXBKvLKvy+t62zTK4hr+qN6LqMWICohQCKBgVVTl5prDkvw0phjYD8p9Rig==
X-Received: by 2002:a62:545:: with SMTP id 66mr1820117pff.311.1594868685417;
        Wed, 15 Jul 2020 20:04:45 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y8sm3323136pju.49.2020.07.15.20.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 20:04:44 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <633212c6-8cb4-9599-0086-8a8de5c45172@gmail.com>
Date:   Wed, 15 Jul 2020 20:04:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 2:03 AM, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> An ACPI node property "mdio-handle" is introduced to reference the
> MDIO bus on which PHYs are registered with autoprobing method used
> by mdiobus_register().
> 
> Describe properties "phy-channel" and "phy-mode"
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

You would probably want to submit an update to the PHY LIBRARY section
of the MAINTAINERS file to add this PHY DSD documentation, can be done
when this series gets merged.
-- 
Florian
