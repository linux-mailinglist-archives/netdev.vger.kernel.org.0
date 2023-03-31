Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B45A6D223F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjCaOTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjCaOTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:19:50 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871251F785
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:19:47 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i5so90419935eda.0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680272386;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d893z3BvTWKiVb8OCIsuHGjkrdOBkhU0uQOX5zjpLPs=;
        b=qIabSGhTPmIaljnDLqeXqNsEck9vJzF77/lpH6O68Le4bpwzHMfHRG4k1jcXFEpk1m
         htyEyVKd13AzZEEG5yqTuP6avJaT5grJIf/juW9AEagB/Nt0MxD7YyWhVq9asf/JI7g8
         RCqsNCTForZfNR5hpb2HWXPZuWISUA6Mb4oUQftpYbIWAXhpE7XFmq8NOnyoQMJoa9CQ
         l2Loip3zJZ+R67or071usi3fVUl4gngPRDd4L0df+QBNWg0PBa1/ef4Q2uHR1iT8j+56
         ZDAXCh8FD+ZR3pkDdd/B3MX2uwX6PEsMXDgs6F9OUUnXb1yu+1ku3e1YMQu+Z5sv0qi2
         7Tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680272386;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d893z3BvTWKiVb8OCIsuHGjkrdOBkhU0uQOX5zjpLPs=;
        b=zLlqOpzY2OmTfUuXQVLiktDFiPAwDZYhM+1rQKliShoBwkk08FMKBiJsmmtniiO+dO
         P7wGCNNyxKcfLB+IYrjOnGCA62cpq3ojo7UU7M3iLsBcTBHYJ5ft/o6uGLUYF9qI9voj
         zrJsVrafZP2d1FYHGTKkL9s/KDycPJ1A9BqfBgoA8ngDpfWy/EzibM4Sogxu6IKSlV5O
         /uAXDyvRlsZbTWMtxG6W7zWkp18I3QVlj9E/n9o4EWoO3hZdrbN2u+7WfQzKOjqzHoVp
         Y7kOgfvCA+dLJdf0R5uGfg4TqjnlMBMSp+aLW9m5ucqtaYUIegBLAHHYTk2JNxWhaqp4
         SEgQ==
X-Gm-Message-State: AAQBX9fn7wX1PGxuxZPvyFZAatYNC/mjKxkmmoCFaeCLdhWkNKwebtDM
        5RgqBbiDMApKpBBspMg2bZcRAhowf8+qi1XAuAE=
X-Google-Smtp-Source: AKy350b81j52IVDTqCRMAuazSw9Yn4dbRARC3VFGuedWzm74RfqsLq7svDpT0CMjWIbAJJh7uW/pX0VpnlCWOCYqG1Y=
X-Received: by 2002:a50:9502:0:b0:4fb:2593:846 with SMTP id
 u2-20020a509502000000b004fb25930846mr961118eda.3.1680272385721; Fri, 31 Mar
 2023 07:19:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: eng.kelly103@gmail.com
Sender: yus.fatau7@gmail.com
Received: by 2002:a05:6f02:a468:b0:4a:964a:c83 with HTTP; Fri, 31 Mar 2023
 07:19:45 -0700 (PDT)
From:   "Eng. Kelly Williams" <eng.kelly103@gmail.com>
Date:   Fri, 31 Mar 2023 07:19:45 -0700
X-Google-Sender-Auth: DCeqgCb5ksc7aKmvMG4j9WBFpX4
Message-ID: <CAMrr=JjMAYq=vQWBMuwgQVH_c8oTNqHZTiHaWVVXzD1RDtnVRg@mail.gmail.com>
Subject: PARTNERSHIP WITH YOU
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,RISK_FREE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PARTNERSHIP WITH YOU


My name is Eng. Kelly Williams I work with Texas oil and gas
Association USA. I need your honest cooperation to partner with me to
invest in your company or in any other viable business opportunity in
your country under mutual interest benefits. Our partnership will be
absolutely risk free, please I will also like to know the laws as it
concerns foreign investors like me.

I look forward to your cordial response.


Best Regards
Eng. Kelly Williams
