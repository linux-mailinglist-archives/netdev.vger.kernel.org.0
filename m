Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B205FEFAE
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiJNOER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiJNODh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:03:37 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA1C38A38
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:02:52 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id n74so5684930yba.11
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=G+PH3oV0/fTkd6kqy77KyvUT5LK+8noL2kaMeUDKM0/KUjX5fVmwOU7pj05uCBweC8
         xfm0XQu4fzsMxYaUlWBTHA1NO0rYYG6fnB4/3if5ONVXYHLMXveUD/M/7lviH5daLonL
         1t0k2g6akRazJk3OJ6rjefzUeo+n5fS6Scmjj+goc7F2JkZ4PGMqzTHm26y6iCumwU1m
         vByCMq/yUQZSvWbaBn7LngHx/xRJQqKphf+zuqjbrCx7n1UYmzLa43D6NXqWei54EpB5
         Hgmi0GLFxY8pzlb/6GtyjYUMoPXTRSnY82VOoaR3EdwsmOdxyCaDWPgBMAAQObtgOGD5
         TD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=NzhfMNESuRsBa4ph0kzTMAvaggF8x2Y/kiymzJbUm3k1CwSbCbVppFA9ZGGklFpBUh
         LXXpKNDdVzvFvYgzTN6MFAzAN2kkjrVd5fHNwLY1VEHkzsUamjslZl0b6/f3vV/BNi/Q
         aPVl5sZQ/89pbOiiNAnIFNmDpOrKRZNeOLtIflkpVoR40AOoIgExJV/l/DYNT31hTRzJ
         I4de0vmfW+vMRbMQihJhG6/zMdZjC0i9DWDPGEur+JmnVAimkzwfdf21hhRqKSPbCqaB
         iFAD3iv9sEsh1vnz41wDT7rD5X0B5W5NAUoLopoo2YjeZVn2rL+iGoJT5PDk2i8Kexhl
         dDCw==
X-Gm-Message-State: ACrzQf3Lp6ePh4c+Jds6qYUvLVnY5YuiGsl/w9gfmUmL+6FICHlIviZN
        6TGTOUI8cwcOW2MFfK+IdX50s99Fi5MWhdQAWdY63GnHSvo=
X-Google-Smtp-Source: AMsMyM7PquZqT/hWd+Tt0oC61vyT5Qvjw0RxH2sdg1Bi1LtnTo+bFlowOulx3dZrZ5gfCnubsPrMrTQR3ydMcg/g1Ro=
X-Received: by 2002:a05:6902:124d:b0:66d:5ce6:5924 with SMTP id
 t13-20020a056902124d00b0066d5ce65924mr4651776ybu.320.1665756120333; Fri, 14
 Oct 2022 07:02:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:6c05:b0:3c1:5961:57b5 with HTTP; Fri, 14 Oct 2022
 07:01:59 -0700 (PDT)
Reply-To: tatianaarthur72@gmail.com
From:   "Mrs.Tatiana Arthur" <goowjarwq@gmail.com>
Date:   Fri, 14 Oct 2022 16:01:59 +0200
Message-ID: <CAC-x_XG9rA0AyZfYuHNAuuG+d=fYhmCwTNqzUGX7BPC1wG=Shw@mail.gmail.com>
Subject: Did you receive the email I sent you?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


