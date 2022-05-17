Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7EC52972F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiEQCM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiEQCMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:12:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534446159;
        Mon, 16 May 2022 19:12:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso1047784pjg.0;
        Mon, 16 May 2022 19:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3ZM/bXNrUv0VYX8K23DwSrqZnrWh9hjgIxkuc6viZwo=;
        b=G/Uq+Bibk8biPAB2nd1ne5S03dV1mVV4KPJvjbWokbD/HF/VcN+SLSgWMLRsgV1EhH
         0/G6np4gtSaOLlp4dBI9ZxH3eJYXBQXo1biwU86K9ixDplyGT8zIiv8+8A8DoKrZRhvu
         HcMcvLWP05k1J8Ie9LB3sgo4L+bPtwxb8xZRR+5qEzYyJVsuAfhCU0qAInTTi/Qm//61
         VYv6/jjC45626tW8k+QweHPLSyNbQDk/UvJNupuuHQYEqJWiqkehlEBKrDHL6uNWzgWV
         oTG5v+Bpmscw/z2c2ldKS+7zAm8EGJJ4m5LjPbda8a6BmmWOun8Wjbb96IeDqfbQ/gas
         8yPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3ZM/bXNrUv0VYX8K23DwSrqZnrWh9hjgIxkuc6viZwo=;
        b=wZDRCYL/7ZiTayTfyDHEHOQQw670z1z6h1raHjKJ8bUWCb4uZ37syuKhB+V+OMf2D5
         QMwGa9URAtpRqmIbCaDQEmGxBZPHXfy1Y621JQk6qhjak5QiB1jB3mLKlNNV7rD0Xhue
         Dfx86EVpErCJVKWd4I9onDl6ww2ChzRzDEj+CI5OjK9g96cq73wcp1C0BvUfOLQME1mn
         ORsprtTqvnvgIT/TK4UoryyBIa24kHx2xle7rhU6FgZqb15alWCLZejte5vDUX8ufp91
         hSeETFpbCTE8a6MN3fFd8Cx7iNqlMC8Q6zere5DkUMBXCyLb3wRsY0VmyDdz2aaC5SAQ
         4hUA==
X-Gm-Message-State: AOAM532LXO3wSNfmmZRVZ3CLoPYOGDxpoNQ9zFh1U74PtGMaZ8w9ROun
        RVlDaoXe0Pa9pMWNMlNP7V+mRWdoWMc=
X-Google-Smtp-Source: ABdhPJx6ME/ewGYrihpAFJodPTzj9vcacNJMLG0j8CUptfyQtZTu3nMyZiN/77LkGUi5NhWhbn+7XA==
X-Received: by 2002:a17:90a:764b:b0:1df:58f2:784c with SMTP id s11-20020a17090a764b00b001df58f2784cmr7744949pjl.122.1652753570063;
        Mon, 16 May 2022 19:12:50 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n8-20020a654cc8000000b003c14af5061asm7421832pgt.50.2022.05.16.19.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:12:49 -0700 (PDT)
Message-ID: <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
Date:   Mon, 16 May 2022 19:12:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20220516215638.1787257-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/2022 2:56 PM, Jakub Kicinski wrote:
> Most protocol-specific pointers in struct net_device are under
> a respective ifdef. Wireless is the notable exception. Since
> there's a sizable number of custom-built kernels for datacenter
> workloads which don't build wireless it seems reasonable to
> ifdefy those pointers as well.
> 
> While at it move IPv4 and IPv6 pointers up, those are special
> for obvious reasons.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Could not we move to an union of pointers in the future since in many 
cases a network device can only have one of those pointers at any given 
time?
-- 
Florian
