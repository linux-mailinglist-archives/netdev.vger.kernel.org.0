Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0069C5B62D4
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiILVe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiILVew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:34:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3A8E02F
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:34:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so8099843wmb.4
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=eCpgL743uWVZlwnsBcJNLCjxPjqLeWsv80X/liqz0bU=;
        b=RHhKSuCXyqBGKsVU+X9js8gbbRrtp7FXvuBShibYb20GuTswgyJDBPwn45LxDt3ZRd
         uwGURzIm53FK+ecCvpQpz8PPsSQACwGzVqSYbdaXcURNrF1ypSNcNENL+FFqkDPq+s1o
         Aw+VvcmJtKmjWXhd/QcUcUQyk+ZMBwsUnsIWpmMFQhyHNY1DzjVX6blWPYS8xieKS9Fb
         6XUvxsPC0EBQbWsNNcIntfi8cRKCJi5S+q79tMuISPg/mTD5KVkviIEoenY4SZax/Yxe
         e0hcm1kefKESufl/eb89MUVvUFaTJhC/KD1VyePofTRZSL6Rk9z3bUYiqPfQ/znOvMd7
         zi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eCpgL743uWVZlwnsBcJNLCjxPjqLeWsv80X/liqz0bU=;
        b=a2s0S6+WmK91jxgmj8E/R0LqNoKnpj6XzIKRj3aVtmHvsO9ameW+hGuSPak5Dpf03q
         WJHwYA+R5OuiQdGUQuwKp/ugvElRU5Mr5y8ptKZVVNJYVaauf+Pu99ZpnOYxJrJIy9sW
         uTG9KbjDRUN73aarc1QCsYC5ZTsqsfTO7Qa+2o+W5uXYNoRLIIh9hsITu8b9AxT7y9JO
         hUSzlpQHf7MeSUkRUsFxVjltuDaVI+2+exQQ3ImsSufop/kzZcpY2roJV/LZddc7X0hz
         psPj54Rp39xs9M8na/KqaYmDp6Tk9bT4r1J1dDcf/wVNB5IQdURdjWzY2l852+Y7tn2x
         xMeA==
X-Gm-Message-State: ACgBeo30YRJjXJxFxMdeOlDJPOAf+o3bTfZtBmOhf6wcTuG6JIM8+0sj
        ke6HRQzMp5lF/oNqIpo+GWe875EIdvUz58DfF60=
X-Google-Smtp-Source: AA6agR4CIx5Eb0JkL3nq8VWp3GgaFNQJBnpgZwp0WFWuz3zgcQh2B7+ga6S0Q6Kw5AMM+j7L9Am9O9PHkfVifM1SkXM=
X-Received: by 2002:a05:600c:348d:b0:3a6:b4e:ff6d with SMTP id
 a13-20020a05600c348d00b003a60b4eff6dmr197867wmq.95.1663018489507; Mon, 12 Sep
 2022 14:34:49 -0700 (PDT)
MIME-Version: 1.0
Sender: aboudramane.traore47@gmail.com
Received: by 2002:a05:6000:3cf:0:0:0:0 with HTTP; Mon, 12 Sep 2022 14:34:48
 -0700 (PDT)
From:   "Mr, Mohammed Rafai" <mohammed.rafai01@gmail.com>
Date:   Mon, 12 Sep 2022 14:34:48 -0700
X-Google-Sender-Auth: LarL-TC2d0_Pb7feJAIn8_F4Fpo
Message-ID: <CAJ8VP5iHyxN64Y0PCXgF4dy+UTYPgK+sETm0+SLakC8rnDVL+A@mail.gmail.com>
Subject: Good Day.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

Please accept my apologies for writing you a surprise letter.I am Mr,
Mohammed Rafai with an investment bank here in Burkina Faso.I have a
very important business I want to discuss with you.There is a draft
account opened in my firm by a long-time client of our bank.I have the
opportunity of transferring the left over fund ($15.8)Fiftheen Million
Eight Hundred Thousand United States of American Dollars of one of my
Bank clients who died at the collapsing of the world trade center at
the United States on September 11th 2001.

I want to invest this funds and introduce you to our bank for this
deal.All I require is your honest co-operation and I guarantee you
that this will be executed under a legitimate arrangement that will
protect us from any breach of the law.I agree that 40% of this money
will be for you as my foreign partner,50% for me while 10% is for
establishing of foundation for the less privilleges in your country.If
you are really interested in my proposal further details of the
Transfer will be forwarded unto you as soon as I receive your
willingness mail for a successful transfer.

Yours Sincerely,
Mr, Mohammed Rafai.
