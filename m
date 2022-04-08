Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E484F9ABF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiDHQhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiDHQhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:37:45 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20B98F6A;
        Fri,  8 Apr 2022 09:35:41 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bq30so3241125lfb.3;
        Fri, 08 Apr 2022 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=FFoYpbF863k/pBsPIF5QsC9t58VedUuM7a/RF6igal4=;
        b=afkUqADE7Kkb8bW0nZw/GaT4xWYr1eKSw6jDRV+nkfdnDVLpid45/8ISvekE6oReop
         DQSSBWmmk592uGL7Q1pFL8rBYYORE0q7n27a42F7YtjQ/DnwbHrAqFL9YLfGOXM+SPo6
         LSNLcEqezquXx09qNbMlBMpQ0Nd4hXwaT6BMSskD/L23XgDBHjO90q3zb3F5ACqSyvqp
         Foh+YyPEHJH7yc1sgByS7IvLspJHH/ngUGEz/Ifg/Pz8ZZaXwMzZEfTk16/CrXHC5STB
         l/MdQoO8SkIAapZQIGFURyN0ddEg9OBWKOAoWWMbeoyz4Y2u3mqAeAUtdKmPWyf9Dhqg
         r2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FFoYpbF863k/pBsPIF5QsC9t58VedUuM7a/RF6igal4=;
        b=24dn2dyfGGG2W+Wczp4MWvI7Eg1KDi2Q4qS4UZ+1kTeS2XaHRCMaHJB5w8uxyLzLsq
         vXsv+D8k41H3gD9QmrcfPAMQhBvVTJTA+8awK3v6tkWyU1ATbm9yO7I6MCJ+ujC6cvxI
         p7IIvBGfJ53IL9pv/czc5RJJMoPn+kGcGBmAzunytZcJ2u5vkvZ1fIER94CPKRXTrUpG
         bG2aF1MnglTp10WFj0H1mCRTW1N2uxfwUfK8CBOlo0Ecr07m+WQ2yJP497csjI2MfO85
         p6Q9U7XtZ7wDAvMIiOvOCdfJiZMZIwo2HiXNVHKfHUhBSiu7Q5GCISN4dZhjFJpR3c8C
         lRug==
X-Gm-Message-State: AOAM530f5psxBqjN8AFXJqL151ho8f2mbNi/cnbZ3/lJZqWtN2+sO0eL
        oNTnVXbQHnqbH8xKYRJfaTSI4Qxhd64C4+R/IMU=
X-Google-Smtp-Source: ABdhPJxFP/ouPbvMaJ5QMbtMWcOd1FddPolG7h+MMOx/15H8RobY8xBhjjZPrKUXtXyN769bc4d4N/LA78A8It6N6fg=
X-Received: by 2002:a05:6512:b12:b0:44a:ba81:f874 with SMTP id
 w18-20020a0565120b1200b0044aba81f874mr13517769lfu.449.1649435739232; Fri, 08
 Apr 2022 09:35:39 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Fri, 8 Apr 2022 12:35:27 -0400
Message-ID: <CAD56B7dMg073f56vfaxp38=dZiAFU0iCn6kmDGiNcNtCijyFoA@mail.gmail.com>
Subject: peak_usb: urb aborted
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        support@peak-system.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

I'm using a PCAN-USB adapter, and it seems to have a lot of trouble
under medium load. I'm getting these urb aborted messages.
[125054.082248] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-71)
[125077.886850] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-32)

Is there anything that can be done about this? This is very
frustrating because it makes the USB adapter very difficult to use as
a reliable partner of an embedded CAN device.

I'm using Ubuntu with 5.4.0-107-generic. Any help would be appreciated.

-Paul
