Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94001092D8
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfKYRav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:30:51 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36504 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfKYRau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:30:50 -0500
Received: by mail-ot1-f65.google.com with SMTP id f10so13344421oto.3;
        Mon, 25 Nov 2019 09:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yx1H5O1mgv+pNnD+lwv4fd9CCd2JK4iu5sf9H+gz744=;
        b=EHOE3NAQ7+En1anq7kD87m9onTHnR2WTW4cOYMiJZe3M2EiQqvqK7mF9gNV1oWxzSn
         COFYzGUODG5jkkBEcbvmYE4YwVib3hXv7JdjyCcmpgUr7WG2/2uFj5JJwYDG7aBRoR26
         HDFL0LXqs9fiZvLKPYpxO3RqoHZpMRH0E+IPzffjCMbNKYaXaeb5HDaUp7IB09rZ+GB8
         T4QKa7q7aC2ZwcCJYUNACVeN5HgMooIDNIlG7gaUeNCPHT4C/IAdCG6SQR8zNIu6pNav
         9VDje570hGAjj7plgHyBrJR603gqskIt8+nEBSJJ9fsjiw69QvjRnpNRqxWmRSuRNIwF
         U1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yx1H5O1mgv+pNnD+lwv4fd9CCd2JK4iu5sf9H+gz744=;
        b=iXbBFRJsYDejKzwJU6K83OMEE8BtmLR+GNX7tddtYIs6A3IpiLPwQaUNWJyEqCo9XG
         c7MRUoXH7au7kENr29kW7+8bOyQTa7SnT4GBj72FGBKGaK3QtsFiqsA3J9anRDTrdb6R
         TdcBXspCSuLLlTNQ78QZlswM2o+mgtfedqySrWiWjw92c1XvEsmLQeLBGNyqRm/sQWDO
         8e/RYU933+n6TAAVVlh65RVzAzLCFoU4xStcVChgJnKxfFc+yAipKLVKQywHVLDlOai5
         QbC2qrwyDcvVeXda8FYcZ9ee0gh7EZmnDidchvJHblMIx8Kg157nSQi+domQhBku3WEo
         VEKw==
X-Gm-Message-State: APjAAAUQQzWviNz82gnUpQSL5/Xy/G16ySNZoKdiGFjrV4quFkz+kJAQ
        u3qT3Vca9rt58bGGjooSg15J8MXZ
X-Google-Smtp-Source: APXvYqxo0ggMzR3raPo59g/b2tvq/c57ulTw0g6Bv6iVn8OPBoOEnRbz4s6f0wvTtRtsLhXkxPaS3A==
X-Received: by 2002:a9d:7082:: with SMTP id l2mr20100098otj.213.1574703049717;
        Mon, 25 Nov 2019 09:30:49 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e193sm2709732oib.53.2019.11.25.09.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 09:30:49 -0800 (PST)
Subject: Re: [PATCH 2/3] drivers: net: intel: Fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        luciano.coelho@intel.com, shahar.s.matityahu@intel.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        sara.sharon@intel.com, yhchuang@realtek.com, yuehaibing@huawei.com,
        pkshih@realtek.com, arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191125150215.29263-2-tranmanphong@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <61fa4ef5-e4fc-c20c-9e20-158bcdf61cbb@lwfinger.net>
Date:   Mon, 25 Nov 2019 11:30:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191125150215.29263-2-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/19 9:02 AM, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>   drivers/net/wireless/intel/ipw2x00/ipw2100.c   | 7 ++++---
>   drivers/net/wireless/intel/ipw2x00/ipw2200.c   | 5 +++--
>   drivers/net/wireless/intel/iwlegacy/3945-mac.c | 5 +++--
>   drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 +++--
>   4 files changed, 13 insertions(+), 9 deletions(-)

This patch is "fixing" three different drivers and should be split into at least 
two parts. To be consistent with previous practices, the subject for the two 
should be "intel: ipw2100: ...." and "intel: iwlegacy: ...."

Larry
