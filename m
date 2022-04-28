Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21773512D81
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiD1H7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245714AbiD1H7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:59:06 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB122329AD
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 00:55:52 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id t85so3891329vst.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 00:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=NLijoYwk7hqoA8TsUJbQbQCYzScrvalH7Lc8MykkZrA=;
        b=U/6N0yeLOtBRMObmNKq7QXJJgcqyds4ooUiN/+GNnyyUQ0Bh7uOB1Vr9y1W1Kc5PYH
         rv9QvMBI9XmkdLkvWw5mhFsdBoXNR5BR7GB0YhTwhVnhcusOBm46taodfuG1fj1g9iyw
         5tTBa4+5KVbiXg3FLA9858e5qVG1mm/1wwb3Ryr649mZDhaPzjpco13LwPKsygG19KCH
         zMrk9oZ1ULHjyMjbTLHSbztBNV/39aiN858JgFh3HRXercnX4a4c1SbuXDx3fRnGnieS
         MxNuLNR3dXDzEbbuA3/inyqapQXnLrvvDaZESWLE2midxo+st8khBnoRnkwqQBAxfB0u
         cfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=NLijoYwk7hqoA8TsUJbQbQCYzScrvalH7Lc8MykkZrA=;
        b=pjqhHst5/hevG6zNIOw6hDE/yWTLMBAPezgD9TMOzM+yPa3Xhf1k9POVUIKj2WZ/FL
         mPJjP+7o6Nz8csmnxlrqdQ7IXh3fbMXc1CByQZWJBtgypi8CA7C1E97aEbqlzpwZNSAc
         Ks00/HshK9rvKobZCXfbggnbqcA92VJPFDkjK0XQDpfsA9VUJjjwcZpFneGbnutUxCb3
         dLyzHtFfvF9D85Ddq+AlkxOd5EcW7xdcEBCjS1N1J8FATDkMVWOw6d5GsJ4r6gxQRC6f
         Mz+MFKQtNMYmbsHs0hq5ozSOXZ0pAf9Ve6ViRDLBXnR+Fe3n8tAMPfLS6Z6HtXz7JHIl
         OS8A==
X-Gm-Message-State: AOAM531VfUriUT1OpRaZI7uJtQaBW0QqFGfZjj/mxnuDI+CJgWuq05EH
        TCbYm/PSynU7896/2S2RrAznZwB92c4f41Hurg==
X-Google-Smtp-Source: ABdhPJz5r1ZnqLfrnXBQAvUq5ZuMNcGKKyqJCVqTPapJKWl+FiSY9eF5hdlcgFEVaJ52K5HBsT0z0rec7Z1hGDEstiA=
X-Received: by 2002:a67:f6ce:0:b0:32c:dcb9:3857 with SMTP id
 v14-20020a67f6ce000000b0032cdcb93857mr5765079vso.57.1651132551786; Thu, 28
 Apr 2022 00:55:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: mwibergcaitlin997@gmail.com
Received: by 2002:a59:cde8:0:b0:2b1:df2c:6127 with HTTP; Thu, 28 Apr 2022
 00:55:51 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Thu, 28 Apr 2022 07:55:51 +0000
X-Google-Sender-Auth: k4F3pA5Q6SrXCwMgUD7Tz4CpEP0
Message-ID: <CAOw4te1=qdNoZqx72xCJe8oKSi9v5C+RvNBm70ArmhQ1uwur=Q@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_5,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I assume you and your family are in good health. I am the foreign
operations Manager

This being a wide world in which it can be difficult to make new
acquaintances and because it is virtually impossible to know who is
trustworthy and who can be believed, i have decided to repose
confidence in you after much fasting and prayer. It is only because of
this that I have decided to confide in you and to share with you this
confidential business.

overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on, he
left no beneficiary who would be entitled to the receipt of this fund.
For this reason, I have found it expedient to transfer this fund to a
trustworthy individual with capacity to act as foreign business
partner.

You will take 45%  10% will be shared to Charity in both country and
45% will be for me.

Yours Faithful,
Mr.Sal Kavar.
