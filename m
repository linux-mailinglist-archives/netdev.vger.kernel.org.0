Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C085243E390
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJ1OZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhJ1OZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:25:36 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D95C0613B9
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:23:09 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id s1so4459828qta.13
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BWUB1kRBTQemiIus/fr620tetbCUKXPtiJs6G2RpDAQ=;
        b=z4Rh7Y4y3gqeVurGcfgR+B4Tzqeru83kUWN1GFB1xYetPHvHAkQ3CP0WbLgJcdXu83
         rPqmgSzPkGDIopJNJVPI86PHDaJGTZKxTuO00BVXhGZ81ahymRb0lGcTVmNmWSuYWQE4
         AFmgqtlgHQN+w5bjuIRZ05wnTatUBQEsfsLVsNJCxl5iTe1ixKzmsrzshbM0M8z5bMz3
         cA/n/9LpUj/fpRVlfyhCtDJaOz5Fhe4NnPl0bARSgYyweVVqA7QTxUe6Fj8T14HrEo2/
         seaxEr+Vt6RdRV+KIhjuzo/wcyWbOYMzUEDp2RExOPls3Eub5Nxk9bmES8bgE2ZDyWct
         CmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BWUB1kRBTQemiIus/fr620tetbCUKXPtiJs6G2RpDAQ=;
        b=r/aCjLxlEbf/9MxLAw2TXQs/MVKT1abi4D4GLABkSiROi9fakdIRb+Ge1STEm+ilGn
         7bZ/oR69llFse4ehdZ1gR/c5t+vgVXN1c/dkdvF3vb3w8OdGDoW3NcE5RP4dj6Que6T1
         FNj6SvsKVGGiCxTEJITDbKZQc/Wgc7mCIE3s/2itAKBpZMKBbtANg97FzHxywnMclaUV
         zv+B+vlVeZ940x5ggxJFt4u90a02sYKcrKiX9hR9bWBAcA7SHZ5+dt3VpwlP6E2TyFpn
         Y/uyEJorZxQ+nbvGHEGuJn53FTuIC0yvG7Fo9RpOw0lnU5JlyAKD/pBoiHKVqCSCiRxZ
         wmyw==
X-Gm-Message-State: AOAM532Snm5aFKMAhadLN1Ptztq4TwF8ZKt6t/WDbLOmEuCb1YlMAFp8
        EJMqLs6eh6Ckcz3ywVv8MKt6Xw==
X-Google-Smtp-Source: ABdhPJwQ4R0CbITiTy+6SFygY+87MxZ5Yf6ipGL6LNOiHXxilEUm/RP2bE/xdNBoTQYG4HzpKYp4rw==
X-Received: by 2002:ac8:7f8f:: with SMTP id z15mr4994500qtj.148.1635430988911;
        Thu, 28 Oct 2021 07:23:08 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id s13sm2151263qki.23.2021.10.28.07.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 07:23:08 -0700 (PDT)
Message-ID: <e3d4ac96-1d21-bfdd-36b5-571e7c0e7fa8@mojatatu.com>
Date:   Thu, 28 Oct 2021 10:23:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-28 07:06, Simon Horman wrote:
> aowen Zheng says:
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used by multiple flows and whose lifecycle is
> independent of any flows that use them.
> 
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
> 
> Tc cli command to offload and quote an action:
> 
> tc qdisc del dev $DEV ingress && sleep 1 || true
> tc actions delete action police index 99 || true
> 
> tc qdisc add dev $DEV ingress
> tc qdisc show dev $DEV ingress
> 
> tc actions add action police index 99 rate 1mbit burst 100k skip_sw
> tc actions list action police
> 
> tc filter add dev $DEV protocol ip parent ffff:
> flower ip_proto tcp action police index 99
> tc -s -d filter show dev $DEV protocol ip parent ffff:
> tc filter add dev $DEV protocol ipv6 parent ffff:
> flower skip_sw ip_proto tcp action police index 99
> tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
> tc actions list action police
> 
> tc qdisc del dev $DEV ingress && sleep 1
> tc actions delete action police index 99
> tc actions list action police


It will be helpful to display the output of the show commands in the
cover letter....

cheers,
jamal
