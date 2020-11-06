Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8FE2A9271
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKFJYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgKFJYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:24:23 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D20C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 01:24:23 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id x20so496871qkn.1
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 01:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rsUq3mjhDjY2VoujXVIXpG1O4aqIK/QbGWtOKJXDTVU=;
        b=SYffHKY7io7q4FNHBDmlfjLZAKdsr5WeFLpP9WFvuvYk5wsRNJaGk90RwU80krCpal
         ktTjElSGMJK/yr98Gjdrd55YRmqVvhWPmftqE1QacjhoKf8cUMhxXG/7OqWBbBfjGEbt
         KfrcrFN4ZISSwvLFMNdLAm2IEarWyFRz2sMa2HApg1EXVdc5txAOPkFqLUaDBTplVIoo
         sMV+lzOiihv8fVUwaEd9CjwUJKtUoAIe0TMqyxDdGPZGC+sjtwrlPFYf+TS6EbvfEOuA
         c5BkM23lik4jj/5JsyFT4cJFv+y7XjiFG1QNlTSeFS63V3IXFc52o+RZ5K8VJ/n0Cevr
         0+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rsUq3mjhDjY2VoujXVIXpG1O4aqIK/QbGWtOKJXDTVU=;
        b=fqcFJEnj65HTOpvDR6NDVBGbRIFi/Ph4j75I6ZgXCuxJS6TWhAlxEN7IafwP7tGLag
         LuDalhIpOhHpfIxsrjqWga1xoJDYeWmUVu2EPhmuygeR09qjc8yYOlcO3ua4lPdqfQqt
         eEoaqUlVtb6PVy3asStBc1uW9pWfIB5WE7YDKE0/UEtpTWbrBp9+odPOYhM+jhk271s4
         +xJaMCAY5/fHI2YzYgvJHnYrraXoC3eu355VxECiSxzB65SmZoStRbo2vgouWQ66xvZs
         AAFB/XzvHeuHQotWQ//EUIftXRwQG6nlrhMtL0YCj221E8CfDQOshbnKQSz1Fm+6KO83
         y93A==
X-Gm-Message-State: AOAM531MnzmEJmyNiK6RgwUEM6iG6/APwgNKypRKqp53UDEa0n22IaFF
        +hJ2Fxab9FXs5KrRvBtxtVxs57gYv96EJA==
X-Google-Smtp-Source: ABdhPJwYTtCvtsF0k3gX7V6QegcfgSaSn0A9/rWe5qawsdwfg3nwfZIEIDoYj0UVq+k0OAAuakaH5w==
X-Received: by 2002:a37:4f0b:: with SMTP id d11mr679453qkb.74.1604654662481;
        Fri, 06 Nov 2020 01:24:22 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.74])
        by smtp.gmail.com with ESMTPSA id a3sm243672qtp.63.2020.11.06.01.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:24:21 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9BF70C1B80; Fri,  6 Nov 2020 06:24:19 -0300 (-03)
Date:   Fri, 6 Nov 2020 06:24:19 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, dcaratti@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201106092419.GB3555@localhost.localdomain>
References: <1604654056-24654-1-git-send-email-wenxu@ucloud.cn>
 <1604654056-24654-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604654056-24654-2-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:14:16PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks wenxu.
