Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C070294ABE
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438182AbgJUJrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404632AbgJUJrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:47:13 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D126C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 02:47:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v19so1901432edx.9
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 02:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q2JZXcMsiqhOVACNal6zJDus/P1Z6WAf7fS1Bz0hNkI=;
        b=KORecj9n6tC7SyrGgbd3uu0KV3vj8KCaVpRx6eZA8pmF7WPBa9RsXsMKScqPGhBbEj
         zYgBKstEoZks+SzU9cpsEcbtsHF0btC6DpNwZlKrnoNFbPRL3DEaB9Zr2fUsifiqJCec
         ZH/2eGWSRUtPiTSInDbhEihvdrFLt6Q83g5pkBksX+V+shYMVWJhfTxFrjwnCxAHzmwa
         Q710KqRoS/tC2U31tPgVv5+Mu6HT/FNyztVhFMze/E5Nf/mpF5+zDFFkU4yAiM+MfESF
         Mwtf6FYXi7+5WzAoKt/YYaF4vGtePkz/6YA7Iw3q8o3bcbzoVnD2pLGodvMKV/b+TW/x
         Tfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q2JZXcMsiqhOVACNal6zJDus/P1Z6WAf7fS1Bz0hNkI=;
        b=uKuOJXHhzZUMlg1QCFrVS7njkcv22p3XNW3gaXtcOac4yVQwZwUN6mdjG4nuQKY4hk
         Cp+TW7Yo/85d84X04pbz3hDH3wdDAsUM9Sb1OBP6PwtQaqhMeElFAqljcBYB7y+1Ecqk
         I4f7DV5cNYSIHZ9clJIq+iDSaIW4WiuyibAJJDG1MZJiAXQzLJmiPooY0vdwsOIaVfgZ
         ofrLMZSAchR+bVDgT1ze6H/UoPdfMPxEMeaJ3DdQllohWfeIjPxliMjo6a766DWxDalt
         N9VOcXYsjtl7OZPl17cwgmzQ8LrHYcxDH2P1bVBuJ8xBOADtyTro+28XzZYCJwO/aprY
         nMeQ==
X-Gm-Message-State: AOAM532yJLZaGAyVP0TbHXBB9hweYUOFn4YNfW0jOAU9lc65PnC+H6xa
        T/cjojoT1RU9bFcsr9v3ATKJ7t9jKMcBd6Gg
X-Google-Smtp-Source: ABdhPJzCtIFyre0b5Cvtx3BC0AfCbS+f/8OMggrhT+/NOWLwOxWt+YZQ/dBaioQ+3p/xupccUTxPVQ==
X-Received: by 2002:aa7:dcc2:: with SMTP id w2mr2202967edu.121.1603273631631;
        Wed, 21 Oct 2020 02:47:11 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:9bd7:d012:64eb:ce81])
        by smtp.gmail.com with ESMTPSA id i14sm1965436ejp.2.2020.10.21.02.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 02:47:11 -0700 (PDT)
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20201020073839.29226-1-geert@linux-m68k.org>
 <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
 <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMuHMdW=1LfE8UoGRVBvrvrintQMNKUdTe5PPQz=PN3=gJmw=Q@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <619601b2-40c1-9257-ef2a-2c667361aa75@tessares.net>
Date:   Wed, 21 Oct 2020 11:47:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CAMuHMdW=1LfE8UoGRVBvrvrintQMNKUdTe5PPQz=PN3=gJmw=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 21/10/2020 11:43, Geert Uytterhoeven wrote:
> Hi Jakub,
> 
> On Wed, Oct 21, 2020 at 5:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue, 20 Oct 2020 11:26:34 +0200 Matthieu Baerts wrote:
>>> On 20/10/2020 09:38, Geert Uytterhoeven wrote:
>>>> MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
>>>> not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
>>>> is done for all other IPv6 features.
>>>
>>> Here again, the intension was to select IPv6 from MPTCP but I understand
>>> the issue: if we enable MPTCP, we will select IPV6 as well by default.
>>> Maybe not what we want on some embedded devices with very limited memory
>>> where IPV6 is already off. We should instead enable MPTCP_IPV6 only if
>>> IPV6=y. LGTM then!
>>>
>>> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>>
>> Applied, thanks!
> 
> My apologies, this fails for the CONFIG_IPV6=m and CONFIG_MPTCP=y
> case:

Good point, MPTCP cannot be compiled as a module (like TCP). It should 
then depends on IPV6=y. I thought it would be the case.

Do you want me to send a patch or do you already have one?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
