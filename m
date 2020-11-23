Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386902BFD40
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 01:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKWAL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 19:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgKWAL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 19:11:56 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8319C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 16:11:54 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id q22so15306356qkq.6
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 16:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T93h+9kA3ALEnF11lT3rrJJSyQgBhPitOTL2WaXcYLM=;
        b=utcCpMrOJBemCz7EMjIbNzn1+QAOC4Y0bkpvbZZzZhUJBJ1EF+0mDLtLCdlXyeTsjM
         XY5cu16rMpWDPEyEYtthlowhWrz+bmAfpkcSuvxmixrWhjAFPch6xMTOxBXtJSqMo0PD
         VgRwtzjfeEti6F0jkYLOswUR5ngkLdYO6X/d7LBtgEllZ4YeDq1syihhPe2DhsbXfqef
         uormb9bzzu5vkxXhdN1oS53hJYv5zv53gykdiJ8M4wVBU7/bEag8kRnu+Ri6BQ81kKPN
         SjLcJLpV0+fgrZwyVGHVCNlHjsZ+cWy5qBk1z9/Bmhj4xkobSN956UcySUxepbmXm2go
         f7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T93h+9kA3ALEnF11lT3rrJJSyQgBhPitOTL2WaXcYLM=;
        b=FiVl9uJM1a792QriMu4ZTE32SwOW5KPOztuKOfmuSZqQBIOh9x4hrxuA/tuZ3vg2bR
         CNx+Oc2+2NomiypaKZT9jM13gYNBNx0N8zif2y8T0OcdNrwtAK4X5m4mnrCPlYeftIi6
         LC14jy3DutWqYKdtJAPShx0C4jLMmOX+Pbt0q51VC7zpiW3Y57kvJSyGYscbidqep+P3
         CNVkIY3oqekhggpQhp4Qr2bls4O8AVi1tdlF3+k4Vrni49J9nyj03uis9G9AqwDgF0Rv
         ua15FIYuIi6nGSjKFUneaSHriuoLwP1GSo4VkFIFaEMQC2nDFF31PLbBQ2eVMC3gqajl
         xtjA==
X-Gm-Message-State: AOAM533O+cNzyeEfqfWdIYUBN0paxAmKKk6UAWojXxvsy/wiHr2EdIa3
        FKPEfAjkGLTZWJwQ1WLIRukBXA==
X-Google-Smtp-Source: ABdhPJwtDoeWCA93n0RtbkUpzreLCK7Ezq40ccDXkIOYjf8f+sUZkc5ZZFrG432TOCcwh4BfTxqIxg==
X-Received: by 2002:a05:620a:98a:: with SMTP id x10mr28119027qkx.259.1606090313274;
        Sun, 22 Nov 2020 16:11:53 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id c1sm7652669qkd.74.2020.11.22.16.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2020 16:11:52 -0800 (PST)
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_
 prefix
To:     Vlad Buslov <vlad@buslov.dev>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20201121160902.808705-1-vlad@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <0020278b-3bd3-571e-e9d3-fcb2b3229c21@mojatatu.com>
Date:   Sun, 22 Nov 2020 19:11:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201121160902.808705-1-vlad@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-21 11:09 a.m., Vlad Buslov wrote:
> Currently both filter and action flags use same "TCA_" prefix which makes
> them hard to distinguish to code and confusing for users. Create aliases
> for existing action flags constants with "TCA_ACT_" prefix.
> 
> Signed-off-by: Vlad Buslov <vlad@buslov.dev>

LGTM, thanks for the effort
.
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
