Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FAA56388D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiGARVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiGARVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:21:21 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB901EC4E
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 10:21:20 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id b19so3378630ljf.6
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=djGKhvUF8lAsiTuKU98fE1SgBbCGkJsAmy7BmMcoar8=;
        b=WH57HSoESSWFG03WtB42aSII3ybmPCTqTvpZAhksGrqearL411lnxCCe4Z9/xk0jMQ
         i8DjVlzlAlFKV7w1Fjlua5C/pSIHosbLG5Zk0ji2TcRHADCXXBq8tqP/hPEgOqaCffrW
         Rz3ZKbboXMweCLRVwJvpF98522ZfnZJZ/j3vYlLNyQoLE8X8xN8Pb8PyMJcGepszO/kP
         47UdThzyHJdt9eZ6IZHhc7y+zKXcuaSqj+H1px7DgQqr2S2M0vIId/SRpMvHsqOjFMVV
         GQ/QwckKCiLyuPypOE//j2KQ12fvtYH68mcXyN56g91CKtnpJiCr0aXXlZ9enq2qdwRS
         VYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=djGKhvUF8lAsiTuKU98fE1SgBbCGkJsAmy7BmMcoar8=;
        b=YFakc7IA/3ptusDAjc2SU5rn0MkhvfVu6CXrp2siQUFPp4CI3jE3LfUb/6uSoqEv4z
         MT5ckeewe8m3NP+gSqPd99H6PkUVK5E5DILcx8dJuysv3mKsaLWSO+nCdKPBE5KdUGdj
         cItd/kSeycTf3nnC2kcXoupU/1BacEIA/RuJwgdFjJJvLTTq3/fxrTEbrbN0kBMM1cNb
         229veF6qFE1rRpf1VsOkNdvHRQVDAm4QGrBCuTeirA0d3PYmeaS+txv04glypOM9WBk1
         hE8WYIc/K4o33o0/Xo78Mrt+NBMgHfIAfzybMbuPu2cRxqh6mrQlvHAMZOKyv8Hc3Kro
         94dQ==
X-Gm-Message-State: AJIora86wcuO+k7IcJg9+IgOdfGoGyKDPwPo598daczCsDDcY6KFXybr
        fIfrHKON3jLucj3RbKNnKahA/eZfroGmUeXMJzQ=
X-Google-Smtp-Source: AGRyM1sENq+lcP6VdBDPa9QsB5q0gTQrKQfg+FyR8oxbyF1CQEH7Rim01SbPs/JbfLX+m8ZboeTlIGL1lVinnN5F8RU=
X-Received: by 2002:a2e:9e54:0:b0:25a:729e:5955 with SMTP id
 g20-20020a2e9e54000000b0025a729e5955mr9342415ljk.328.1656696078664; Fri, 01
 Jul 2022 10:21:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:691:0:0:0:0 with HTTP; Fri, 1 Jul 2022 10:21:18
 -0700 (PDT)
Reply-To: ukofficeimf@gmail.com
From:   IMF <stefanbarthalos.55@gmail.com>
Date:   Fri, 1 Jul 2022 17:21:18 +0000
Message-ID: <CAE5vDkL9G+t0hpq28XF5SRTYsuG_Gnb9RE8qkCnjxvRR26EO5Q@mail.gmail.com>
Subject: Good Afternoon from UK,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Good Afternoon from UK,
How are you? we guess you're well, Our office has sent you a message
last week, did you read our notice? get back to us upon the receipt of
this mail.
Thank You,
Mr. Hennager James Craig
IMF Office London United Kingdom
