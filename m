Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0B52CF1D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 11:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiESJOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 05:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiESJOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 05:14:41 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F143157117
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 02:14:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gi33so196073ejc.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 02:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=a4ll8aDKOBvHeC+cqfpQB63f0W4R6TC5LipT6cTBRWSzQd9kuH2XlE1bRg4/Q29LG0
         UVMzD8DzHVAYlJLBbnmSsevN8lsns9p0aEvWkHc6doQ7kqnG2JYRPwL4uyEH4w7QVPDk
         EuHdxd99ec6R1Bj5raDvZBnMPDgrMq2SEZvoT5jAe58qi3lHdgVGotrHco4TzkyY613U
         /gadkTzbFn/BqgeBbh9Yln+eUAcKMJ/UgKYWcjBu6a3iTsgQVrh6MJLH9ajoloWrGY0a
         TjBqg60hMQ20m+fr3Ndk0QFNRp4nFEdU/lm9TltlSetLuk/BrPH/F+Mu5unXwogn2HeH
         kjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=LaCX3m1KJI2OttePfk1J288u1ironDGTQLR1ieSRoueBNiR5JWSJhsh7Yn0f8beoD8
         PgkPAVLwO9FNcnNNvAj5ZN1RELWIbAS9908SXajW5vrhzMZsk6Gx+lOp3cKgRoT1ugka
         nkw/tnxOK3w0n+TvZv37EnkwXBfN0FFPMgxcN8Pk2ixE9N1uezAB3pcsmEspiB/ZIJ2p
         5QUkCRn3SDPNsc+GC6vu7wjm1lEmLVCR85mWQK60RcdH+1340v5pAqqdqmhFbrt5WYyM
         /eB0gZVPVAUD+Bo/aVIhGSICGkyTRRwRYm0Mc0G1nUNKS8io5yPDi9MvApHPDogOyI4L
         B/vQ==
X-Gm-Message-State: AOAM531X/Pc2ui+Ja2AHp6a3xQRJVr7JVbCcnC3+EwJYy54MZcVpNHlH
        U0p17Mf1Okp1Z8Q3WN2S7oFmyEhpsnQMJg9AYOM=
X-Google-Smtp-Source: ABdhPJyT1MJwwJtRUcXucMSZsTiy6HMLP0VKNECu+1QDjD6TSAMnPnS/kDeW4QpkBYSXOiRaV2bC293j/yB06cXgFoY=
X-Received: by 2002:a17:907:1c25:b0:6f4:342f:51e6 with SMTP id
 nc37-20020a1709071c2500b006f4342f51e6mr3269554ejc.740.1652951679021; Thu, 19
 May 2022 02:14:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: mr.bellotom1@gmail.com
Received: by 2002:a54:3304:0:0:0:0:0 with HTTP; Thu, 19 May 2022 02:14:38
 -0700 (PDT)
From:   Zahiri Keen <zahirikeen2@gmail.com>
Date:   Thu, 19 May 2022 11:14:38 +0200
X-Google-Sender-Auth: z127tKUITmIh_b_JvBVg5pnXVzg
Message-ID: <CAEF+kN9oURWyVz6Jmuv-6fgygF99dieJXQUVzp=GRqvh1Asy5g@mail.gmail.com>
Subject: Urgent Please.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:641 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mr.bellotom1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mr.bellotom1[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
