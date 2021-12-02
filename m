Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B44046690A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376299AbhLBR32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376294AbhLBR32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:29:28 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AEBC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 09:26:05 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id jo22so100373qvb.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 09:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tPWb18pzdYP4gepUET+WlF/T7jKUlf4IkvWpJ/7uajs=;
        b=HWU/YEOe7zB1KHKCkY+8Ou6+yhZt0XooYuPjbA55YiEU8E9Jh92ee8ugy9PBGvlp6/
         wmEyJG2p3k4DveKEGgY9W+3D2HkSHyGxtOtIyPQDeXBnmxr52SEc30rAnSDnbfpB9wGH
         zweXfJvbTchrWtOIdTNg+/on+15ZkEYeVKAOJeTujXX6Qo9u0eQPTWPlAP1VNhUXAtxq
         /HKQ5okeVjvWRa/jCYOJshNXaqPcHdt4NoevKj4uYcc+PtMtEe5n7z2R/WxD+zMbw/2R
         l4g6dZYJOi+GR9ooJU5NitWpPCB7xOjK5vlCObtVSyyb9cSafSOAtBvZMOcxiVMg96iI
         yWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tPWb18pzdYP4gepUET+WlF/T7jKUlf4IkvWpJ/7uajs=;
        b=ej2tdRaQK0ravbSDH61SGN2uilRZGROgm+dGI1vWffEDLsFfl6MLUfvjmDtU4IYdBz
         KL5GvCy2J5GbwmERE4GUOp3bNJdKRD6mDikvKiYxuw3sziToFaETlL2luxO7jAnzIR+k
         fQOiljUaOE0TEf1BuEkuc0r4yxl9uhlNVel7msMkCAHvgFhqJ3/rJq0S1xIN2JNzmtHM
         QPRGn65x6bzXHjeQciCFc2KfWHIYwQhXYrHzq74TVIHiXM7hOJBaATcS22DogIpFJt7e
         n6OReMzUEEuWXL0uH7jJ/8cChW3Bl3F8Ecmcc+E2FAXzM8BUuyZFRcjJlx8fZlxfNlYv
         gaGQ==
X-Gm-Message-State: AOAM533NdpeJ5lT1hQTa8atv/P/Bn+yG6dR6vUOkI9mztFSUqNJxGyCx
        YdQubnaAGgPqHQKfCx8ZsXP5MHh8YuGgtg==
X-Google-Smtp-Source: ABdhPJwPi2N4tWTQDbGIqoIjqHoLgu/k7WNG6Bdr/7aD60T2LHSMCLBsTMn1/Myl0ewziNJJomShQg==
X-Received: by 2002:a05:6214:29c3:: with SMTP id gh3mr14425707qvb.44.1638465964664;
        Thu, 02 Dec 2021 09:26:04 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id 2sm266083qkr.126.2021.12.02.09.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 09:26:04 -0800 (PST)
Message-ID: <1e86c2c7-eb84-4170-00f2-007bed67f93a@mojatatu.com>
Date:   Thu, 2 Dec 2021 12:26:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: prestera: flower template support
Content-Language: en-US
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-02 10:50, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk<vmytnyk@marvell.com>
> 
> Add user template explicit support. At this moment, max
> TCAM rule size is utilized for all rules, doesn't matter
> which and how much flower matches are provided by user. It
> means that some of TCAM space is wasted, which impacts
> the number of filters that can be offloaded.
> 
> Introducing the template, allows to have more HW offloaded
> filters.
> 
> Example:
>    tc qd add dev PORT clsact
>    tc chain add dev PORT ingress protocol ip \
>      flower dst_ip 0.0.0.0/16

"chain" or "filter"?

>    tc filter add dev PORT ingress protocol ip \
>      flower skip_sw dst_ip 1.2.3.4/16 action drop

You are not using tc priority? Above will result in two priorities
(the 0.0.0.0 entry will be more important) and in classical flower
approach two  different tables.
I am wondering how you map the table to the TCAM.
Is the priority sorting entirely based on masks in hardware?

cheers,
jamal
