Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F297410E2D
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 03:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhITBfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 21:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhITBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 21:35:21 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9317AC061574
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 18:33:55 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id y201so7910048oie.3
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 18:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wnvfjWK/yqxEFgy+KBBrq6pVVbFVg5uH9iBlIannB8c=;
        b=iMGPbncCu0GqTAbl0HOfcyzwC2CafqY8ljDFW14AuddvJ3kM6t3vJdGwt0JtkgjBnM
         nFkE8CjHc/SzZ+c3FrubYzQmjoJd4d9+LPGYajstz8gV+7Kx4c0YySZmFqUnfMxZojge
         ZhlVZegfJh9FhoGSoij2sF/uwYt9sL1XYm1+V6e2leZEIcM7TtC4q/SISmO9Rc0euWVQ
         pYBW33wsfD8Jkj8lisHqHVLLn2aMmg4Y3PiKag1Hzh+PvHvqk+ho7QIz1F3uDK0UQQ5L
         674ouyAvSx7ICEFFQVWGicdaByb0ECY+kgBWFNyiiUM5DDnqlfOmEKzJsz5CFFjhSVcF
         6LKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wnvfjWK/yqxEFgy+KBBrq6pVVbFVg5uH9iBlIannB8c=;
        b=EWZP0xYO9tPHZzkOStDjeNhuN5p6OZfIijs5SvR7Z6dNavBfNx2oDvJazKLRmspW4I
         NiSUqqSuE0iSFGjazO/zG5WDp/K1fcaRUZiR+PcDlS/o9M2pyzdJTddrxDcJbHP9OzJD
         gXIwxsFBh/vUTqdgOjKqmT05iHroHYYdRB0GC9ZF9p1i4ZN+ZmrSozNE8d/eE/ZU79c8
         ruFjVVgeUEnxfOSfQ9geCOTpk0ucKwqOHhDZv2upf18H44OuOpklxBE2cTGge/gotSJ4
         hqxOSeNKWiUyQUcymIIlxPNR3GMnKzhl5D2i2kXPkGLkfhnl4JezJExG7ArlX0gwH9mz
         NF3w==
X-Gm-Message-State: AOAM533He0oz8cJ7rtxQepx69Jh55S0qCTxpFuSqEMrJrGOadaG1exV7
        TRLQiOu50egZRNzwl2ZF/VHV8Le5IwbGaQ==
X-Google-Smtp-Source: ABdhPJxiW6RnFK+ZGIOlGO60QKEVgyXiUmV7d1Gk+Xtu17dg4kvA6NSXv5AKNEnmEboanD7ugvvIVA==
X-Received: by 2002:aca:670a:: with SMTP id z10mr21031997oix.61.1632101634781;
        Sun, 19 Sep 2021 18:33:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id j13sm2373279oos.22.2021.09.19.18.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 18:33:54 -0700 (PDT)
Subject: Re: Adaption request: IP-VRF(8)
To:     Michael Hubmann <michael.hubmann@gmx.net>, netdev@vger.kernel.org
References: <trinity-bb3fc75a-1467-4d9d-b3dd-220b88364fda-1631913484949@3c-app-gmx-bs71>
 <trinity-4af44d6e-0702-41de-880a-95b7181570dd-1631956430822@3c-app-gmx-bap22>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4801dc05-1467-959c-4bef-b549af4b1ab0@gmail.com>
Date:   Sun, 19 Sep 2021 19:33:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <trinity-4af44d6e-0702-41de-880a-95b7181570dd-1631956430822@3c-app-gmx-bap22>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/21 3:13 AM, Michael Hubmann wrote:
> Hi,
>  
> checking through the man page for the ip vrf command I have detected a wording issue which should be adapted in my humble opinion.
>  
> I am referring to the word 'enslaving' used in the following extract from the mentioned man page:
>  


Please submit a patch with your proposed change.
