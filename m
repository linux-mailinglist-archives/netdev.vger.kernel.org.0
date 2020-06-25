Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21471209854
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbgFYBvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:51:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59CFC061573;
        Wed, 24 Jun 2020 18:51:39 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so2921207edm.10;
        Wed, 24 Jun 2020 18:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8gW7J8BAetBJwK98yQto94cpXYwJ/k0fZqb/2/kATFk=;
        b=lqf78dgy9rvKKalxHDquLiJFMViu3qFoQR0KxWmjHqnNSl/ksXiXfTAiaLrExBFCrY
         JOy9uCop1R9ffBDVbY+29FEzl+q10Ug3fO8wAe+HKJ/P6vtAWwai7FK4eDy82vhRf1Mn
         exuh3N43472YhS0Hb8dfV8m5gt0VKKH26UDBmZ6lkZJzsP9oclOh2BbLrSF5cTk1/SgQ
         Aq2wGDscUVAwPahnFbVtzRNlateW1JFfuXMj0b1Cl21o4l1XdOjY+CsXxkyM0toNgJkr
         MnCRBgCMEIwEiZVBg5Nl1gTucrp7iOLvAhaMY6gAmFMZHD+aJDeBQWPzXJXIV/Tv9qKr
         2OUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8gW7J8BAetBJwK98yQto94cpXYwJ/k0fZqb/2/kATFk=;
        b=tiMfk1GGS8FXIhreu9HGk3NvOiMNz6f9bpqlv9aNNMMjSwt+YPBG3TUkloeyJQUGhd
         vPbEfGoRQR+0coFCyS0tiSToivqhnuANaWemNM2Trnf7JLleZ07/E906wKMiBwA9JY+n
         kmY0+XcnYQ/ijXW6Favpud7lS4UewqIqMElMLT6fvaRswLH0fm3iTVh9nWhyHgOiAtXr
         om9ww3o8bZaFrTeCtFe6RToi0yaQhU3tdbYXv0icaKYrW/mWjwqjlsNjGkX+825EZOvM
         7USVX004cIpvBhOyAYeE6uQpgJE3QizOTksvPvK2slpShZjC7NkYGdqclqEt0LMS4lWz
         TgAg==
X-Gm-Message-State: AOAM533myjnfBMdCBwG5PvP7A0816B07cMRvd4CudPK9TgsNDeKM9uWE
        AegCSZ6aFf3nXiojk4t3vEgKfoch
X-Google-Smtp-Source: ABdhPJxQAB+FaIqKzudxOgORcOU63lsakKjKV59Soc8EwGPrgX9oyeASrlWiDY0PctDI+kUdfeesRQ==
X-Received: by 2002:a50:e8c8:: with SMTP id l8mr24023616edn.386.1593049898201;
        Wed, 24 Jun 2020 18:51:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u13sm10737816ejx.3.2020.06.24.18.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:51:37 -0700 (PDT)
Subject: Re: [PATCH net 1/3] net: bcmgenet: re-remove bcmgenet_hfb_add_filter
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
 <1593047695-45803-2-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05f0fc4f-51a7-f59f-f045-e84315bb0a9f@gmail.com>
Date:   Wed, 24 Jun 2020 18:51:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593047695-45803-2-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 6:14 PM, Doug Berger wrote:
> This function was originally removed by Baoyou Xie in
> commit e2072600a241 ("net: bcmgenet: remove unused function in
> bcmgenet.c") to prevent a build warning.
> 
> Some of the functions removed by Baoyou Xie are now used for
> WAKE_FILTER support so his commit was reverted, but this function
> is still unused and the kbuild test robot dutifully reported the
> warning.
> 
> This commit once again removes the remaining unused hfb functions.
> 
> Fixes: 14da1510fedc ("Revert "net: bcmgenet: remove unused function in bcmgenet.c"")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
