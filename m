Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8E192E9A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbgCYQsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:48:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33221 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCYQsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:48:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id c14so2779245qtp.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=66ARF55QYJkiYi7Cn44AAuv7LORZTKpobYF5iJAS1tE=;
        b=ZM1psRo0XhUhd12z5OReY3Fwqtj5lyFxHfOvsvXeHggBSmLDuTiZ65H9B0lAyKYk2H
         rxMh5+6S86qvEzkDiBjDmYOvd3hU1gdAi/MHZV6G8lfuwqf3ZjZHEYdWaCl5KeJ5wxaX
         nwf05R0P77YNiF8EXNb+LUX+eVJjtpC71vFlH+MDBJniiEueTvEdfkNByge0iOrUKwLN
         kVIQhtMRI2OR1Icdipa0+ZhIeW29BXQZVN7dTjP3p4DjMwQ/6hfVZnPAceMk69yDnaos
         Eu8LGESPtJyLyue9+GGiJXTHlKrdfJZH5FFFJrRBbmnbOwaeAJLrC3XJxDvtjLDQdkm3
         ar5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=66ARF55QYJkiYi7Cn44AAuv7LORZTKpobYF5iJAS1tE=;
        b=RjlI+Wal5wahGZ7bLbweoO2GFSoeN0fUcPtnOyt/CFyb6O2EuxMmGcCGNTyY2Vm6m7
         /wJetLLuNORwAT4Bh7SQp4cf7atn3kmy1YYM1rnQ23v5/8r2e6iXZbadc5RMACSM9o2k
         zl+SlBa7oZ740x3u0OgVaT/ftqJ+Jb5HRydJzaOCBGOGE0/DJesYeHksYzyjKiLlv0yS
         Vk0SQNP4qA4y6X/mrY/7lwKwVIGNOzmQsfHmr0vnZ3SURkMoY4vVkMKva3/v0RV2wRPX
         Ps7ZZ2b1eZDpkpniwSukJYGSTaOdUA+F2gZrp72hsmidTOr9cX8o+znYKTI9cWFCHFDs
         sN0Q==
X-Gm-Message-State: ANhLgQ29qZHIfrvcz2uIsl1/PFV5XjkTTSQ1kC3Fjfni/N7ejWVZcHOB
        ceNsEaTZZtmkD3DoCNSvPOU=
X-Google-Smtp-Source: ADFU+vt8S0h7soLiD3h0xvygkTdX+Ydndt29EHGt8t4OzYzAWieVBLr6tDcnp1eXyZj9/vw45qEmAQ==
X-Received: by 2002:aed:2605:: with SMTP id z5mr3945911qtc.240.1585154888894;
        Wed, 25 Mar 2020 09:48:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5593:7720:faa1:dac9? ([2601:282:803:7700:5593:7720:faa1:dac9])
        by smtp.googlemail.com with ESMTPSA id l22sm16832454qkj.120.2020.03.25.09.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:48:08 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] bash-completion: devlink: add
 bash-completion function
To:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200325092534.32451-1-danieller@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <09b58b80-ae1b-c9bf-ff0f-747978838225@gmail.com>
Date:   Wed, 25 Mar 2020 10:48:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325092534.32451-1-danieller@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 3:25 AM, Danielle Ratson wrote:
> Add function for command completion for devlink in bash, and update Makefile
> to install it under /usr/share/bash-completion/completions/.
> 
> Signed-off-by: Danielle Ratson <danieller@mellanox.com>
> ---
>  Makefile                |   1 +
>  bash-completion/devlink | 822 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 823 insertions(+)
>  create mode 100644 bash-completion/devlink
> 

applied to iproute2-next. Thanks
