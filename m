Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E363D3D35
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhGWP3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWP3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:29:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9181C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:09:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso6646972pjb.0
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wAmVAulO3l191Q9hcwWj97TwsiuEEsSC5579oWBj2DU=;
        b=rrcRLTOhCj0f7PgvMXhnsNFzMoT1X2NYfRbsMKeYe0J++2p6USJuR4iemGmXsw39Dm
         mC9o14viSa8gwyvFLQXeejt0tOlhv7Jg6keKXsX6a1ZMLjsscN21uvVSbZYv467NeAvk
         gtSbxWlt+FAPBjEbOF1gb+lGhUlBlWY2yEcokn6kQ5K9GoUaEXTrIQ7ckZ5qLUe5UQaT
         90D/L6dT05l2lLSUzeW8N+7QexUun4c0H7BeReLtr6bUqkPpJm+KRv7xI+dy+S8wuNVN
         TGeiyJDy42AYqimSWSxlp/BxW7wai9s6GtPJDfzdzVP4BjUkgJZ+9rTrowiwa/u4nQZT
         0Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAmVAulO3l191Q9hcwWj97TwsiuEEsSC5579oWBj2DU=;
        b=MAlQ1M+teJe4LT6qLx8OGeaCRyAjTKe/OtxU55UTG6a7rMAtrqwsDzSFH3SC36L0oi
         UisvMRosBtluKK+wJonXHY9jS7RiGYHbEy7TJSaB7EJbntc3GIDsM4m1YoZe/wvha+nq
         +Hpuek71/iwMDYGsMaQ64U45VR76xxX8lHQppLpNefRGssPR/lVoCrDeazUeb/SeRPey
         d+CI8LKCE9Lgqpu+P5bXKClxrE8TiJbQwvo4p04ha+e5aTLMdXUwFT+D9Rmvp7wp/U79
         22fMPJKv2k/IeziNYomZsTqSPO70m5lTUDfvn5a4i0I1WUD4KiBSvpUZP+9N2kvZboW2
         hF0Q==
X-Gm-Message-State: AOAM532iUpi1KkP9hvLM7ktPwJRqomv91+ka5vUA455tdpbw1vDvyIQf
        4RDg19jwq0NkngD7T0gzGdtLh6Krlm8=
X-Google-Smtp-Source: ABdhPJz1AzzIaueg8Eg27efZRGwtEzHNi+RO5FQMjwGLCvtVnCyEDgUSUhExY6ziEns3PqMVlVNQPQ==
X-Received: by 2002:a65:5544:: with SMTP id t4mr5510890pgr.240.1627056595989;
        Fri, 23 Jul 2021 09:09:55 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id a23sm35586878pfa.16.2021.07.23.09.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 09:09:55 -0700 (PDT)
Subject: Re: [PATCH] net: phy: broadcom: re-add check for
 PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
To:     Kevin Lo <kevlo@kevlo.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <YPrLPwLXwk2zweMw@ns.kevlo.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <12c8330d-fcfc-532c-c981-dd4f07d2b2d6@gmail.com>
Date:   Fri, 23 Jul 2021 09:09:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPrLPwLXwk2zweMw@ns.kevlo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2021 6:59 AM, Kevin Lo wrote:
> Restore PHY_ID_BCM54811 accidently removed by commit 5d4358ede8eb.
> 
> Fixes: 5d4358ede8eb ("net: phy: broadcom: Allow BCM54210E to configure APD")
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Sorry about that, this was due to me incorrectly merging the changes 
when they were forward ported, good catch!
-- 
Florian
