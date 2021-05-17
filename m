Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE7383D1E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 21:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhEQTVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 15:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhEQTU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 15:20:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C534DC061573;
        Mon, 17 May 2021 12:19:42 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id i7so6927333ioa.12;
        Mon, 17 May 2021 12:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8yOnzHIC3Xtg43c+Z0BxzrFMxEw+BU0kg8+CceoqJ8M=;
        b=Zmo8ROBR+ZbQN3vQLxMz3JZA7+4uiOq4adz7yBmew9Sl2KkFeoAlrvwOZ136bxPvwj
         comcBdIebGmI0OZiCAkzOmbpCOxvIzorvt2v5PrdyloCkRL87feiRCE5Fj243GtFwJm3
         siU7ggpdPFCeOamoL3Zbanq4ekTQzF3nX/XiNfwSQaR5g9r0wpRT/B39fQJHO4IY/ec/
         IVR4QLQDGGd4ZTBu25xYV4xIoimlablUBqhE03JH4qTkXf+QGW1xfdfoYVzOai6J2Rgx
         0uETOyYuqtF3neoL+twsV8Vfw19f2ZmPG3trFG5rLbRdG8eyWYDVAReBER8T9UeH9B8I
         pGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8yOnzHIC3Xtg43c+Z0BxzrFMxEw+BU0kg8+CceoqJ8M=;
        b=aBnL/wm3aj3BNPxaCYYtd+sy8yWHJ2fHA6h+XaS04rUuCI2/z326tbu9Cz00L2rsBI
         iMR/iOZ2xJfbcoa6M0IgvyVXE2A00J/D8kvZIUot1bAPp0xmPES7wB02nb0mgQRj4Ry5
         sE4N39cNnJqw0FHBgzwg8om6qOun1bw1zPHPyONcWNQbMFFxhNAgsz1s8X6wdwbZo2uY
         tiYOwqsE+7PW9cEdceaSSHyoSyvdLR1LDXRDIoxSybfgDiYJTbjfjAOYXfpSYTF55TMi
         cZ/00z2P7PDX3O+G6b+t50pBve0MHsQ63hY14heZSmkDFNzPFowkiSJfpnagMqbuOkfY
         fLRg==
X-Gm-Message-State: AOAM533Uis0sdLZXS3rt7iSsvGNGdhIxenxlglrwHrHCIS+HjczRP9CC
        d0Eb0zfy5gLB6VYWurvCIhM=
X-Google-Smtp-Source: ABdhPJzusXHPICl7ElUGIohuEFRMIBSBx+7RqeFyaQFIoOn2bSjqzLOJkXlNnZ6FcBGNBwMCisCM8w==
X-Received: by 2002:a02:8787:: with SMTP id t7mr1511892jai.53.1621279182318;
        Mon, 17 May 2021 12:19:42 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id h17sm7723685iog.47.2021.05.17.12.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:19:41 -0700 (PDT)
Date:   Mon, 17 May 2021 12:19:33 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a2c1c5b31bb_18a5f208ae@john-XPS-13-9370.notmuch>
In-Reply-To: <20210517022348.50555-1-xiyou.wangcong@gmail.com>
References: <20210517022348.50555-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf] skmsg: remove unused parameters of sk_msg_wait_data()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> 'err' and 'flags' are not used, we can just get rid of them.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks. At bpf-next would also work.

Acked-by: John Fastabend <john.fastabend@gmail.com>
