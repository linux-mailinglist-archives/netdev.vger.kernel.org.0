Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF64654174C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377144AbiFGVCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379232AbiFGVCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:02:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FA736151
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:47:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so16190542pjt.4
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ClvLn1v0KW5jcy2W1CElCvPJ8/3zjMIv2rSPG5d3wcg=;
        b=tc1I+sdA0FwDJ/gsRcalhTdWIHb3oeBmUEKkK8g4OZEMjXtAlRTZvaNhHDSk/3+9Zf
         ZCnTm71Ikwc9fj78Z6tJ+r+s3NKyZPGXQUM5GKc63uB2wcSoTM+yHLH1Ir/Fm51e9ot0
         iPOjiMnofGcQT1I4z3zOljtH0zbFxSybwkGC8Uh8OTfQAgLL0VB/fu8yQm7VfTWTj1iK
         ViabI4/ZPV3krTjB9RtlTrwxbRjkqxfKSGqc7GY05gqlqamDH4sYLLUCxRq+Tg2RE6e2
         AQwMtPhyN/4yV7ZESuVPupvYQ3xLbWu98R4sqW9Vc3joiZka92axUvzIDfM/7JpyJlSZ
         AErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ClvLn1v0KW5jcy2W1CElCvPJ8/3zjMIv2rSPG5d3wcg=;
        b=227KLh5GZ8KWO/sAJRVYNSScTUets0EqzQBzhs7n626fFtErfNh4haKubSeSVljBqT
         yPtMXxDyzVsqfLZYtOpxCDdyhGq+eNJns+uLxf1WTYoIAn21MUtIkLDA2S3Gk2OaTcNw
         ohnRyQm4/eC5MtcTXZ6dQbD6vE1MPQ1dAvFx2EWwfVzyTI6oDVXuNHnHDypsGk3WFZJO
         34dmmgFIRzHkBempdAz8cV4E4OYbn5I8MZngVuEva247fzugVKPSfACDCpqxXgcBuRgt
         aeYMrnppniUFJemLhCHN9B+BpYAMNZfCoWLAA5MeknGgbBIqDL+wcRAf+85EyxPpe5ay
         MdYA==
X-Gm-Message-State: AOAM530r6XQ93wrR9P8P6DltSVH2l5/gViyAo5bSABmagDLB6fPYgJwQ
        bSo/cB2ttIeMIkHLCebkA7K2LA==
X-Google-Smtp-Source: ABdhPJzC+jPXqON9HpNHUt08r2bqtxWHt/ITCvwKc/1nQ9S2LBfu4fKx7HHimoSJfCLrrW0kyL4vcg==
X-Received: by 2002:a17:902:ec92:b0:166:3502:ecb1 with SMTP id x18-20020a170902ec9200b001663502ecb1mr30357875plg.62.1654627621789;
        Tue, 07 Jun 2022 11:47:01 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902710200b0016141e6c5acsm13036791pll.296.2022.06.07.11.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 11:47:01 -0700 (PDT)
Message-ID: <d079b7d4-c538-8a50-3375-fab0d3a0f0e6@linaro.org>
Date:   Tue, 7 Jun 2022 11:47:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
 <20220603181321.443716-1-tadeusz.struk@linaro.org>
 <20220606123910.GF6928@blackbody.suse.cz>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] cgroup: serialize css kill and release paths
In-Reply-To: <20220606123910.GF6928@blackbody.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/22 05:39, Michal Koutný wrote:
> On Fri, Jun 03, 2022 at 11:13:21AM -0700, Tadeusz Struk<tadeusz.struk@linaro.org>  wrote:
>> In such scenario the css_killed_work_fn will be en-queued via
>> cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
>> cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
>> cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
>> css_release_work_fn for the same css instance, causing a list_add
>> corruption bug, as can be seen in the syzkaller report [1].
> This hypothesis doesn't add up to me (I am sorry).
> 
> The kill_css(css) would be a css associated with a subsys (css.ss !=
> NULL) whereas css_put(&cgrp->self) is a different css just for the
> cgroup (css.ss == NULL).

Yes, you are right. I couldn't figure it out where the extra css_put()
is called from, and the only place that fitted into my theory was from
the cgroup_kn_unlock() in cgroup_apply_control_disable().
After some more debugging I can see that, as you said, the cgrp->self
is a different css. The offending _put() is actually called by the
percpu_ref_kill_and_confirm(), as it not only calls the passed confirm_kill
percpu_ref_func_t, but also it puts the refcnt iself.
Because the cgroup_apply_control_disable() will loop for_each_live_descendant,
and call css_kill() on all css'es, and css_killed_work_fn() will also loop
and call css_put() on all parents, the css_release() will be called on the
first parent prematurely, causing the BUG(). What I think should be done
to balance put/get is to call css_get() for all the parents in kill_css():

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c1e1a5c34e77..3ca61325bc4e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5527,6 +5527,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
   */
  static void kill_css(struct cgroup_subsys_state *css)
  {
+       struct cgroup_subsys_state *_css = css;
+
         lockdep_assert_held(&cgroup_mutex);
  
         if (css->flags & CSS_DYING)
@@ -5541,10 +5543,13 @@ static void kill_css(struct cgroup_subsys_state *css)
         css_clear_dir(css);
  
         /*
-        * Killing would put the base ref, but we need to keep it alive
-        * until after ->css_offline().
+        * Killing would put the base ref, but we need to keep it alive,
+        * and all its parents, until after ->css_offline().
          */
-       css_get(css);
+       do {
+               css_get(_css);
+               _css = _css->parent;
+       } while (_css && atomic_read(&_css->online_cnt));
  
         /*
          * cgroup core guarantees that, by the time ->css_offline() is

This will be then "reverted" in css_killed_work_fn()
Please let me know if it makes sense to you.
I'm still testing it, but syzbot is very slow today.

-- 
Thanks,
Tadeusz
