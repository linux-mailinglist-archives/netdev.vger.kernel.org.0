Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FA948114D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 10:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhL2Jgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 04:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhL2Jgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 04:36:46 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930B9C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 01:36:45 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i22so43234571wrb.13
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 01:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=KKO/2Cu/Gm4swY711SfunN+lpYq4pDDjlm630jPuIOI=;
        b=QFJISCD4Yd+lggFCm650EqEvfNSyznsmYWWDynq57aVxeQ2A2XqJ1Nh9UmgTKDu1oo
         fEXqYlOs5/of5yteqX92pDKd2uZ30Z0LYCZSQFxMvcQey92p5Ujue7p9asC7MaE+z65i
         G0zlE9nEArno8XKlLQciyx9GZhjRTCxw1UmqJEWIa3/UHk2E8sRzq4JOwv9NxS7TWtdM
         qjIdfilLGOsq9qEwU1otv+i2xrqAWSp0iRE0vPEWha6ItyN2lKpGaf13XH4qOU+mMPbL
         s2O9FUUMskrSj8K1X1BKM4tYmozQpecKVM6DytxVmspNmFGEsqTcK36wMArY8dick8xW
         rWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=KKO/2Cu/Gm4swY711SfunN+lpYq4pDDjlm630jPuIOI=;
        b=FsIYUatqO9+2OHGxPEBevhAoC6eW5RI69urFK2dJ1I7P9ZaaPPI4Qq2IFVW0aiH8Cg
         WQjx0GxLIHnj1WpzlCz95xd44O1qxOzv+7DB/Xy5g/GBbrUa9MFO/kNNJKE3v/hgQ8DZ
         OTS2Vj85Lra0ADqObcT8Y+0NDsF17WTTVcf9W2YUWMDy3vWGg2yEqlCCsGBxTaeebc4u
         +hzi+TiZe9VTCYKRmSmjBqsGBJLRVK4YQGlDTSr2O38fazyxsE8mrhiRzq6+Qne3OyeX
         yyzZWcwvD3KKnpxFIdlWOuSEMQtqoKuCRK+JQCKG4KevhL4eGMO7xklZ3dugGG1oJMB5
         cBkQ==
X-Gm-Message-State: AOAM533RNKul7TQamCRkz3P6RW1QJlOcG2YsWErTXK+m/sRZ0U3Uo+zM
        mTncVn8XP4iKnPl3EeWDpbB6qbvq1VepYiQnYGg=
X-Google-Smtp-Source: ABdhPJwe/q2pD6tNf9YHflMdd6uTlgz86OLlL4KIFOrImMlAFKsftvD2x354Xm1ZH7cufGgx7RUrq6K8r06t4twP+bE=
X-Received: by 2002:a5d:5348:: with SMTP id t8mr19925277wrv.439.1640770604041;
 Wed, 29 Dec 2021 01:36:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: fre0707lo@gmail.com
Sender: vijay.5675ma@gmail.com
Received: by 2002:a05:600c:4e4d:0:0:0:0 with HTTP; Wed, 29 Dec 2021 01:36:43
 -0800 (PST)
From:   "Ms. Lori" <udom4395@gmail.com>
Date:   Wed, 29 Dec 2021 10:36:43 +0100
X-Google-Sender-Auth: ya9gruf5zc3aN03piHz0u7xHo_w
Message-ID: <CAO86SCyvrPfKvVERzyAr3p=XjvRfOOeQUkMieqe8YgScWuPv+g@mail.gmail.com>
Subject: Let's work together
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My name is Ms. Lori from Washington, USA. I work as a Foreign
Operations Manager at a reputable bank. I am the account manager for
one of our deceased clients, an oil and gas contractor who died of a
heart attack in 2012. He had a fixed deposit account with our bank
worth $6.3 million. And he didn't specify a next heir when he opened
the account. He died without any closest registered relative as he had
been divorced for a long time and had no children. I decided to
contact you for our mutual benefit, knowing that you have the same
last name as my deceased client.

I am very pleased to see your name and I look forward to your
cooperation in presenting you to the bank as the next of kin and I
guarantee that this will be done under a legitimate arrangement that
will protect us from any breach of the law. And for your participation
in this deal, you will receive 50% of the total amount after the money
is transferred to you, and I will receive 50%. If you are interested,
please contact me for more procedures.
