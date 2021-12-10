Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3046FE4B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhLJKCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbhLJKCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:02:05 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D49C0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:58:30 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y12so27593441eda.12
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nduhBFxPbxmifYpnO0eOOP3C7nxBPTbeIwjsdCqiSCo=;
        b=ojvvj0K+k6NKnozWLW2tDWy91766MZb9YsUkZZD84yq8yaH1DnzCgRGc4zW9CR+Z3E
         2vs+BSinUml6Qjyb0MbBrOgsHOui0a02cPy0cqrIUgGcPho1kK21Vv6AOKU4syfzyGr6
         ZSM2KKARJ2O3WXBsrc+VrUfgJgi8GAHaVHe2HKB+OvOoTqxMHIykUz6SEjjyVYLDofUT
         4tkWQHYJ8a7xdoQKOL1TGvS9bCMzyhfSxCNiEPqsSQMJYT0YND2DBanJfy4thrcjQpsv
         NGVyKnbVO76+lE4LNwOMA8eTPqYUhFTsWhY12krSk4lNc2nU/54euf2N4eePg1MzmHYj
         PSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nduhBFxPbxmifYpnO0eOOP3C7nxBPTbeIwjsdCqiSCo=;
        b=uySJYK6BSUcrBPqxbjnEMj84/Yex4Z33xrW1QNitH5p18hPJqLCohlXB9N/vcVrVnL
         a8s17ms93vEvYFtNFKBQD0Hk/9lbuC+sPHnL0jRB6sI4eUKoXQ3LaJP7OZcMDYzC+pHL
         vckOA70nRYwgKlQoDbL8ocaO2dMcC9KvW6pz8I90a7s91aUm8SSB2Uu84rCJfMm8luxY
         xP7ThZCjtGTOBsSiw14axZd/9bqarRJVpL/PBt4Ra43xXg1qvpNVYKVnnnxs4QD7MSn3
         OCaE7G24HQgs1qLyuMFivDW75urtar1vRMeaxO5DWRUaUAyjgYGOmCX+xvrhJXwwUP9d
         RVzw==
X-Gm-Message-State: AOAM532MTJFEkUA/x9kxImyRxwnLTnulMQnl9D5NnCkw5Xv7h2wFziea
        PimREpOG/iNL4JRXxEGm7hdRdg==
X-Google-Smtp-Source: ABdhPJylHws71T7EEEhue6UdCGoV/k4VWRPPxYHA0zXkEHzMN0zoHH6zuGQNrntdBPyvVA4MsSkOUQ==
X-Received: by 2002:a17:907:7f2a:: with SMTP id qf42mr23268059ejc.388.1639130308873;
        Fri, 10 Dec 2021 01:58:28 -0800 (PST)
Received: from [192.168.178.33] (94.105.100.208.dyn.edpnet.net. [94.105.100.208])
        by smtp.gmail.com with ESMTPSA id co10sm1129754edb.83.2021.12.10.01.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:58:28 -0800 (PST)
Message-ID: <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net>
Date:   Fri, 10 Dec 2021 10:58:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in mptcp_inq.c
Content-Language: en-GB
To:     cgel.zte@gmail.com, mathew.j.martineau@linux.intel.com
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ye Guojin <ye.guojin@zte.com.cn>, ZealRobot <zealci@zte.com.cn>
References: <20211210071424.425773-1-ye.guojin@zte.com.cn>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20211210071424.425773-1-ye.guojin@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ye,

On 10/12/2021 08:14, cgel.zte@gmail.com wrote:
> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> 'sys/ioctl.h' included in 'mptcp_inq.c' is duplicated.

Good catch, the modification looks good to me:

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>


This patch is for "net-next" tree as it fixes an issue introduced by a
patch only in this tree:

Fixes: b51880568f20 ("selftests: mptcp: add inq test case")

Regarding the commit message, please next time include the Fixes tag and
mention for which tree it is for in the FAQ [1], e.g. [PATCH net-next].


@David/Jakub: do you prefer a v2 with these modifications or is it fine
to apply this small patch directly in net-next tree?


Cheers,
Matt

[1] https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
Please check the "How do I indicate which tree (net vs. net-next) my
patch should be in?" section.
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
