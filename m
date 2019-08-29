Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C58A14F4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfH2J3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:29:47 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41323 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfH2J3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 05:29:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id j4so1950297lfh.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 02:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xEpqtvyFowtYwzdZhWU2D4NJXBGmsv51ZqWkEO2xOww=;
        b=liqOsmrCHrZcLemQXLTPjn+SNMv71Zp/PmxCMTDC5qeDHFQjLczv9vNpUJfPw2452T
         iSoO7Oc1gNTmX/zKYiuUY+GkeH0O+8w+beUaNtuuEE7m+PVIHPtH2x8/hpmJBv0IFXjy
         ehQRgUkCvPUsFqqE9SlkYTld/2ShRZ4aXiyjLXMAahfKqQfhNHkuvPn2/Uob2IlEnaCg
         j2zwDtyjIS7gyn0qiEnxMlItSZrZ39O678X9AB6mWC91M/fvsfeHTlJqgVCp0d6k/ctg
         6+OGExWLFXKeNxuyLZUHqDh4lLwO0gUlrS4PEITZfPKAlYAiHLVFLeUlMR64d6aovS9i
         fhrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xEpqtvyFowtYwzdZhWU2D4NJXBGmsv51ZqWkEO2xOww=;
        b=iJdkWYcoEY2zrDwnYIfQQVXVTyu3oSkEkN1jlgKb569uPrM3CvCMDVMr//CPk+k3Rx
         Uh6VMmxhFfoHp2ZDO8S/XMX6hz51Miqv+iJ/6OlexRG/zWPod2Gb1hJQIqRiuRZcsG5r
         m8cMAhhDRDb4bBbAtTZ2s/zEDTec+NPLdq6ZrotoUua1T49+ccE5q3CNYh/uFdUkVRNm
         SmJaLog+tf5GzKh0y/zlrujIGCpyji+Pxa4Lal57V7zdoncBdHJSwxD5jhqdXAV/+HiV
         eQ8sGoSrIDD7w7Rn6w9zOEFOhJAbRQ8IkwP+xs3StvhqlUB2KwBKl5XiwmNAO8pe9wdR
         c2ew==
X-Gm-Message-State: APjAAAVx+PmGpnjKHOpZX89Ot5YUUN/zlF1aOK8UfLLQlrSXFe24Xw8r
        wRkvE7gqe3w6lLhdQqIFu9hvWa7YDug=
X-Google-Smtp-Source: APXvYqxw6vp6IdNMgO5m8ofhQXuv0kRgqjxkWw/FFEUNFLPL1ruGZaf1GvuswagrjnUV56FMyeXt0g==
X-Received: by 2002:ac2:51d0:: with SMTP id u16mr5557146lfm.178.1567070984114;
        Thu, 29 Aug 2019 02:29:44 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4802:c11c:a18f:64dd:fe6:aedf? ([2a00:1fa0:4802:c11c:a18f:64dd:fe6:aedf])
        by smtp.gmail.com with ESMTPSA id w15sm263677ljh.29.2019.08.29.02.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 02:29:43 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Move local var definition into
 ifdef block
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, saeedm@mellanox.com, idosch@mellanox.com,
        tanhuazhong <tanhuazhong@huawei.com>
References: <20190828164104.6020-1-vladbu@mellanox.com>
 <20190828164104.6020-3-vladbu@mellanox.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <365fea71-4f35-188d-89e1-d8b97e3df141@cogentembedded.com>
Date:   Thu, 29 Aug 2019 12:29:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828164104.6020-3-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 28.08.2019 19:41, Vlad Buslov wrote:

> New local variable "struct flow_block_offload *f" was added to
> mlx5e_setup_tc() in recent rtnl lock removal patches. The variable is used
> in code that is only compiled when CONFIG_MLX5_ESWITCH is enabled. This
> results compilation warning about unused variable when CONFIG_MLX5_ESWITCH
> is not set. Move the variable definition into eswitch-specific code block
> from the begging of mlx5e_setup_tc() function.

    Beginning?

> Fixes: c9f14470d048 ("net: sched: add API for registering unlocked offload block callbacks")
> Reported-by: tanhuazhong <tanhuazhong@huawei.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
[...]

MBR, Sergei
