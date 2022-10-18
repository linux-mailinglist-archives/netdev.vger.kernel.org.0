Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DD8602F8D
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 17:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJRPXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJRPXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 11:23:07 -0400
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF82D0CF6
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 08:23:06 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-357208765adso140155637b3.12
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=BcvxcEERUDZ8Z5hPeqdP6gbqr6f1YCBy3yGQ9vLEm2Fr4sRVOTAFDaoYtCSuXGVoYO
         zVJnOwpVAbIKhJDM2rtNHz9xKxdeOonfwcvrZrpgLVfj1lvdaBFVEcUYuac1QXYAjX7h
         yeNfS6VH00ULBYCtD7Xpn088pUSElOrnMkaGRdfTi0eAAoSRoRRSDJs63s2wohYMqh/0
         JlzisC+DnxFBZqOYTsCOPfNBEdScxnr2S8dNdf9DDloa8G/K+WdvYUAzSsgfbCGlGORi
         EZ20XnPGpaybxzMPVghPpaAQs21Ng0rvGNw0lx2aUJMf/ROeMPhatFnRbstMLxwk5cXh
         mfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=tMk9TRSD5OZYuglLPM61VbjEZKxF1lAgVmGrfgGis91wucGFu9d2V7lKiAmvTViBn5
         LNfusr1BbxRQZ4Y3H0AYPAKQqEpohyalhtYRGRzPkNWQ0A6cYhxEOcTuu+Wc7bIog93M
         ebxX9q2Wfa4fOyhu07Ji4uaGYBWVdg1EmT8IXJ2MoIXJKANkTU2acqh3M5hAh9O8zHqo
         ijWUpmPUS48PaMDbx7rkwVK7P5TcxxiaCCxxhSIi3n7iGmMTTcTL25oaedf88Hll5rOl
         NIV8kXGaQVg7IfmC1+u29j9a7lmEGejnluu5byXQcFe0I51clad7gjM5HhJZwsA7HPBX
         R2qQ==
X-Gm-Message-State: ACrzQf2UUNref9vRnujsv3hRH5iUAcagpCkuS3RvLao2f4LmaA12ReFN
        21nkt/E7tWrfwKw23W7U9EkZwbT9nw/vXB8sKWY=
X-Google-Smtp-Source: AMsMyM4jXmVtcSgWhrQ7f6w3VAaN1I71NDn2yKVvsN8A2D3m912q83n5lJVRDoZVxQYTudsoRI3myiVedVq6zYfl2A0=
X-Received: by 2002:a0d:eb0d:0:b0:356:67be:73ca with SMTP id
 u13-20020a0deb0d000000b0035667be73camr2909240ywe.108.1666106585123; Tue, 18
 Oct 2022 08:23:05 -0700 (PDT)
MIME-Version: 1.0
Sender: hhawawu71@gmail.com
Received: by 2002:a05:7010:73ce:b0:30b:90be:6b21 with HTTP; Tue, 18 Oct 2022
 08:23:04 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Tue, 18 Oct 2022 08:23:04 -0700
X-Google-Sender-Auth: t_B-sq21thNXYVBYdlKhAqmDGU8
Message-ID: <CAKzKUZ_9k18D7wP7TNnRgy=_oC8W5nSEM+khbaheNv+HDJusQw@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Mrs. Margaret
