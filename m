Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA6959055A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiHKREr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbiHKREa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:04:30 -0400
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66015BFE97
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:35:34 -0700 (PDT)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-116c7286aaaso6198732fac.11
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=Zczd81LNv1xHVJW5LMHbnrfWpLWiMppZkaou/EB+Esg=;
        b=kmINe7WZ1opzh8b3nAhaU/2SSw88sntzEe9tbx/lxmIWCgVhdXQZ+tc6H6Rq1mqYDo
         Dkb3ySFNTkth07u5uiUH4hZRfz4xPzYhdSg90V4P1e6Joew14GUNEF01ucl/luI9pJOL
         Ok4EaZq5bPNuOdX20oQ7OUMCnkIc7Kl/qZL4afg76sWjAd0Kfu9OXYGZp7IHbIGmfRYO
         wHp5PxiiFxpUFL5luuP8dvF+zFqeUR1hwV6BRpg9XPzcZjRUiJ9AfS3pEY2Ppe0hY4qv
         3j28sjdcbi/7Zj0XtbZrwJIn1RIPNmKjRjx/XfaGj8GfZlaCYWaGlmaXPQyaPhaKDxN0
         Jxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=Zczd81LNv1xHVJW5LMHbnrfWpLWiMppZkaou/EB+Esg=;
        b=EzxAsEZbMMhzLtqfRFjKSNAW+CRJ3prhsHmwCBCBIza4LD4qdTKiq8dFfMnQ4eIvFW
         qA0RhoPHGN8ehC+8vep4gwi+dlM4bUDOz6lqL/u/4/tA5OawLtXelAdDjft1tagz4TjK
         7HNAJ242BOoX9HE8vxWYyVWK5tqszShET6zn8VNwDCkN0xjRgRXbj9oKPgRbQfKB/jeW
         f/EdwRs5R1rzbIPlsY+t8S0JZs4OrLAlEQklSa3m5nYXJKoOvHUcV5eMdYPGfmAuC+Tp
         Ke+OTiVks0LNbPj4lcNAiX93XPojk4GXWtbbGEozwr+hkgxp+KN57B9RBGI3bWY7VNb/
         bHWw==
X-Gm-Message-State: ACgBeo3lLyrhHuDwIO5Jx/YzAsL9eeaPJ5TUnv6zBepE+p7aznzWHspE
        JwB50988vVjsoE/bmnKr8k7251CZqsEzPgSkvB8=
X-Google-Smtp-Source: AA6agR5lnZsWXBMV9JTu2soQ1lOHfgykO8XKKm8a5FxBBjmzhPRqKHHm7uYsad6/jdrC1GQYHX3jCYK0CeP/QJgJnSg=
X-Received: by 2002:a05:6870:a689:b0:10c:289b:78df with SMTP id
 i9-20020a056870a68900b0010c289b78dfmr4007611oam.25.1660235732122; Thu, 11 Aug
 2022 09:35:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:b507:0:0:0:0:0 with HTTP; Thu, 11 Aug 2022 09:35:31
 -0700 (PDT)
Reply-To: ubabankdirector07@gmail.com
From:   "Mr.Peter Usman" <mtoo77272@gmail.com>
Date:   Thu, 11 Aug 2022 09:35:31 -0700
Message-ID: <CAKJY4bzgHrwg6ckVBW6p06Fq5wqA9ytFm5ZX=xP51LyAAe0TzA@mail.gmail.com>
Subject: ATM Card Owner
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mtoo77272[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ubabankdirector07[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mtoo77272[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attn: Honorable Customer,

This is to let you know that your Visa Card is ready now and the part
payment has been credited already as IRS has signed it. So contact Mr
Janny King of UBA for immediate mailing of your Visa card now. The
amount is $10.5USD

Name: Mr.Janny King
Email: (ubabankdirector07@gmail.com)

Thanks
Mr.Peter Usman
