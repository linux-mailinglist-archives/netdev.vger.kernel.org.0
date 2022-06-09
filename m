Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62650544F19
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 16:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiFIOar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 10:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiFIOap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 10:30:45 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769E1F89AE
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 07:30:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id bo5so21242271pfb.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 07:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f3+B3/4f/EYX1WyHVwNor7M5aRUmp3PSGvyyEnFuqik=;
        b=Uf0gZWDEqsfPzDO/WoOCeZ9zDaQpoG7mpw39fhVrNd4PT36eVUs/AWQRnJc1PGQy6z
         MxJsCavq8e0r4QA2C5/DW163OyruGXogIMjLQqO9hOiXLcO9KAdDyetG2+YKxTQhKLEs
         2Z2d8kh+Z+YW308jK/76QcgUk6kjZDzT2Hb++SdFAaMfqm1xGDHP/BHFdd3FUq7HYUxE
         8N59xPbFsSOX7aqE9KZ3G0JG1v++Eu9VcU+yovBX8rENqdxOXtKpG9kuVkCEfUv35Ylq
         93P03ULGNI5XIOFC8wrJz30QYpAsVBQrYnTwXdh5W3ycKKateO+O5A+JJHeMY2GkmYv8
         FX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f3+B3/4f/EYX1WyHVwNor7M5aRUmp3PSGvyyEnFuqik=;
        b=Tl8cZnMOPlOsOxspGS0sU02srOOTZrOW/spt5EnYv5qQKH9sluvfojU79x9llVwE+p
         0iBnYewBDQ2hbHVcrnpLPEC+dNd5H4W1QzmhB5BMKEOUeK6Z3EPJmtAJQC99cOLYNf9S
         wHTb6GgX7sMPRoHdYBaTw/ytZdwSiXhTrVcEsERfxpPfKOvZtNmNTBtp2UT4ggvE3lw7
         eWFyzqR3L+K+5r2tpUuM/KNVM0tIavCiEzYH/sxMqKcr1fn8HFnZHuoSFlHQV5SICMN3
         8MlcxZdCWzB9GGbhyTohKp9B2ICfruHka7VJ3lTvquexyVsmwBnfVABnWMMK1bP8WkrW
         f2qQ==
X-Gm-Message-State: AOAM531hCrTny/qQRm4YTXQ0uHTvg3QS8Xw2sbRvIpEalxJFAw5wWXr3
        m0yJWMDrs+KLRZoOHLcZtXioPw==
X-Google-Smtp-Source: ABdhPJwWUD/Bnzq1gZvJJF6L4NnyDUcnw3k9MegfjCLajnnt2E7D2M2H5E8/ChxURaJNbJ6cPyrKfw==
X-Received: by 2002:a62:8101:0:b0:51b:b859:7043 with SMTP id t1-20020a628101000000b0051bb8597043mr40685565pfd.25.1654785042892;
        Thu, 09 Jun 2022 07:30:42 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902784800b001640ab19773sm17226263pln.58.2022.06.09.07.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 07:30:42 -0700 (PDT)
Message-ID: <b39cdb9c-aa2a-0f49-318b-8632b2989433@linaro.org>
Date:   Thu, 9 Jun 2022 07:30:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [cgroup] 3c87862ca1:
 WARNING:at_kernel/softirq.c:#__local_bh_enable_ip
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        lkp@lists.01.org, Michal Koutny <mkoutny@suse.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
References: <20220609085641.GB17678@xsang-OptiPlex-9020>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220609085641.GB17678@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/22 01:56, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: 3c87862ca13147416d900cf82ca56bb2f23910bf ("[PATCH v2] cgroup: serialize css kill and release paths")
> url:https://github.com/intel-lab-lkp/linux/commits/Tadeusz-Struk/cgroup-serialize-css-kill-and-release-paths/20220606-014132
> base:https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git  for-next
> patch link:https://lore.kernel.org/netdev/20220603181321.443716-1-tadeusz.struk@linaro.org
> 
> in testcase: boot
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot<oliver.sang@intel.com>
> 
> 
> [ 55.821003][ C1] WARNING: CPU: 1 PID: 1 at kernel/softirq.c:363 __local_bh_enable_ip (kernel/softirq.c:363)

Looks like that will need to be spin_lock_irq(&css->lock) instead of spin_lock_bh(&css->lock)
I can respin the patch, but I would like to request some feedback on it first.

Tejun, Michal
Are you interested in fixing this at syzbot issue all? Do you have any more feedback on this?

-- 
Thanks,
Tadeusz
