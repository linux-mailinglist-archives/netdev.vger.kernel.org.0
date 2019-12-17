Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE112329B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfLQQf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:35:29 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46034 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfLQQf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:35:29 -0500
Received: by mail-qt1-f196.google.com with SMTP id l12so9176702qtq.12
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 08:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iFfFtOu+kp1N2gM6HFBL3ZIm3uazNPzFl3mKzC+i4HI=;
        b=U7pmlz432/B0RvqJ/CxnNQWBVOmgdZseaobcQ3AWyTj+7Bu8MhXyTp3fEQromNUtWc
         Z9d1EVSu+JZXdnkYOfwyonkciP3uvKXWZVpyQAOLMfbWh4da95UCLuuyVQeaJ8mS5bp8
         dwh0rNDe0kHyAWSujMo9GZR3g7VJAB1UI0jo5N8H0pFPXnNVgwJdChjN+2thlzd3KmDO
         2gPFQpKIilSECewzXzMeKjtdLG2+PBqzzBZGoV9QC4q82wlb7xkZjS4lO+02gPvm6TnN
         Jw+JwRfjwr8R+OSvKTx411Hgz2BUbfOV2rPykDFmClFVmJEgTglyKbMuUAHBoIiZIQ2o
         iaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iFfFtOu+kp1N2gM6HFBL3ZIm3uazNPzFl3mKzC+i4HI=;
        b=NT6MtvmnywVDl3l73+BWAnSMMIui/LFKeKZciQhZFQE0+2zKlKZFKjK/VlHxVIwb32
         mWV/tSPKFaOCuV7+bZH08CqM5lOKv0XBr8AnmeADMknnLVLrxJ9ev5afEsqEQNBDNVem
         p1DXRcXJu36yrMtFoFGEHZF1ODBrNr9pWKYwn4riazNTz44S4DeNMkRQTO5pP5M7UpR+
         DvXcQBZCY7HFSU615rsaZNRiq/SgIt5l3E6R0hjXI8DdmA327gsK/Hv9P7t+DRuKSdBz
         5funqBMn063RJLfKFMzTdwHIjbE2TqGrHCKH9DyzhwcvWya8iIx74NKhHqvz+798lEA4
         lGWg==
X-Gm-Message-State: APjAAAVYE0K/2qB7PDKdbQ0sxMgI6z+x+1934Uk51I/SdJ5FtnIyuCgm
        +EEnpaWpEn6gNEumKcn0af2yzf1nQ+I=
X-Google-Smtp-Source: APXvYqyNyR/9VISlTmLaZGLT52nUAd2nQzfwcGyb+IbTiK2c87cS/Zr5CC8qRP7CTkGdzNGOZyF1pw==
X-Received: by 2002:ac8:383d:: with SMTP id q58mr5225871qtb.45.1576600528301;
        Tue, 17 Dec 2019 08:35:28 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:b136:c627:c416:750? ([2601:284:8202:10b0:b136:c627:c416:750])
        by smtp.googlemail.com with ESMTPSA id l19sm2771320qtq.48.2019.12.17.08.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:35:27 -0800 (PST)
Subject: Re: [PATCH iproute2-next 2/2] ip link: show permanent hardware
 address
To:     Michal Kubecek <mkubecek@suse.cz>, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <cover.1576443050.git.mkubecek@suse.cz>
 <b924dfca0572f87df953743e1ea26270eb251672.1576443050.git.mkubecek@suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8982ab75-2fa6-c409-ed2a-077b39e804f2@gmail.com>
Date:   Tue, 17 Dec 2019 09:35:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b924dfca0572f87df953743e1ea26270eb251672.1576443050.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/19 2:06 PM, Michal Kubecek wrote:
> Display permanent hardware address of an interface in output of
> "ip link show" and "ip addr show". To reduce noise, permanent address is
> only shown if it is different from current one.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  ip/ipaddress.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 

applied to iproute2-next. Thanks


