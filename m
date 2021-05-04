Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E923372ABE
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhEDNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhEDNPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 09:15:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DA2C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 06:14:42 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so4841136plf.12
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 06:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition;
        bh=hYscccQtInzVIIE3wPGEE1nZ7KxAq9jPIPkgq2j/trs=;
        b=HRX5zq7Gq2iBjWFjbUWqXm7P1956Vm4gvxsYgz0jqKIV6S81bFf0aade4+heGddAZr
         ijn5z30PjLa/qjLaG1Kp/ki9BzBeZUMihVtkvR1QJ/ln+nmb0ub1nPrFLTJn77gs+U8n
         r1IhnsHS3vymuF11R+qRy9oRuFndd8yCA1AIRT/eDly7ZR9EwW8TR80f/pKJKNaMU/eN
         R+OPXhNWJMsVQl4vNhGzMy2vUYy62SnO7lZPTB4+fCpYdDxwEA/QXXyQMehlsL+ZdnNp
         kzK3f2JT+fJSFZlclfvsYMhnemdHta+KhnGy71+DzsnCntHOnS8gwNc3BYphhNmLrXgg
         X8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hYscccQtInzVIIE3wPGEE1nZ7KxAq9jPIPkgq2j/trs=;
        b=mjL644AW/irPHLXqAHgxOEOS17pn1p4oxN7HRcd63wWzq9M/lZbxhmhRpQWQK28DEo
         9FMNPo/94RGtcAIvFdK5EMW5J5FHeutLYzt+q7+J43XBOdhiQWmab37PmGWyT5nrMXM4
         oPiB+FA4YEtFnWNyGQSshVwnWyAJg8BOJLMTDNKUaOchkGOka7l4AuUJMk/vzvkWc2Lb
         bqGEcpwkWbQidqsFJKmglTWaW32U75gEXzZ7evtxkcoA9BGzqB0DMZ0xYVUnyGRhPqkb
         3gn50JSCq/u/Hlw6VbWCQpdXbfOn12JSUXT0JSV/xUI0ijz8tmFYTi547NhgYogdkOH+
         dCNA==
X-Gm-Message-State: AOAM530JsCZ5xgr5mjnPch8ECTfd/AcE0JsH85x0yswzWiQ2ef5V43oT
        5IqnUOpk7iURaRMBwqHmx6M=
X-Google-Smtp-Source: ABdhPJz5LBUBq53amifXrFCb/w4Kxz8itORUiH/PcMkI7+lGItgFFfpX15gQ7YR8uATT6IiujZsYmA==
X-Received: by 2002:a17:902:b095:b029:ed:46af:e33f with SMTP id p21-20020a170902b095b02900ed46afe33fmr25667553plr.23.1620134082230;
        Tue, 04 May 2021 06:14:42 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ls6sm3418572pjb.57.2021.05.04.06.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 06:14:41 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 4 May 2021 21:14:21 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <20210504131421.mijffwcruql2fupn@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

As you have known, I'm working on improving drivers/staging/qlge. I'm
not sure if I correctly understand some TODO items. Since you wrote 
the TODO list, could you explain some of the items or comment on the
corresponding fix for me?

> * while in that area, using two 8k buffers to store one 9k frame is a poor
>   choice of buffer size.

Currently, LARGE_BUFFER_MAX_SIZE is defined as 8192. How about we simply
changing LARGE_BUFFER_MAX_SIZE to 4096? This is what 
drivers/net/ethernet/intel/e1000 does for jumbo frame right now.


> * in the "chain of large buffers" case, the driver uses an skb allocated with
>   head room but only puts data in the frags.

Do you suggest implementing the copybreak feature which exists for e1000 for 
this driver, i.e., allocing a sk_buff and coping the header buffer into it?


> * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
>   qlge_set_multicast_list()).

This issue of weird line wrapping is supposed to be all over. But I can
only find the ql_set_routing_reg() calls in qlge_set_multicast_list have
this problem,

			if (qlge_set_routing_reg
			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {

I can't find other places where functions calls put square and arguments
in the new line. Could you give more hints?

Thanks!

-- 
Best regards,
Coiby
