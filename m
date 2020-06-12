Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777741F7FD3
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 01:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFLX4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 19:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgFLX4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 19:56:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7649BC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:56:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s135so4187506pgs.2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UTj5ttub5IuanqJwK0I3UQOz9/e75GCyP9mAZ6g5FLs=;
        b=iIV5M4TJ+hm1p8LSUgYD3Ct5YANXR21bo7WVabVYarAxz4YLt8cgczYfHY3q4KHiAe
         jvhw++B/13tLctvWoaLqQj6hOhY0wqdiVnbwSjksqRC2KKHE7oGdId50G2jJKITuNaDL
         bCgOScFHg5tQ3jbNZcyi4/Z298BrF8MA5IpaY7bRLetLUFmeB6ImDfygu9i9x6VeduVT
         mxgjaBE+mOmFv+N7+n5a/DKbFRoSDITkD1pK5cfK3VT67e4ouJxmOCVR7hhGjJvkoRRM
         a2601xXx5InQC3KqdEH6qkNr4JK4wkKe/h8s+x7DiPqjsLH7aKPK391McP2dN2Bb6g6Z
         6lEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UTj5ttub5IuanqJwK0I3UQOz9/e75GCyP9mAZ6g5FLs=;
        b=E4UzJ1bcWhrNckzIRJaIUR8QVriapwK2IEDhI5YnR1KS8nc7T3rWAeReG1Ole45gYV
         zVzD5PSgNiiWy9Ehi3dcHfW4SarDbDV4DVx3p52ywWU5NgXbgbovR56fg2tWNpm0IDEh
         MLlCMgZfLevXSQSNM0+Bsvx49VVAhxz4qCkMrff98mnUj7aPBrR8CNn/sWA9yTz8kxSS
         l8RKofxX3I6gkkVQSnUOBFzAzRQYDG1zZBKSX6XhaIfnGLRlRc7KnHzGcEJ3VGdOhnqI
         lqY4ZBwDe+OATjAQwKUv4GC03EQnnxTtoAudKt1qbHcuf7RVCQ/jFCf5Xdb5RKF1chf+
         WSqw==
X-Gm-Message-State: AOAM530tcd1Qg9imx9y3qsZPCOB0sjqnIjBEtA1VEMyz8NZo+vETM2MC
        DsXN71jYVIFgqkKEXwLugKY61g==
X-Google-Smtp-Source: ABdhPJzm9lYOU0JJR33QzS+IfpMfTHPWNnrJDkJrsN53U/PS/yuYCTlJcVtkQp/lWvhGuXRK7sdVTA==
X-Received: by 2002:a62:e81a:: with SMTP id c26mr13887109pfi.281.1592006193695;
        Fri, 12 Jun 2020 16:56:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m12sm6348326pjf.44.2020.06.12.16.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 16:56:33 -0700 (PDT)
Subject: Re: [RFC 1/8] docs: networking: reorganize driver documentation again
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        klassert@kernel.org, akiyano@amazon.com, irusskikh@marvell.com,
        ioana.ciornei@nxp.com, kys@microsoft.com, saeedm@mellanox.com,
        jdmason@kudzu.us, GR-Linux-NIC-Dev@marvell.com, stuyoder@gmail.com,
        jeffrey.t.kirsher@intel.com, sgoutham@marvell.com,
        luobin9@huawei.com, csully@google.com, kou.ishizaki@toshiba.co.jp,
        peppe.cavallaro@st.com, chessman@tux.org
References: <20200611173010.474475-1-kuba@kernel.org>
 <20200611173010.474475-2-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d9437e4e-f588-320e-2673-cd67795779cd@pensando.io>
Date:   Fri, 12 Jun 2020 16:56:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611173010.474475-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/20 10:30 AM, Jakub Kicinski wrote:
> Organize driver documentation by device type. Most documents
> have fairly verbose yet uninformative names, so let users
> first select a well defined device type, and then search for
> a particular driver.
>
> While at it rename the section from Vendor drivers to
> Hardware drivers. This seems more accurate, besides people
> sometimes refer to out-of-tree drivers as vendor drivers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: klassert@kernel.org
> CC: akiyano@amazon.com
> CC: irusskikh@marvell.com
> CC: ioana.ciornei@nxp.com
> CC: kys@microsoft.com
> CC: saeedm@mellanox.com
> CC: jdmason@kudzu.us
> CC: snelson@pensando.io
I'm fine with the Pensando ionic changes.
Thanks,
sln

Acked-by: Shannon Nelson <snelson@pensando.io>

> CC: GR-Linux-NIC-Dev@marvell.com
> CC: stuyoder@gmail.com
> CC: jeffrey.t.kirsher@intel.com
> CC: sgoutham@marvell.com
> CC: luobin9@huawei.com
> CC: csully@google.com
> CC: kou.ishizaki@toshiba.co.jp
> CC: peppe.cavallaro@st.com
> CC: chessman@tux.org
> ---

