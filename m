Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5989A4DE0DD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiCRSR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbiCRSRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:17:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF43712759E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:16:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id u16so11763033wru.4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=J2DYZwKpPWCcQJHHvpXWAjJzCwMW/LcdtxLNrvegYUnQ86w316H45sFh5NGqoBd8AI
         0mRQYQjHU0WlgRXI/XLqSYI9DE7QpUql7taOaKKow7Fm/X0Kz+7OsG/SnMNsWS8MNCXU
         Q/gbzk/Ev1jilVdJN26tkzzgBBPMK+BHOkYY3Re0MCGKEvDJ3ca0JOqjOun9Lsbewloa
         y55kkGvLiGegDnA52GTeZ8srkn6z2mI/F9iQyi+lGk4e97dlQpMrONw6wOk9I7H6F+F5
         LaWFR6i0uD/CtW8xToOxfi2HF4lTwANRtj9oHDqGSXzJM4x/8ofzOAjFMXTXnbVzSSTr
         IIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=3j0PoGIF8NCvcEtDwy8VS4TxfLp716vpgZPKUNXBWBko9IcZYcNbmRhYhM8k0/ernn
         hzUYthauqG6d1IkAzg11HcLtn0Fze6kHmQI203h4w0LVVmSu5LnqxmT3K9KnJS+3QjLD
         0fiFjC1y16wFiUZNesP77JVLaIRnqdMWG1nSHNwAboginKnSueUseTLzNxIehIQB8IiT
         UZ/mlpK1Xz3BYjyOQwhc8uPabjNhUqWNk18WOL4FoxJ1ve8vCL6p/C4hHcqHqovU6xhC
         +fZ8zFGgES7uwD20Pdh0wKKYqscmHT7lJkoexamPQuZ7BHkehWHDWHuBOQTjEFLmtidb
         hu4Q==
X-Gm-Message-State: AOAM533GFq5fc43o+xJvWPvLUChHrF5eP3BlXget67nprN5UrF2PjdYY
        ytMOYBdgPzJBlGD4eIao1W+L8P73pDhxqt6Usfo=
X-Google-Smtp-Source: ABdhPJyXjZ6uDnNe4h1AFmeybSRHg/MM4AgsZOETurFqEVhw1MW8koOye8ZtM8lUiZCKnUmIEmpg+QHlas35fukN3HI=
X-Received: by 2002:a05:6000:10d2:b0:1f1:e648:5ed3 with SMTP id
 b18-20020a05600010d200b001f1e6485ed3mr8787235wrx.243.1647627390563; Fri, 18
 Mar 2022 11:16:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:1c0c:0:0:0:0 with HTTP; Fri, 18 Mar 2022 11:16:30
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   Kevinjonathan <leema8001@gmail.com>
Date:   Fri, 18 Mar 2022 19:16:30 +0100
Message-ID: <CADaZM5KdM19i15FFZm3MTp2OmvfPpzh312i=raO5LKR=+RzBWg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
