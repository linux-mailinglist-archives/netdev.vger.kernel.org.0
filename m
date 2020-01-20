Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A200B14345D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgATXHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 18:07:23 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35851 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATXHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 18:07:23 -0500
Received: by mail-pj1-f65.google.com with SMTP id n59so472525pjb.1
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 15:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cy+sCrk4UP8nbY23ZGXOmdyAJnVuPnrYJb+iWv19AZs=;
        b=Ixyt3LaUaa0DEXTxSIxlR9/mnVmpZ1Lpjp6NiIkHiOs86UCgshqoG/wn+YzanjZuEb
         F5nWs18H74j/SrT2FQsYc4egl1rlslyFJLtlwgS4uVVZZzSB0BP7cgMeFf9PwPO7NCkW
         kkbU2pTR/J3dE6DgEMTAemD36ns7J/rYSuuBhs5z9KDkKUPitIxLwHE5NZqHWkOGLsC3
         tGnlHaVu+IJPwmarYrA2ZEJpTmcnAaf3DepwVitASp+BE5rVnEm8WlI//uiFO5GRNS3a
         gOxNE0LMuJ694VGqWS4nsBrShq0r8KbO1TsvpdeUkPkpw5NgT/+7KfECqNgwoqZKVifr
         jI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cy+sCrk4UP8nbY23ZGXOmdyAJnVuPnrYJb+iWv19AZs=;
        b=kvgX95wCwdiLemT+au4KYnNCupELY+HH3DJ8uCKg65loOwZDxGH2CilbDoLldECUE1
         LD30yXQel7eW6a8ULWcHUnd3ASVNlweU2LA8p89qPs84gAFmYp1lsa97pby7M0xiNHSJ
         53/pb+X7KGF0UQedfEILYFNpn7qb25FwTs4KD+WMfrrymG/1RSEcCiaxBFuzM60srOAe
         FTcxhsuxAZXj20BK4FRWs3Y7/atitsZ1nzWbfK9E1daX9xjFWlPet50WTHZuxGQkdy/S
         1sfm8zT9USTwgFQqUtCD8cV9J/51+ZEmgWYaWwEd8Wh2hN69r+8CYhBypy1gmagiZwBF
         pbpA==
X-Gm-Message-State: APjAAAWjuxbebIWRGI+7JwTSRQseBzR7gVAq91yByF5ljQoumk7D/43X
        e53RePu7xTicYqa1fFuh+4maVBB1
X-Google-Smtp-Source: APXvYqyYJidWmTJ8imbQ6bMDecx8Q1C6olWnsaI6/fL5zG/1L9oCILzZHmMM82C8Uk6hxj6ldfzCJA==
X-Received: by 2002:a17:90b:3115:: with SMTP id gc21mr1601850pjb.54.1579561642733;
        Mon, 20 Jan 2020 15:07:22 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h128sm41558088pfe.172.2020.01.20.15.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 15:07:22 -0800 (PST)
Subject: Re: [PATCH] tcp: remove redundant assigment to snd_cwnd
To:     Theodore Dubois <tblodt@icloud.com>, netdev@vger.kernel.org
Cc:     trivial@kernel.org, edumazet@google.com
References: <20200120221053.1001033-1-tblodt@icloud.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e00bd878-a000-548d-d28b-c417d2d8262e@gmail.com>
Date:   Mon, 20 Jan 2020 15:07:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200120221053.1001033-1-tblodt@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/20 2:10 PM, Theodore Dubois wrote:
> Not sure how this got in here. git blame says the second assignment was
> added in 3a9a57f6, but that commit also removed the first assignment.
> 
> Signed-off-by: Theodore Dubois <tblodt@icloud.com>

I guess a merge error happened at the time
commit 3a9a57f637943 ("tcp: move snd_cwnd & snd_cwnd_cnt init to tcp_disconnect()")
was accepted.

Signed-off-by: Eric Dumazet <edumazet@google.com>

