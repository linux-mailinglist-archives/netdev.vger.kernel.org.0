Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E786B2442
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCIMgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjCIMgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:36:19 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11797E6815
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 04:36:19 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 16so914288pge.11
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 04:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678365378;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+B4dgNIniQHEcCF576ZP77lV9Zwje+bwHibbyEl51SY=;
        b=krTC3SesJBs7nb52rfYR/PNOOybZHRKn0QK+YZeNfOJwBMVWqdCf1z63pvQO3Og3IH
         XyqYARRmdf0ph4wFHMwGEj+PTCdxk7VWjliv/yYDDHab8vO5pjkNEday1g9OkCyvlBsL
         lf2/ZkjDIMHLyFhfYvZ1PIz4KAwZkXUaIDFuJ0RJ/js5qfPVdemREU6TbMdKT+FR8XsE
         W6ybJtL7NbZBvbfT7yCmrdWZzsw9eTKXz9dVhK4Cg4S561D1i19wUGEFsUAbb3Hw/iGJ
         Keh058ft9pmquPXW3X3WBaQG6D9M21btNe5mqeStX/Fw5WjkxgrZEivFwEkPgxjTAMp0
         4OVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678365378;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+B4dgNIniQHEcCF576ZP77lV9Zwje+bwHibbyEl51SY=;
        b=2w3gueraXGzqv0JpHfvOW8dWxGamggF9ZkfcOjEN5eFdfGpWh0IQXWj6rTM7QY7/Ia
         /EmOoNVKjJSlEiZzfpCQzz8/gsjcycFSvwLtwSd7nrd37J29O1vb0EZJwf2+uvdYzteo
         xoUNnWpHXC5c8aBvdBNiyYs55sYbzDGWv2y05/V2RFbO1OzyCqVTSonCQqvybVNUSyvh
         TN9vzcAcQKdRMvgCPQZEA4mMJTL4GTRN53b2/68mbdW/9MG6IR+YmcSKTp8GrtFW8wtN
         3BeFcdypWG3gTUuPXo54nhKGwf6ZnUf28QVAIza467V5sWJJ3LFlxj24KaUeaXoosy9a
         5gBA==
X-Gm-Message-State: AO0yUKW5ev/6k/g5ZwtKdT8BPZXwuUMPX5yt9dbuNzHQsxDW9JJtjvMT
        AhnIY3/SPoTkW1+u/qsq5CZv9PHercIVW78wWOs=
X-Google-Smtp-Source: AK7set8tQJZxpMDGknnAd8mclvx3CJPg3xtNQ+4K4S0WNzELW16q1T5qRaPZGtoV+9ISoqXFOI2KV47NAcmNiyfr85Q=
X-Received: by 2002:a63:7512:0:b0:503:77c6:2ca3 with SMTP id
 q18-20020a637512000000b0050377c62ca3mr7421587pgc.5.1678365378356; Thu, 09 Mar
 2023 04:36:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: vandekujohmaria@outlook.com
Sender: ah6149133@gmail.com
Received: by 2002:a05:6a10:4a12:b0:40a:8751:1460 with HTTP; Thu, 9 Mar 2023
 04:36:17 -0800 (PST)
From:   Gerhardus Maria <vandekujohmaria@gmail.com>
Date:   Thu, 9 Mar 2023 12:36:17 +0000
X-Google-Sender-Auth: zBmgW0YgcBX42SrBLHZ4eyPOgYA
Message-ID: <CAAyVoOpaWRZT=oa5ASg=psFVg3ueRvnzioC=+RunGOwJSotVwQ@mail.gmail.com>
Subject: Good day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all due respect

I'm van der kuil Johannes gerhardus Maria. I am a lawyer  from the
Netherlands who reside in Belgium and I am working on the donation
file of my client, Mr. Bartos Pierre Nationality of Belgium. I would
like to know if you will accept my client's donation Mr. Bartos
Pierre? if yes get back to me
