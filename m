Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08A75A95A6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiIALZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiIALZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:25:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55FF131DE9
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 04:25:43 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m16so21891404wru.9
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 04:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=/UVrmSBO/Ah16d2MZfS04mIdJZMZC82FdnBLfIfZvYY=;
        b=Zgyj/PCHXa4bDjEAnzHCM12ePw46ukCksEC+2GS46f0k2eVHiNk2C1tA1hxAVUAiU7
         CrzcnJj6aPw4BfG228AA4A3LHeJQX+xoeteOfSXCrxVqz/OCjoQxdFoSDx+zXLkBPiaW
         PSb5uf0BKu+FXZku44EJQ1va7UOVBHDqEOtEhL2i2L6SMoAFUQMoR/FZ9vThEEDq2JeQ
         u7VA8eBQ3XVA4TnqKEJZyeKUS0+r30kDabZvjdaAi+nAG5BJXXNmdCbwiUwfy41qNp2c
         /e8vV6AH9PXrzsrjiuF0fR7Wto47yO3MR8f02+9qmUuDVCyuCgPvKtOYiY1VUYYKYtqz
         B8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/UVrmSBO/Ah16d2MZfS04mIdJZMZC82FdnBLfIfZvYY=;
        b=Z38q/N1mFxTZ8AlGUfRo/LQ0FQJbZG7uV6XVoy5FbCbzuM0eHK7ZpIutFXbBbK5vC1
         K9xRKIuR1lXiO9rchkELf+QzLXGXufTItxO4a/GS71Mfn++oiW8QnwMGkfGUV8YLqm78
         /Jb+xzd1vapD54AsBPD3y8/YNzmlUVoSfjfkL2169qHsdZlLk/RBZZGvP05o6B0fE2C6
         WLlDey89ddVZeURghJCHe6CFyjSC5GefFJnOupqTvvSgFVKjDKCeKoXZabF3RCnSsp5n
         SXnk78ruSfR0it00ysMfNdZF9jYSpd3bEVw+AWsIWOScd+9Z6S4P8rFtUV3a5FU5xpWL
         yq5Q==
X-Gm-Message-State: ACgBeo2dt6lnRVAvcdpVC90QTRPmP7/S/W8bXq4rGyDTq6jFw+L6tbg1
        la4okWFOh8tXhK83ZkNLblviKuoWgacZGkvI0IzHoDHZ
X-Google-Smtp-Source: AA6agR7h84oYjdcaILfCwFDXrLfKr9GfyV0MvPneu4ke1AVurm6XrEeVdwQDnhtfN/DEgC9tJSCuZGi+n9wWPZIBR8c=
X-Received: by 2002:adf:eb84:0:b0:226:dc6e:7dd4 with SMTP id
 t4-20020adfeb84000000b00226dc6e7dd4mr10631858wrn.196.1662031542073; Thu, 01
 Sep 2022 04:25:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: angelleangelle1234567890@gmail.com
Received: by 2002:a5d:584b:0:0:0:0:0 with HTTP; Thu, 1 Sep 2022 04:25:41 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Thu, 1 Sep 2022 04:25:41 -0700
X-Google-Sender-Auth: SL-1wxp_g_fBeyVDKQF-4geCy7Q
Message-ID: <CAGT7zP1YT9Gu1=0Uv2Wx6aJ7j8TO9STxqhcCRtPj6OSYgBU9vQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
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

hallo, heb je mijn e-mails ontvangen? controleer en antwoord mij a.u.b.
