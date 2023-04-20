Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76A96E9408
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbjDTMPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbjDTMPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:15:42 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D884695
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:15:32 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-38e4c98e5ceso264216b6e.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681992931; x=1684584931;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7dCMSjJGAVJYULPoH8k/oYToGR+HAi8zsg4GGXON8+w=;
        b=BMkmIaXdZhPQXSVJj5SwFQpuc+3JyLc37Ugr8pzxOQR4G/IeOm2e0n5n4CS34jxbPz
         XXEvR/WYy8/J0G/QerfHtCuKpwG2PHhGG1wjWgdQeNsZU+aMclyKZ44ItbbWzTVLm42r
         Y6J1SUGZDOcP8dDw25u16knvCR8DCPDHuXAQDFxVFQb7mB4O54a+fX6mHMsGQz80UQhy
         uj2vpPJnY72a7OJ7IVgjoJ7XM0hzZiBf3HA5tPw3UY4Idh8Ve6i0Eqfszs09ukaOJZ9S
         dv+0keQdwY7RiXVA0BN1X29BiN/HxUnNint+9ERbUrmflo3aXIKfRUcNrBD2vgaD//R3
         mJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681992931; x=1684584931;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dCMSjJGAVJYULPoH8k/oYToGR+HAi8zsg4GGXON8+w=;
        b=XpAa2X8/kj3YkauympvLm7MQFwWvfJ23iCOAHsRntZQLnQ/wPG1aUI0BrY1Gk1Bn5r
         cjD1SR+PyX3qRNYqqAgekH/mc8TkJcLMtr5hixd1ylV/VX11mEQ8JzPi2lRfrr/Lh6HM
         w78wHfLFogEXIEIlW8uflXLZkS/2+youS+I8h9L/n2SLuYaE1aiSu2XautVQCeLrI65S
         97K45uHEi35YFMPx2a2w+ODsUj984G7InfxcX2ccc1yeeuGbvIrh23b8Wl6RddXvlRi9
         ulhFQlJEHGkFldiyLn59JWRqbE19n/sI9fohpE8THYaVuwJq+6Jz7eZZTGrn+Q3fXt+G
         RTfw==
X-Gm-Message-State: AAQBX9fytWPVheECuzWbQaxGYbU54tWoKOKJn0iUS1w/73kX5rnyDC5m
        w0doRlv6fchTGC43spBcdpBstZ1bBi9POHNBGyc=
X-Google-Smtp-Source: AKy350Z9Nls3RIT/3HWIZNP8sHpHIMNE+k3Y1wWPlLeeDoiv/Yey1HTfsx1YLBuPOfxsitZoA0EmLJlQv/RXKSxEeck=
X-Received: by 2002:a05:6808:b12:b0:38c:1651:5815 with SMTP id
 s18-20020a0568080b1200b0038c16515815mr767256oij.0.1681992931644; Thu, 20 Apr
 2023 05:15:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:59a2:b0:110:dac2:bb50 with HTTP; Thu, 20 Apr 2023
 05:15:30 -0700 (PDT)
Reply-To: georgebrown0004@gmail.com
From:   george brown <gb528796@gmail.com>
Date:   Thu, 20 Apr 2023 14:15:30 +0200
Message-ID: <CAD+T2wY1wHzCUVYayEkVQA8CotC_0ZCEiXCqA6=6f1Z=cUeS8g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
