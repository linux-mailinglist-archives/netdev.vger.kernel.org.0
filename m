Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99961D4D0C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 13:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgEOLvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 07:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgEOLvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 07:51:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1303EC05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:51:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u16so2323391wmc.5
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=axyZ5wldsKTXtInavIN0jtBlTbsZnvEhxrS9OcB/ses=;
        b=d4YBuuS0p6nZDCVdm9u44ndgnozTfHpkn3kNksaPT6L4EYPComDt20HgJCFU8e+ue3
         M+LLJAQqUuFgrGjBI6QRCHvO3Cwwy2BIfkl3PjFKiesQYiA1Q9GxCiLq/ItcFVMcrlYC
         pCKrzze9W+4vmvi1Z6PmjsugxxyyE/aDeeiJifDiWGL3Z8JFv8qU6Y0gy41QlD06MwNJ
         QYvpbEli8q2WUrLJM398duxP7xzEc13ZWVb6vY+gbuw++mRSi0h8ESce5UasOCqAO6z0
         Rf5GglM2DbyKBHR9WncVfWme9e9UH0nVEFiUTI6q84oxiCb+lr4vWq+e6fZN3C8Sp04J
         sZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=axyZ5wldsKTXtInavIN0jtBlTbsZnvEhxrS9OcB/ses=;
        b=rG+mpITbAiXM+ggxbbeboepaLSCE7Z9CzAwRCugYyMUEeClTQ5wop4zoidPYkKUvyZ
         0BGzZddCx6pz/KQlHLgiIsOzw2D8OZknEiwYZi7vZeNmKzBz6bNSy2ckjgQHsh5CUqd0
         oTyvaQohReX7EOPLkKfrQsMgUDwG06RlYzMNFnFU82hYePjM/XZ9JszMRH4x3IXxU2+R
         lK4JquRKa621DzfnGeMAjzXPknhMo82mhNy7FyflG9Os20l2f2us0JlmRpWxSlLV2n6e
         I97abpO2vsBbNaLpxLT+NdM8u2jxwx0DfHEyp5UPJwn+vSbS3K0kLBqQY2tVMPvN09JK
         GkcA==
X-Gm-Message-State: AOAM530HhvAzWZxmkA+76oxAvg31SUDtNLtUqyHQY9d3TadqeV6UZ0eE
        L9Yhjr/qVSOetW+escXWWIowOg==
X-Google-Smtp-Source: ABdhPJzsEYKxNwCOFXb2Y67TjCX3xiBzMRQL4oO3grW5fp0Yv3gl1ye/4wYUgVBA+h2nIxdMaeKorA==
X-Received: by 2002:a1c:cc1a:: with SMTP id h26mr3499000wmb.127.1589543467762;
        Fri, 15 May 2020 04:51:07 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id q18sm3177852wmk.28.2020.05.15.04.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 04:51:07 -0700 (PDT)
Date:   Fri, 15 May 2020 13:51:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, dcaratti@redhat.com,
        marcelo.leitner@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next v2 2/4] net: sched: implement terse dump support
 in act
Message-ID: <20200515115106.GG2676@nanopsycho>
References: <20200515114014.3135-1-vladbu@mellanox.com>
 <20200515114014.3135-3-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515114014.3135-3-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 15, 2020 at 01:40:12PM CEST, vladbu@mellanox.com wrote:
>Extend tcf_action_dump() with boolean argument 'terse' that is used to
>request terse-mode action dump. In terse mode only essential data needed to
>identify particular action (action kind, cookie, etc.) and its stats is put
>to resulting skb and everything else is omitted. Implement
>tcf_exts_terse_dump() helper in cls API that is intended to be used to
>request terse dump of all exts (actions) attached to the filter.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
