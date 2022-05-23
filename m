Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8997F530BE4
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiEWIcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiEWIco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:32:44 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BFF2C13A
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:32:42 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dn11so1104163qvb.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=WZ+H1qUyPNp2nmiWLS7sS86h9kl7Ug3kEyKLMvWcNxA=;
        b=APm/uNb/GzR5JlaR0ISnT5ZuyQMaLVul1PeKycJCI8rR61GCXvvjPNb9V2knVP4a1f
         vgwYKxtvTEhFdoRJl6VOtFoUts5jt3OHQsHQINVIxopYwW8Bv0VuKzuCCu7XEDOKZaqE
         +2/m5kP3N8X3rj7g01Msa09h/NKTm8nB/GFR33kERRwj2IwXOgj82rdn/tWh598V7nEG
         39MXBqtqxjLKU3NnErxepCCpnEaPMj9hlQPjx0Xy9BEAboYQ/pLttZbc2Hdw5Jc/dT1G
         Y+gWIlzZoZpiFahBtgzihzrfRfd5nJsnugVmUrvwmXUnVLczFcQ9KgOrR0ETSsHQzXVH
         Z0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WZ+H1qUyPNp2nmiWLS7sS86h9kl7Ug3kEyKLMvWcNxA=;
        b=vGx2/yRWyiPgdpTskdBfy1wqGPZ4fC6iWIFZzPbUV/aYbSyv7bN823p4n0k1CJrQqH
         NbJpXo5RGpL3y8dGszEgDaNYjLRLHl2PfEvDw4zd4b5NOLftu0JrLOee0PpnYrMx8J5Z
         aHiP4NlBJHq9OP/Ghxqp4l+H9AVbNGfg4/goOH9Do5ROrbxIB/Gmj2/o0yFTNLP8ULUr
         Evygx0klPJS0jiZ1KvwP74Q7T1oeGZ2oCwHGsGBjpaqsz1Qa8xaXpqgz/ThqYTIWxBKm
         M4YcPI4cqXUfmfXSl8cVUrnQTJgveZFYRdcn1gRAJtpAvBCzc73gfC1wX63oW6EUd5Ec
         1rxQ==
X-Gm-Message-State: AOAM531hCv6x4AtZfEws6VDRCsYoNhhkoGCx5NG8Gejxs9jDAbqe4qtt
        UFme2OhR9fkBx95Q3bWiUA8Mb3Z2vAzGwBMslj0=
X-Google-Smtp-Source: ABdhPJwDSGc9nwDPvnnAfIHSWlkKE8s7qt+WU63wf9+8AI+WelHmBGp+Qe1K+2cFHagVTe/RWLFowFqfwEhdRvhTd7Q=
X-Received: by 2002:a05:6214:202b:b0:461:eb83:7d54 with SMTP id
 11-20020a056214202b00b00461eb837d54mr15915269qvf.44.1653294761651; Mon, 23
 May 2022 01:32:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:5be1:0:0:0:0:0 with HTTP; Mon, 23 May 2022 01:32:41
 -0700 (PDT)
From:   Kee Wang <keewang6@gmail.com>
Date:   Mon, 23 May 2022 05:32:41 -0300
Message-ID: <CA+LVnowJtUsXhx4Kaqiyt1cF4vLLPE4YxpkfD2nu_CG4x2ihMw@mail.gmail.com>
Subject: Good day my friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have sent several emails to you but no response from you. I hope
you're good? Please reply any time you got this message to enable us
proceed with further discussion
