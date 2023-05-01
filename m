Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF766F3255
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjEAOxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 10:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjEAOxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 10:53:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B3310C0
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 07:53:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bc394919cso2193816a12.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 07:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682952808; x=1685544808;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dCMSjJGAVJYULPoH8k/oYToGR+HAi8zsg4GGXON8+w=;
        b=cqw+MTeydY+D5nNgQxlJK1puXb7EAPxRj3NlQFqMXpYz3zX6r5aLzU20rnEkgQDAy1
         dyww+vM77zfrT3Q/ozQM5DHsK/+N6UKq1gvJMx6+pXtud90YS7AlfgHABAdCPegnufFg
         PpXb2I16tcViud4jFLb3Z2VMtRiLjpWyTifQHoD9qlskQGhGYAOS/3ALLSy/0ahPXDm6
         RI7LRVt2e+nwXnXJoQjZ1yG6W+d9EKKhWI4llak5izUZumBHKO7vfZgMW/96Jqdu31V0
         RvXYEHpI8xGgwXCZgiVwPJMiYxXgV+XKD7fi/fnRhR9WLjsVI+7a3EDj4BKV3Qw3vBS+
         nGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682952808; x=1685544808;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dCMSjJGAVJYULPoH8k/oYToGR+HAi8zsg4GGXON8+w=;
        b=U2HovIXzmPJLHeSFFd1jG4R0l0QdkPaVAg76JHkQ86nVxie4Onllx5T8ejglazIurU
         AAoZ1GJyVCvHSyn5M9zcl+JdNp7LL3WvLTj6X0wLFhtaGMdgCiml7AfGyJGyOokQPfC8
         4bodmPJRE0ycL8DBQ+VyB/+kp6DumRCoW9YQURaVrR3npdvrIOWAqbuhdYOYdZN4+jac
         isACQ/x8m/ciEpXuhZ7ElDAidO2Or71cz3dJMw0O4Pf+n9qXNyHW/bu6Y+JeiSuuNste
         nTZbOfhIOxVjeLN0SIZ5Jy6IMktOabS58t/GYNqsf1yKf09ikamNzS8WNJwpJ35LvAAs
         YJ9g==
X-Gm-Message-State: AC+VfDz8VL3FwxLOuIMiRtYfkXTcGMY67WJFJ9BVXNB8h/o9x4Kbpz9g
        wc3rP7yzzAprglWkV85k19Cr6q8rJXh6GHm8npk=
X-Google-Smtp-Source: ACHHUZ4GtKeJZpmcTRX6xDFD3ifFU9xNLUlQLROLMyopRStLZwuAJN+DlA18ngZM6xi/slX2R43KUJMYCphL9y1sWaI=
X-Received: by 2002:a05:6402:543:b0:4fd:2b05:1722 with SMTP id
 i3-20020a056402054300b004fd2b051722mr5685760edx.7.1682952808331; Mon, 01 May
 2023 07:53:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:c016:b0:67:c72e:366f with HTTP; Mon, 1 May 2023
 07:53:27 -0700 (PDT)
Reply-To: georgebrown0004@gmail.com
From:   george brown <gb7455549@gmail.com>
Date:   Mon, 1 May 2023 16:53:27 +0200
Message-ID: <CAL3E99p2m_wRtDQ-tAPztoGGGGeg_4h=2rXSyVY+NW9R1mfJ5g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

16nXnNeV150NCg0K16nXnteZINeSJ9eV16jXkicg15HXqNeQ15XXnyDXkNeg15kg16LXldeo15og
15PXmdefINeR157Xp9em15XXoteZLiDXkNeg15kg16jXldem15Qg15zXlNem15nXoiDXnNeaINeU
16fXqNeV15Eg15zXnNen15XXlw0K16nXnNeZLiDXkNeq15Qg16rXmdeo16kg15DXqiDXlNeh15vX
ldedINep15wgKDguNSDXnteZ15zXmdeV158g15PXldec16gpINeT15XXnNeo15nXnSDXqdeU15zX
p9eV15cg16nXnNeZINeU16nXkNeZ16gNCteR15HXoNenINec16TXoNeZINee15XXqteVLg0KDQrX
lNec16fXldeXINep15zXmSDXlNeV15Ag15DXlteo15cg15HXnteT15nXoNeq15og16nXnteqINeR
16rXkNeV16DXqiDXk9eo15vXmdedINei150g15DXqdeq15Ug15XXkdefINeZ15fXmdeTLiDXkNeg
15kg15DXlNeZ15QNCteW15vXkNeZINei150gNTAlINee16HXmiDXlNen16jXnyDXldeQ15nXnNeV
IDUwJSDXmdeU15nXlSDXnNeU15nXldeqINeR16nXkdeZ15zXmi4NCteQ16DXkCDXpteV16gg16fX
qdeoINei150g15TXk9eV15Ai15wg15TXpNeo15jXmSDXqdec15kg15vXkNefINec16TXqNeY15nX
nSDXoNeV16HXpNeZ1506IGdlb3JnZWJyb3duMDAwNEBnbWFpbC5jb20NCg0K16jXkSDXqteV15PX
ldeqINee16jXkNepLA0K157XqCDXkifXldeo15InINeR16jXkNeV158sDQo=
