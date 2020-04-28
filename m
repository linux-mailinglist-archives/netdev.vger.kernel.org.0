Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAEB1BC745
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgD1RyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgD1RyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:54:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AD2C03C1AB;
        Tue, 28 Apr 2020 10:54:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g12so3872887wmh.3;
        Tue, 28 Apr 2020 10:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kPRhUAruP9ZZUlUSalbcEM5n1KiKrGdKS/bI8RHpGas=;
        b=VzIrlcflOdjeR1fwYDtSL89m6SsO89lykIMEOlJGtenVL2zFa2SH6rFqFT2UjF9URv
         x32R7h+ehd5+fCqDs4i2QqTqMtbtJq7ksUvi3NPdpi4zt8iCnqxR7eHuiXWsh0iFPQdd
         VW3ZJ8CLhQuk5ZyRewNoQE9q53fMqZgE4MJgZYHYFO6pZU4HswzKQfJTV9Ie76OTWKy4
         Oag+9MLENJI88mGlyNlnpYFfJCaiw3rj0OlZcqNzrEVAKj16nsAqby9J1nicQvGyu8RQ
         CNSkSX4q9L1knk3X4R3ywUWJQxzv/GWi0t1T9RoFMNDgTjBKPf6xC5/MYBEu52PTum69
         GdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPRhUAruP9ZZUlUSalbcEM5n1KiKrGdKS/bI8RHpGas=;
        b=ID8UskAHzvuGTSMwkbP5SlpBo2LcGs+qmrISvfCKQaoiYH3Gwxysqd2UVFl0GBc1lX
         u97dAK1SVv1FerPQA+ReknqBdep9VTOBvDr0PyIuUEqbzjiE8n+D5rtW7cGkCeA3hQV2
         FXVBgThvIoUq59x+ixLYLARsEIMnE6BkYKebU9rhmxM45/J1V5nPyYE+IWXuuvumqLX3
         ZUnLinpuzCQYaAqyF47veOPRb3Tb5tT3dkkC0cQEYETrISKUi4GPThKkKFZgDBIqWHtN
         RVsTpC3pNSr7SeF9n/4Jwud4EOuqm7IyI/wjM1r0cGWivHXfNNG0VohcigGD6ymIx8qC
         KTng==
X-Gm-Message-State: AGi0PuZFuhmvQXxLhbbNbdq0cBG0dgw+WnjJjXlo4yyTGPz3CVoNxlUD
        XXZq8nArTgZ+moF9fHUUQsw=
X-Google-Smtp-Source: APiQypI5c0tioNdOcBvuFeeB/URE9SL/vqn9mnUU2V5ut1ZclmE1JVgT+DvDyIe3sxH/nNTp8KLb+w==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr6170922wmi.83.1588096459599;
        Tue, 28 Apr 2020 10:54:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:4f00:8150:1bad:dbab:ce5a? (p200300EA8F3A4F0081501BADDBABCE5A.dip0.t-ipconnect.de. [2003:ea:8f3a:4f00:8150:1bad:dbab:ce5a])
        by smtp.googlemail.com with ESMTPSA id j17sm29522553wrb.46.2020.04.28.10.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 10:54:18 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees] [PATCH v2 0/2] realtek ethernet : remove
 legacy power management callbacks.
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
References: <20200428144314.24533-1-vaibhavgupta40@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d33991cc-c219-dc27-7559-f30dd5f4aa0a@gmail.com>
Date:   Tue, 28 Apr 2020 19:54:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428144314.24533-1-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.04.2020 16:43, Vaibhav Gupta wrote:
> The purpose of this patch series is to remove legacy power management callbacks
> from realtek ethernet drivers.
> 
> The callbacks performing suspend() and resume() operations are still calling
> pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
> themselves, which is not recommended.
> 
Did you test any of the changes? If not, then mention this at least.
A typical comment in the commit message would be "compile-tested only".

In addition the following should be changed.
[Linux-kernel-mentees] [PATCH v2 0/2]
Use
[PATCH net-next v2 0/2]
instead.

> The conversion requires the removal of the those function calls and change the
> callback definition accordingly.
> 
> Vaibhav Gupta (2):
>   realtek/8139too: Remove Legacy Power Management
>   realtek/8139cp: Remove Legacy Power Management
> 
>  drivers/net/ethernet/realtek/8139cp.c  | 25 +++++++------------------
>  drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
>  2 files changed, 14 insertions(+), 37 deletions(-)
> 

