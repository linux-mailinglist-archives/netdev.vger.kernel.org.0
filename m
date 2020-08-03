Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF6A23AF96
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHCVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHCVUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 17:20:46 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1A0C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 14:20:46 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q128so4209149qkd.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DnLDcVNlztgLgpnnTiQISu6n1EBaqFNTcvhxtYnvSyA=;
        b=maHyoZjhpvGrsnp/eADMY73RQOvnTbphPO4RSentoIyiYRoT6EDzEvOMpR2UNu+gHK
         t7g7wEqqrtpL2CUhdAL/a9vnJdrPKkeZPJp1O6qkOar3m8sj+oOq/oI5L1EZuc52g5AL
         VVN/xf6483IElxFdGPOM1uDoXNY0et/XvCYLTLsO3HaWxi1Z1btuhXFssZi4+m49v5Y2
         Jm9VsedANBLtFfAL1RN9KHKyi9jgrerFX1chXMLQXVEaBL+wkHeWlaVE0IC9vMnJAXoX
         iyf+Wu+F/5xo9zk+X06Lz4pfT5rzW4Djh1xHIQQa1CpgrEJCHbkKtADOrLITCheqlkEG
         Sx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnLDcVNlztgLgpnnTiQISu6n1EBaqFNTcvhxtYnvSyA=;
        b=FTxSOFCQ3xM8HCpe2W1Gq+18zc96T2YKinkivs79YP24Xmll6VzIGdeCvUVW0TObpE
         +HpYA8gbwWRYxAcUT0fVpPiLiVsvY8cyTU0BKvDHIEWLjNwaSeufV6xQBx0k3/iA644h
         fwWVdY17hJ36ShO8EiNcPe1ioHqSKwDfu3VPp/WBTe9yoaWvz90xYZBfiVVLjzB7eazS
         BlfymtY7quyjy1i96eaYOQk1wRMR6G9hGsg1xEV5nsrEjlSXnLxQb//oy3Ox1BIuUUIb
         yTH0HoCpqnjRGJsft6XDjZx01ut75TH1HVO4/ir0BgK95usoaKTdQHZUl8BAo/UUu8eb
         CxQg==
X-Gm-Message-State: AOAM531QJ/2EHU+AaC5drAhkXNs23yG9EHGlWIwvdg620kqT05Z8YPqY
        U0GWma99vOldGHJ5VfHJ0mMma2ro
X-Google-Smtp-Source: ABdhPJzVE9E/4PEJCxxagJyqBY2VIl55A67Do8DUtWtYNXbYh/QWv3I7syj780aB29a44ZWCgsL1jA==
X-Received: by 2002:ae9:de82:: with SMTP id s124mr18373575qkf.438.1596489645898;
        Mon, 03 Aug 2020 14:20:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id t187sm20173133qkf.73.2020.08.03.14.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 14:20:45 -0700 (PDT)
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
 <c317a649-59f4-82a2-5617-0f6209964b8e@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1dfbda13-6e49-ba5f-135e-9a5ced48bb50@gmail.com>
Date:   Mon, 3 Aug 2020 15:20:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c317a649-59f4-82a2-5617-0f6209964b8e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 10:56 AM, Jacob Keller wrote:
> Sorry for the confusion here. I sent both the iproute2 and net-next
> changes to implement it in the kernel.

please re-send the iproute2 patch; I already marked it in patchworks. I
get sending the patches in 1 go, but kernel and iproute2 patch numbering
should be separate.
