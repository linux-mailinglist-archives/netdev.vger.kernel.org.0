Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B136E778D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDSKjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDSKjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:39:24 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C1BB8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:39:23 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a19so7397402uan.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681900762; x=1684492762;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9BR2Flu4pkd1a4nvfS2bzE5dKgIoEcx7rGGrDf0cD4=;
        b=MKWBAdrGe29DaBzeRFySjThQhFLYG4+0/wlYgxznySzh7A3HVdCkraoOP8IiPkhFVt
         6cDxeUQMC2Q8F/ZGKKWBLVodiqoFb6D+tgzX0yzpMW/PprZxZGNaILnrYFsymzpltek7
         P1shoNcIja/EilAGEykasTaHFZLrWjK4iZJo6XeCxRKcZpEZCXsLzOD2FO+wFHmOlHe/
         jk/FsZRdO4BRTfBboJ6JWUPOWa9qp3/kBE17Y3qzX8G3EuKs7Ya5b19uSJbigeRYdYCm
         dFfpwI/4enDQ2ThhoMRew6ZxfRj0gsWRLzdGQqfPMCAHdrt+eP2/FNcwgffngQE28+QE
         catQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681900762; x=1684492762;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W9BR2Flu4pkd1a4nvfS2bzE5dKgIoEcx7rGGrDf0cD4=;
        b=HjVI1DPeI/lSn7wJ5ylr3Wq2qocxoHW57m0jHQYJZ8w+IH3N2r250+yxLq1fX6V89k
         C5dc/iynv8Ro+iyVm59TxjEOx4vyJ2kKDwMeQBDhCpVk4LRYIdj8fAXBZtwcv4NBTpPd
         V0q2d7nax4nB+IyFLzXTr7qz8m6IjI3YnlxYpT5NudchGTL7oZpDUrkXAhutwRYDnYjE
         cHzqzZrkrCgk+275jgP02eZImwaD0Va+0/PyEBLbscJBtmAkKzo9AnAFNPYn0DAff5DZ
         tfhTSYAko3sh5D6NGTT35ruVYROaE7ubLYcFJRVLvV4vP9A+1ic4JVGo9pok05jzXc9p
         66IQ==
X-Gm-Message-State: AAQBX9ezzNOr4qX/NGsnBfk0NgLPfCDpenvRnOwtY/fxCZ4dHVWh51uW
        K7xwHfe9+9u4cDPY4U5RW2ls4JoBOtl11Cx6R62TaVyI/AwUPA==
X-Google-Smtp-Source: AKy350asR9TdY1VSXeQKqkzECwcA0e1HLyPgrISB4+PgN0lorNyxZLN5bRVLD6YRBby3Zaed0P4B6ZbCquqkAZiR+ps=
X-Received: by 2002:a1f:e445:0:b0:43b:ead4:669e with SMTP id
 b66-20020a1fe445000000b0043bead4669emr6581873vkh.16.1681900762038; Wed, 19
 Apr 2023 03:39:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:cb0c:0:b0:3c4:f0c9:1ad4 with HTTP; Wed, 19 Apr 2023
 03:39:21 -0700 (PDT)
Reply-To: hitnodeby23@yahoo.com
From:   Hinda Itno Deby <amasylviagh@gmail.com>
Date:   Wed, 19 Apr 2023 03:39:21 -0700
Message-ID: <CAPVC9c=B_J5GCzOeVb-4qi_QG0sMdvBssxXm_-CTDPBPDSTbCQ@mail.gmail.com>
Subject: Reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:932 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [amasylviagh[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [hitnodeby23[at]yahoo.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.6 URG_BIZ Contains urgent matter
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello

My name is Hinda Itno Deby Please I want us to discuss Urgent Business
Proposal  if you are interested kindly reply to me so i can give you
all the details.

Thanks and God Bless You.

Ms Hinda Itno Deby
