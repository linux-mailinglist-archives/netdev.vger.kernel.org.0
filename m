Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4296B9089
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCNKtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCNKtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:49:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C31CAF3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:48:35 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso9758205wms.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 03:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678790912;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q92R1MA4BuxlyOo5is+Ybva3y/sk2XNRgqua+9tG9Rg=;
        b=axH9QD5qSZlwlYXtTjW2wM0V72eycVsyziDk1Zixl02zavgi3PWxxSJqr9o0PkpxOh
         cEw9HK4+ek++RYSxsjh6Ut3RoenTyaG4dFjJfmMWzJhSDulu8QGFC2mJh2vQYbWxRSbh
         6/4lIOP0zYP10o4Pg3gvEJq7v3KBFcPmZyQKug0bp879HLcENd3y8RCioF+rhiZ2Ualy
         MuqxSL9yY3Ok2ZmDtU5snocOlQyr3ikHCHpJ+57EKoWpIo51NttOg7fXKvz7JAmaysT5
         N1DKdRmAWiKXCqS+QYaUwNHMo9CM5zPOCu9I5QE2NNWy8Qwx8dtZRVt3GDdYZ/9Hmdsa
         e//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678790912;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q92R1MA4BuxlyOo5is+Ybva3y/sk2XNRgqua+9tG9Rg=;
        b=zG2k/QuSLlmFUIstQYpsT4zWHg58YnUdvq2RfdlaGYBmmCJ2pBIgwMplIhf2cSqHu9
         f0X2JfOQhv4phv+vpWWUQpIdxQRg8aLsoSdQpA3ChqlhOb0QBWBBtr/gNy7cbQsEhDaK
         xX1w9/Mv4CWqcIXPL8F6nOFagq9UKtVjzihdezwwyoqDExYMdTZfHaeuJJg/B68qup7o
         7Tkln0GBIrw6RaJqFxTEz/XHvdVU9AZel6JcGBJfPx3j4kJ1D6Cv9OSqNmG8BwICqERc
         EunpVk6//3dg7t7KCa21q3/363klFaxFDfQcF3AcMBTwBstheKlro28o9507ULufTCLH
         mdFg==
X-Gm-Message-State: AO0yUKVcczqt3tkK/w3lA3A5iNEiykjtJlBD/8v1rWlmBdv35eRKuj//
        qJslgDUTgLDgWduXfb9URKPORBkkPAAywqhBGIw=
X-Google-Smtp-Source: AK7set//TqeJl/3xf35ETruAYcHHD5Wl4aWp6JnzULhIRqL09q8pHlVzEi6WbhBLfHR9kHw0hu1BWz0Pu5HH/9XRm14=
X-Received: by 2002:a05:600c:1c96:b0:3df:97ed:ddeb with SMTP id
 k22-20020a05600c1c9600b003df97edddebmr3921196wms.8.1678790911825; Tue, 14 Mar
 2023 03:48:31 -0700 (PDT)
MIME-Version: 1.0
Sender: westseaoilandpetroleumservices@gmail.com
Received: by 2002:a05:6020:19d5:b0:265:5e4:713a with HTTP; Tue, 14 Mar 2023
 03:48:31 -0700 (PDT)
From:   "Mr. Abu Kamara" <mrabukamara772@gmail.com>
Date:   Tue, 14 Mar 2023 03:48:31 -0700
X-Google-Sender-Auth: 4dJ7yorLmYRuNWSePray8fmB4J8
Message-ID: <CAO_TN8xQB7kFQiBPr79o2EUmapeUQeucf4ZH4ce+aE8kHd2xNw@mail.gmail.com>
Subject: WINNING NOTIFICATION.......
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear greetings to you, did you get our previous notification?
