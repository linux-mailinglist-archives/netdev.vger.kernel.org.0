Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D78224D7
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfERUaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:30:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36472 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728435AbfERUaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:30:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id a17so12024351qth.3
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 13:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jL1rX7TiZxWpbBkMCsDkZrfxNP1FHEXVrf/hK+LluYc=;
        b=jqmiRrYZasqJ1mNbWn7kYTQcySb2hjXh2HsFAhBTHTz7r5pcfMHeAbzWpI7+vDgJcD
         JAHfi3BCULVRBGIlWM9b5p9XmpgGKor8RALP3OyBbBSw4TpD5gmPE3xrak9ccahlJt8g
         Zh6W10tWGrNwyQ9KWIvWOu54d6YMCmeF2uk5wGJZjbrT7U+QKxr8Llp6spEipAdqULfj
         yXT1XHtdUDBvtradOoE4/i8gwhBNQGhxRBFwJXKAvoxJbMvHZysHAKLUR4wLQJLYLIup
         sed/8B8GRBQdKjK4BbWqhxLidwMxeUE0WNC45qV4TIPGJdQtrLAyCJhb4iiFMwnoNfZF
         WU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jL1rX7TiZxWpbBkMCsDkZrfxNP1FHEXVrf/hK+LluYc=;
        b=DsyNCCahxstrWunohfKdl7t5LqayyXs507+ySW/7NfJo2zVyU3YpFGavH62Z9nAzyq
         blhS9ihLTZxgxwdHiiYDlJ+Rm1CYInZ76QQPaBdOf/yuuyw70FFrOZfLLJGjN2ShpDoj
         2ibAQqV90OBdwqJ7qcFRxElGLw8CiP3s8xzgU8xCbH5l0UgT7MLXlaHx4UGDquqSuZ82
         QRx4y13wApJ2NbStAvAnel4TDPSGlW5pvRuBD+P3aJsO+UgXzXdXF5drcawckqrDfu9b
         z+Oz9aCcTxLAFzopU/AxRweMON/kQuTiA9ECkLsuWYqP0YBuxfwwUG1Al5dUrNHivXRY
         hiPg==
X-Gm-Message-State: APjAAAUO7HjMINMhuI89Mk4KsszsyONubBAZX8R6uqSyJDZkm7+9FCNJ
        X5mGYF5/9CM5S4AOeVFKcisaMQ==
X-Google-Smtp-Source: APXvYqz9LT6jEy2nVnr874mauQelwqpSLEeG5raEGmPcJNb+kPpWZzfxiaAjQULQh4l848XDvM5oZg==
X-Received: by 2002:aed:2307:: with SMTP id h7mr54547856qtc.87.1558211411959;
        Sat, 18 May 2019 13:30:11 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id l47sm6785428qtk.22.2019.05.18.13.30.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 13:30:11 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e987ec07-01f7-ee71-a535-420c924dc923@mojatatu.com>
Date:   Sat, 18 May 2019 16:30:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-15 3:39 p.m., Edward Cree wrote:
[..]
> 
> A point for discussion: would it be better if, instead of the tcfa_index
>   (for which the driver has to know the rules about which flow_action
>   types share a namespace), we had some kind of globally unique cookie?
>   In the same way that rule->cookie is really a pointer, could we use the
>   address of the TC-internal data structure representing the action?

tcfa_index + action identifier seem to be sufficiently global, no?
Then we dont have a mismatch with what the kernel(non-offloaded)
semantics.

Note: The kernel is free to generate the index (if the user doesnt
specify).

>  Do
>   rules that share an action all point to the same struct tc_action in
>   their tcf_exts, for instance?

Yes they do.

cheers,
jamal
