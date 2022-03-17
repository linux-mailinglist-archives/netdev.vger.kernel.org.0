Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB1C4DC9F4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiCQP3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiCQP3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:29:37 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F51667D4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:28:19 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l2so10856302ybe.8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:mime-version:date:message-id:subject:to;
        bh=9YV+XxfN9qvqRlfP0nyAbGHXEabT3Ft7uOsdiJpOEbM=;
        b=nvvgGkvxwMvBcmEAs0RAs/yVscPp01SISUenk3/dmyXGnRpV4m2Dwwn3Wpr4bGbfy6
         3PZekN2ijVSiqgea+oJSzenJc4vweFH057p3gkiH9feki1X9jwrqzNLabziFfoebgr6S
         vZ37ZVyJG8USkxd4RvxrtyatygF69GjrllEguss4NE2vptCdOpWGB5+8a27W8uGtft4g
         KQY+Rk0BPmd0nERHssUwAk8JqHqSZDMVrbTxpFclq04ZfBCJuYllNplT0A6BLzt2yhQY
         prwOdu/K0RCeMJvlIbWJSi2R93KviMwDBXMdeqIcFevo/dig+agoZmtSJgs8/fAigJpl
         3+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:mime-version:date:message-id:subject:to;
        bh=9YV+XxfN9qvqRlfP0nyAbGHXEabT3Ft7uOsdiJpOEbM=;
        b=pAsKxol7oBSi46zlczm3tt9h+5B68OzaObEIIqykoKPRP1T3OiEg+4fCaRdg5TDGNx
         Yl/V9PMIJdINz7YYuE5D1u6bRqr1kinrNYrvAqYQ6hPChV3hTylKKFrZBkPT+0q5Xm67
         GGH/gU9Q/XL9ozdiY+ONS+rSuAKM5b/y/l7Aov92oPUTnP00qnp+YjMO313/lZdQ0hXs
         tRU0/4ILhQ/j7dxh4a25vJhzXdaK1s30F9G1qbi8CB7R3HWV9gfTkTU4sgBQ7O4f8y0k
         GQmQI5W9mDl7mPodxHyC3A+sfuUdYqhl9DJ1l2aVWhjTOchPqxkKTmBPrfwGiN+lON67
         eavw==
X-Gm-Message-State: AOAM533H5nec3KJDsFHxiwm2mUi3grTBTBKk59QbaIFHW0jKEwGtgD3F
        n1D0gbhi1SFRS3HjJuDpPbxYk+xgjk+sBmbgeSZDN+EoItE=
X-Google-Smtp-Source: ABdhPJy5+WaUwEYKROn7RdvNmWvbt/YXuxULMTH3VddxcyA6238frigo/+K1emykpI1q001dlEqmaoiqZLKGunKjEFo=
X-Received: by 2002:a25:a2cf:0:b0:629:1f40:4e09 with SMTP id
 c15-20020a25a2cf000000b006291f404e09mr5693560ybn.157.1647530898639; Thu, 17
 Mar 2022 08:28:18 -0700 (PDT)
Received: from 332509754669 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Mar 2022 08:28:18 -0700
From:   Scott Anderson <karban002@gmail.com>
Mime-Version: 1.0
Date:   Thu, 17 Mar 2022 08:28:18 -0700
Message-ID: <CAGcbcMCEP2sVg2AeM60q69U7m=sOTS9Yvnfff7rLxC381WxYFQ@mail.gmail.com>
Subject: Banners Order
To:     netdev@vger.kernel.org
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

Hello Good Day,
     My name is Scott Anderson and i am sending this email to your
business in regards to the order for some Banners and the sizes that i
am looking for are :

1. Measures 30 x 60 inches
2. One sided on Vinyl
3. Full copies Black Ink on White vinyl
4. I want you to write on the Banner ( DON'T MISS YOUR SHOT TO STOP
COVID-19 ) For the Artwork.
5. Hemmed With 4 grommet for outdoor use

I would like you to email me back with the total pick up price plus
tax on the quantity of 150 copies , excluding shipping. Is there a
surcharge on the use of Visa or MasterCard for payment ?Kindly respond
to me as soon as possible for us to proceed further with the order..

Urgently Waiting to hear from you soon.
Scott
