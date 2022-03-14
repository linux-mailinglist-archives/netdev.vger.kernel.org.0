Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE44B4D8A10
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbiCNQmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243826AbiCNQk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:40:28 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D533D1E8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:38:57 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id jx8so12474562qvb.2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2f+k2jhSE7DuvA8WwOwhMdq8MMRNSmHLBplU6ouIGZ0=;
        b=Zni/HnB4ChFLZOSxs+aUXpmCesuhsSJ+tpnqlFyEV850NRyji/Astg7gI15t1LVy2G
         rp1gU3H237S7eSNZnFZO64Xf05dQT3Ovw84yeQIlX85LjuWLEiadI8jdA3to048/PsZJ
         gubMuJJTS8KbY3VNionoWv4l9BuWH4yERCI1NOHYgRqDJ+KCKVgzDhh+E7Dnfy+XluN6
         BufqEIL0YnJTJ5CeMvmSHoutkSdK2TKUp0nR+8F+eNarQsSLd72AmJw0pqI+ofZdES8S
         gIEuDAvDfqVOjSJ7IkEEhLKxyJ0x/5J3CYwPdsiUstU35DMXzhRa0r6uwPHWbqtq2EtF
         cnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2f+k2jhSE7DuvA8WwOwhMdq8MMRNSmHLBplU6ouIGZ0=;
        b=bygBJnPUZh/JkURdQdjAGLTdTlUJC1VZj/6qtgoHs/TUIl8TLGWrAqBogt9frdaC48
         eVfkdakf6lo9b7LaQckeXbG3m9H8rmLkAKnovbJGlmSK9BiL9UAgmIiBclLul9B5WGCP
         9rm1D8z3Ad++SWDPFwM6Lnbd49ApHq+xaX9l+yJrRwLw4IRNFyz6b3EHmWftnTEvyjMt
         HmzlUKAgZUUuyTTITFRB7Rh2d8O1RAZlyzubF4edsb18A+m/4gBD9eqcjVgqxBU7Rg6B
         ZpizD/gUmpXQwrq1Osm0BTCiN4irofNh2wvQ4u/N7cxAv2ZfERlVewAvaoKgM/2XPZVm
         peWA==
X-Gm-Message-State: AOAM530EzD9wUhS3y4jwX5uK1zmPVePw6FOFCCHT4UQiJhqNVTXi0uTA
        zsPqglqWph+B6u4ePdkOn1r9mw==
X-Google-Smtp-Source: ABdhPJycwaHR/KPGxx2wKg6N04mKur5/hBH3sCWmroSdxw7DgQRhvWPwM+aLH9Z+Srxpyj4jr0hn2Q==
X-Received: by 2002:a05:6214:5285:b0:432:e468:a212 with SMTP id kj5-20020a056214528500b00432e468a212mr18276711qvb.51.1647275936675;
        Mon, 14 Mar 2022 09:38:56 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id x21-20020a376315000000b0067d1b191f89sm8150318qkb.68.2022.03.14.09.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:38:56 -0700 (PDT)
Message-ID: <220c7ee3-90d5-bc59-3fd9-16d2d070b930@mojatatu.com>
Date:   Mon, 14 Mar 2022 12:38:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [net-next v10 2/2] net: sched: support hash selecting tx queue
Content-Language: en-US
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
 <20220314141508.39952-3-xiangxia.m.yue@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220314141508.39952-3-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-14 10:15, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
