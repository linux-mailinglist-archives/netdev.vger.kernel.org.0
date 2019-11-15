Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B73FE149
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfKOPcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:32:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37962 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfKOPcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:32:51 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so10881825wmk.3
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 07:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=msmsHM9pnmEBra9i71Uio8uDYTiTbC41UQN7VkfbC9c=;
        b=zEhABvCubwZqrU6fqQTMS1WNUO+kGn5Znt01YJOgwtEEz4Yos6a/fLY+t+pIpGsq9r
         0PbsAqFbVrm+6zTjAWs/fHrTEXOkdz9eucB7pYxGNLP/2HSUFfgg9v2sJ/7cdHQd97VA
         20WeXf2rJkb/lNoTbxVI7z2rtokZPrFXa/4XvCkqrwiWsQ1yHIyb2DBg9sgYnxZ55GPi
         wR1KTbm3tPJm2yCGMyywJqm+LWpQfaHT/ih1TdsIGd4T5FEij3npeRFdSoaNrlqKGDht
         skin1WfeGrhbiz4e0QSUXlYqx4O9wBYWSU9bz6W6LpT2/9HzxZav+yukZTVgzXxONZos
         v6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=msmsHM9pnmEBra9i71Uio8uDYTiTbC41UQN7VkfbC9c=;
        b=Mb7lvUog300X6YqoXXqZk8N/tLK5FaAjlpDDEFxeR5qQW9O+k0swRFGRXlDV7UwWiH
         HSA6/3IRx3e0Ocjpk/W4k6AUBAqsPK8ErT/d3r3WOvGX/4XyjgsblIV4RecnbbiJNu8r
         RbWMmD6xf9ieqk3ieNFewnMYbrGAuOI0gSr1ib4wH6Xsgo5ZUv6yFT43JwcYP+MHeQ8d
         ZwuaiTisN2WNtl5Yqsd22y9mvVTeHyb43wtWKs3tNKq3Z4UrG53bC6kP/Ujl5mb4NZ9t
         tG41JLnhuIpJHewp46dOLUINn4z9BT47PPplTJGxs9WwDc6psdqiu0pDEVI9YaUvMcTR
         RIaw==
X-Gm-Message-State: APjAAAVtVwTyHzIfys66RrboaqVrqlPoRfPMfjq0fPfWL8jZHxy3KPLG
        VztoDD4ZFaK45NOOKSOm/fft/A==
X-Google-Smtp-Source: APXvYqxTFEWe3bbf8NqoJ9/sMB75KnU9n3kM+ULfolAwXuuyQGHaZVrmNjkwRO/MfmMb+rg8SBG3Qg==
X-Received: by 2002:a1c:6588:: with SMTP id z130mr13965325wmb.87.1573831969022;
        Fri, 15 Nov 2019 07:32:49 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id v9sm11400361wrs.95.2019.11.15.07.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 07:32:48 -0800 (PST)
Date:   Fri, 15 Nov 2019 16:32:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191115153247.GD2158@nanopsycho>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
 <20191115135845.GC2158@nanopsycho>
 <20191115150824.GA14296@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115150824.GA14296@chelsio.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 15, 2019 at 04:08:30PM CET, rahul.lakkireddy@chelsio.com wrote:
>On Friday, November 11/15/19, 2019 at 14:58:45 +0100, Jiri Pirko wrote:
>> Fri, Nov 15, 2019 at 01:14:20PM CET, rahul.lakkireddy@chelsio.com wrote:
>> 
>> [...]
>> 
>> 
>> >+static int cxgb4_matchall_egress_validate(struct net_device *dev,
>> >+					  struct tc_cls_matchall_offload *cls)
>> >+{
>> >+	struct netlink_ext_ack *extack = cls->common.extack;
>> >+	struct flow_action *actions = &cls->rule->action;
>> >+	struct port_info *pi = netdev2pinfo(dev);
>> >+	struct flow_action_entry *entry;
>> >+	u64 max_link_rate;
>> >+	u32 i, speed;
>> >+	int ret;
>> >+
>> >+	if (cls->common.prio != 1) {
>> >+		NL_SET_ERR_MSG_MOD(extack,
>> >+				   "Egress MATCHALL offload must have prio 1");
>> 
>> I don't understand why you need it to be prio 1.
>
>This is to maintain rule ordering with the kernel. Jakub has suggested
>this in my earlier series [1][2]. I see similar checks in various
>drivers (mlx5 and nfp), while offloading matchall with policer.

I don't think that is correct. If matchall is the only filter there, it
does not matter which prio is it. It matters only in case there are
other filters.

The code should just check for other filters and forbid to insert the
rule if other filters have higher prio (lower number).

>
>[1] http://patchwork.ozlabs.org/patch/1194936/#2304413
>[2] http://patchwork.ozlabs.org/patch/1194301/#2303749
>
>Thanks,
>Rahul
