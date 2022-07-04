Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9401565119
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiGDJl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiGDJly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:41:54 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FF221A4
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:41:54 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l11so15857079ybu.13
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 02:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=E61+1ZXk0XLFmLKS8+LHaQBAQCUVSplsnRDmkf+keqM=;
        b=HwmD0BhIo6ti1mMi843J31iYChs0hZkaK9LwA5MjHkH+g6XD/4Rti6GozSKvYXH31g
         oTXAF+AiiuuQS6WY3MpFbDgs5Mf29He7LQ6fP2KPoSDY+hS2JFG9C8yLS8wEEbn+jJ+G
         AdgqKpr247KAAmvNzPtlaI3NkvkthhcBkuIFRz0sFLAJX1CEKMvbb4R4pG2Z6A35bbhY
         0h+efV+ENy7CFSa4zk9cTKaC0ez3mQ5uTTx78eJ9YfCtRfkooPWQXzx4InFxWu5oCmxF
         CzeUgL16bDgAA8hr7eXWzGPy2qdoffveB1syMwfEhCTQsjQNEYiNwYofYn34uRMhhYEo
         23Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=E61+1ZXk0XLFmLKS8+LHaQBAQCUVSplsnRDmkf+keqM=;
        b=XsEuYYq/yIevPgtpRpSmyBehd25pJSy1bBfBfhkOppKYlMKJOCjSBes8EofzolhA1G
         R1K+V5KO9iqbW+OCWg9C38tAuhF638V+YqlFS/tgpjyOFBJGE9dqoBdVdU+YzxAJa6wv
         YOA9I/UDHz+NUjvbIf43gC0vWNXVmrQOOY/13yP1wKytWl3foYEpSNze3PckRyDo8q2g
         BvMUlA12FtDLx0VvzJ4yi4ryRC6jvMixRwTBL2ZC8CD+jtQ6wqyyp/7X0ykwiPJlkZxC
         N9PF1G9X+yopWIkMHFsQZDck5dZtNCgWGvPDwftflaXa0sxNNntcYP328tqaG+ZO45wv
         DedQ==
X-Gm-Message-State: AJIora9zmhTNffFx6OUKOH05TmjxkkLjyHb4gLcV0UB+zDdayVJI1OPu
        LPpg9dce6B9wZQ3Tor6mI0RT5aFzCYPktXCsUx8=
X-Google-Smtp-Source: AGRyM1vSseOq3PVCCTmPDq1SnuYVVoD3YFlKyHh/vRS52PnZATUIt2E9H3V6+38vfzSA5qvRXbS76B9CtmsYICUSmuY=
X-Received: by 2002:a5b:cd0:0:b0:668:f06d:df60 with SMTP id
 e16-20020a5b0cd0000000b00668f06ddf60mr32349590ybr.191.1656927713039; Mon, 04
 Jul 2022 02:41:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:5286:b0:2e2:3648:8c0d with HTTP; Mon, 4 Jul 2022
 02:41:52 -0700 (PDT)
Reply-To: hj505432@gmail.com
From:   "Barrister. Ben Waidhofer" <musamuhammadyusuf2@gmail.com>
Date:   Mon, 4 Jul 2022 02:41:52 -0700
Message-ID: <CAEfE=vGObnNjRG38nuCz3fDRmNF=jfL_urf=eOTNCjosPuP8=g@mail.gmail.com>
Subject: Investment offer
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

                                                 Barrister. Ben Waidhofer.
                                                    Chambers & Partners.
                                                       42 Parker Street
                                                            London
                                                         WC2B 5PQ.


......I am the above named person from the stated law firm in London. I act
for Mr. Andrew Walker, a former loyalist and a personal Friend to the
President of Russia Vladimir Putin presently in London; he flew into
the UK months ago before the invasion of Ukraine by Russian government.
The sum of $3.5b was deposited in a Private bank in Switzerland for
the procurement of MIC war equipment from North Korea to fight the
war, but he has decided to back out of the initial plan to divert part
of the fund for investment in a viable venture.

There is a need for a matured and trusted individual or corporate
organization to receive part of the fund. All the needed documentation
will be perfected here in London.

You are at liberty to respond for more detail.

Thanks.
Regards,
Barrister. Ben Waidhofer
