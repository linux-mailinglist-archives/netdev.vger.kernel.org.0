Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C82838293A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhEQKCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbhEQKCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 06:02:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89018C06138C
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 03:00:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id s22so8077861ejv.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 03:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WJNE2Pur46fG7uv1+u/9hia0s0ykMd+z602mYJyefV0=;
        b=OB5oeorVRUK/qUfMJ4Da2aMpGfyYHjZ4FYYGvGyGwpRm4qa7VjBTapqx6JfPkNZnJo
         kh9KoWSkonNp5LIpdAMr6fynOYGdD502gC402MuIbqq/4BaUfpDB6d/kK6Yk31aj0zAU
         XrG2yZk8sUOvC4tMiw6O91t8sXSq+J14QfLvibcKFRw1/Pf0GRvEPVBq94E/q2ylu+JC
         f095yq1FaMPAVILQAWTNN7KHTO7ISM60E+AMNCjoyPrKyI+eovwi9zDZs5mPxEvHzJbj
         QXXrJRtktYOfj0CuzcksoT+RHqxyrquKQpTJG2bNSSBeHcZmknWli/LqXRpWBQ2q0gHX
         wIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WJNE2Pur46fG7uv1+u/9hia0s0ykMd+z602mYJyefV0=;
        b=b4dYu/vochP8QSoaFyMoF27wDIv8FyTM1MbAAcfKfzGLii2HYmj54kPDzlT3+/EfSl
         yM9koGjTDa+Fa1MiIInYT6f4udyk7nbCYMmkLmBjgrQxwWg0219SL5rExfVrBRdV/Sxt
         deHO4SKh2Ee4Mh9s8GlchPISMffsHXBdo8MdocJcOGgyTGtzuiCxA3mJnHBTQ7HvmdeM
         s1Q2JbEL8KwTwV5ifKR3j6VhxnZ1CnIssbjngd3h81pksWFvzNU3VH6bKwrvoWEPD3gA
         l1qiP/XDmvY0cmr8U+4HtYXYjB4awxAl9rRp2MTWwT4oPqF+HU/75WMQyKoBWOFXOILN
         l/4g==
X-Gm-Message-State: AOAM5330rn93V1ZAOtXpm00SCaoPfZiUIYHfcX3UDZtZzJKhP8Xltp6Q
        5Fca0OeeBFXg8EQ11Au6mwlB8kfHwVrB7A==
X-Google-Smtp-Source: ABdhPJzvNkCj/eQGhuaE+a/oxSpakoRoMQmGWLOV3cAWdjX/6AJDb4DL8uKGBpza2xqt6ky3rcCFJA==
X-Received: by 2002:a17:906:9bf3:: with SMTP id de51mr14450347ejc.394.1621245604338;
        Mon, 17 May 2021 03:00:04 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id n25sm10610092edb.26.2021.05.17.03.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 03:00:03 -0700 (PDT)
Date:   Mon, 17 May 2021 12:00:03 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 17/24] net: netronome: nfp: Fix wrong function name in
 comments
Message-ID: <20210517100002.GC17134@netronome.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
 <20210517044535.21473-18-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517044535.21473-18-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 12:45:28PM +0800, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/netronome/nfp/ccm_mbox.c:52: warning: expecting prototype for struct nfp_ccm_mbox_skb_cb. Prototype was for struct nfp_ccm_mbox_cmsg_cb instead
>  drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:35: warning: expecting prototype for struct nfp_tun_pre_run_rule. Prototype was for struct nfp_tun_pre_tun_rule instead
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c:38: warning: expecting prototype for NFFW_INFO_VERSION history(). Prototype was for NFFW_INFO_VERSION_CURRENT() instead
> 
> Cc: Simon Horman <simon.horman@netronome.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

