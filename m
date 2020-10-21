Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36530295260
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411443AbgJUSmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407822AbgJUSml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:42:41 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0165C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:42:41 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l16so3470321ilj.9
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MB+UsuzxpyKfxGuF3a3bySka4j03h1nDHSQ30c7mL98=;
        b=O8E9kO9OwYsQbI0kSxwE4urKjyeOI7UyRFxgepPWr3lXu5QcTfBAx29W6s7Dp1onPx
         D3uw1tQsqprYNzy51YgCYNqpOEFMENimutIeE1Ey2q6c6isnGhx3ToJ7mGq7K+R37XJ6
         dbOpBQmOCnLwzfdJklF8HmDgdD+ijtYphlf3A9fvCoevISK9yqPRNUHnkNh0jfYrDAwU
         mFT27WJrS67XuvLFpuqGawS6hCmyMlDd1STdmSKV+/k8RjKOUGteXKY28Rk27UST7+nB
         cg9ccKjNJabbFw0r43V1kFtGAm0ZuOy87DyqjLhTZ6yEg45kFOBqcBPpbBOzPSMOrrQz
         Mn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MB+UsuzxpyKfxGuF3a3bySka4j03h1nDHSQ30c7mL98=;
        b=a9latJU9c5y5f+MqbimKiFmsKjtpM+e42f//Y3pNUYRrXXbhKrECxq7oKtbhdj6QsI
         jgZr/FlkqhulPYww9XrKkyURyVW0wMu01Pbxv1pPIN1RqHryKavnaj++lvL3HHaldQJd
         CtB47jwOJxKlf4T3drhCJ6HM5sCYlLIHCJm+NdAixA5pHzRI+MTXhnAPIYchFqtGAn6N
         Hx7/2ZKPTv9BWChlDHv+nR5GeyRcHlYpdRu1h8aGR5ozMw+r5MQ1xBaK2bk2b9H5F5aq
         74Vt+w14Wl5OSUUaCP9QAzR6WyH/KnJXq96ANDwuURb1wmtfNCAgPiq2VwUvSme/2mFC
         /ODQ==
X-Gm-Message-State: AOAM532FsyIEsxa3G/wKaXdMnrIf3jFBMODYcSskqmztUxqUZCpEaCXC
        DNrtCQaPJ2J1H/vUcgqF0H4=
X-Google-Smtp-Source: ABdhPJxI3wsO80UTHKaJnN5OwyTJSG07IQ5ehdefzasPpGHTWmUk753i808lBIvf/ehviRLLNeY9tw==
X-Received: by 2002:a92:c650:: with SMTP id 16mr3311743ill.94.1603305761235;
        Wed, 21 Oct 2020 11:42:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e8b3:f32:310b:8617])
        by smtp.googlemail.com with ESMTPSA id x13sm1634076iox.31.2020.10.21.11.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 11:42:40 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2-next 1/2] m_vlan: add pop_eth and push_eth
 actions
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
References: <cover.1603120726.git.gnault@redhat.com>
 <a35ef5479e7a47f25d0f07e31d13b89256f4b4cc.1603120726.git.gnault@redhat.com>
 <20201021113234.56052cb2@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <571c60ef-1c9e-62c1-1cd4-6bd90341b15f@gmail.com>
Date:   Wed, 21 Oct 2020 12:42:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201021113234.56052cb2@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/20 12:32 PM, Stephen Hemminger wrote:
> On Mon, 19 Oct 2020 17:23:01 +0200
> Guillaume Nault <gnault@redhat.com> wrote:
> 
>> +		} else if (matches(*argv, "pop_eth") == 0) {
> 
> Using matches allows for shorter command lines but can be make
> for bad user experience if strings overlap.
> 
> For example 'p' here will match the pop_eth and not the push_eth.
> 
> Is it time to use full string compare for these options?
> 

I thought the same, but let it go given the pervasive use of 'matches'.

I do think iproute2 needs to stop adding more uses of it and forcing
full strcmp's.
