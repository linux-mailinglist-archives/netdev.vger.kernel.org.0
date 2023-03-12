Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86DB6B63A2
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 08:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjCLHRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 03:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLHRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 03:17:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9204D283;
        Sat, 11 Mar 2023 23:17:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u5so9809056plq.7;
        Sat, 11 Mar 2023 23:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678605424;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJAiYidXikRagrvs8QJrX3AufqF9vXtWgvBYHZzmNh8=;
        b=iXVjyBpy4RK3fjvyAbhHZrjwh2ex8mT6arPVKf1A6BCobz0X+Fd56fOCekj6EKp6Rn
         HmEHrrzDyOZ82VIgvleNWWLgCi6+aCWs2p43gie8snExM+MA/SlC5f8cgIQTQRTaTRL0
         FJDMZFKc2xHrht/odbAr25+wpSO2MPjNNskrV71+P0jalixcSdUsHv9Kc7oej6H42aoW
         zF3hxwp0EE3ZdIZH+OPSOmF0K4M/kILQZQbKtY73nhJpu8IwLu8UKwsevtcS/wtU3QhO
         VSWOeUqhubcYNBQOFRZ9HYzjqTjUcBjsm4xTEOzOXL2byf8MVEVbZvnmW7stw1kJ5t6v
         3AeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678605424;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJAiYidXikRagrvs8QJrX3AufqF9vXtWgvBYHZzmNh8=;
        b=owve3ZDSe9HDBrey6A6IDXhv3z2CnRFBBjFqnYapHBI1F6qHKhpEFLmcQzRDIS/tHF
         pifLfu26CfXlQHH19Theiaf7HIgQ/5CwiLH0O5jpD1GtaSKIo2mCax2ZrNs7JYFdms8C
         7MFbPIvXbnBxMeWlwdP3VIU+E5ZxDqPhhF0dstWzvft3pT4kD4I+vGHbGyeJ50ZJl8sP
         hNTu6t5+swTcnzcczSDeRhYXZx5od1H4Hb8Adtmnoq88o/LB36e9vVE07UAYf9C9Fkwe
         LOQahrDqr7PQdM5KBaNMe1boGIdwMLDa5yYp8s5OrFQ7AAeWAqiGdA+PE0GZVUcvpf58
         cZug==
X-Gm-Message-State: AO0yUKV42EXOng+rt0FwRZdKFnLunm9cmQzwV1FxRb42s8qYz78UmVOc
        a8WCqromXbV4mnd3dpneMbSaQpyJcdVXUg==
X-Google-Smtp-Source: AK7set/IHoHq5AN2YzM+IZs3vpDiPFZBI3vA7hTBwFD15l3bL5LAUB8j2fGLBCvxpt3bCf3XsM5pvg==
X-Received: by 2002:a17:902:d4ce:b0:19a:9864:2887 with SMTP id o14-20020a170902d4ce00b0019a98642887mr8029036plg.7.1678605423792;
        Sat, 11 Mar 2023 23:17:03 -0800 (PST)
Received: from ubuntu ([59.89.166.125])
        by smtp.gmail.com with ESMTPSA id le3-20020a170902fb0300b0019f3da7a632sm515115plb.146.2023.03.11.23.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 23:17:03 -0800 (PST)
Date:   Sat, 11 Mar 2023 23:17:00 -0800
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     fmdefrancesco@gmail.com
Cc:     GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        error27@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        manishc@marvell.com, netdev@vger.kernel.org,
        outreachy@lists.linux.dev
Subject: Re: [PATCH] Staging: qlge: Remove parenthesis around single condition
Message-ID: <20230312071700.GH14247@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1713523.QkHrqEjB74@suse>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio,

Thank you for the insights. I went to the .rst files because they are directly linked in the first-patch document. I also noticed the difference between a ".rst" file and its counter human readable ".html" file. You were right that many information is being missed when anyone will read the .rst instead of .html/.pdf. I would like to suggest that the links that redirect to the .rst source files in the first-patch document must be changed to the links that redirect to there corresponding human readable format. Let me know if I could do it under the [KERNEL NEWBIEs ACCESS]. 

Apart from this I will be happy to patch the style guide after this
contribution period.

Regards,

Sumitra

