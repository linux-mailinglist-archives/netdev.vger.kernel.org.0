Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8516C5011
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCVQI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCVQIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:08:24 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2192448A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:08:21 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 14-20020a9d010e000000b0069f1287f557so6271457otu.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679501301;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZeK4ZJ1o6tGrUVsDjmi+mms9O6S9hGyBZoeD/hC1EM=;
        b=T6dsWhnnwpqjgCudnJ83LfawYyUkns/Vgoaag9OMpo8j0Rc+fEyelIffnzrawGEY7M
         HudoCDUSo9dT5/EO/LynVf9T9bl7Qo5jVX6TYkK7o1upQwk4tkz4xQu5FiXNucEUOgms
         Agxx2EcZv5MV8kr4nesazbcm0VbMDdNR/WjcpqpPkJjP/lCGIXVSW53E1hjVoc02rA2Z
         N+qW5JVG4my4UYXoHMr9Mfi8chbdsfaBmqkr3dRPtpOyR1s7AxJ4b6m3FY1x/yYkpR7v
         2UIovtmPe/H0RQqV5X21bML9aio4Vc8l9/dZubwaHx5UrH/+TZ4fObJKiYFcRHqTf3QM
         hsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679501301;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZeK4ZJ1o6tGrUVsDjmi+mms9O6S9hGyBZoeD/hC1EM=;
        b=Dxc+RlyOZPmZ98c1691zuoNH0GwZ7q/MfJTNuFTUSpSMhoN5djFszN8ybPSdVp1DdT
         4JxAFE2drTqAna2Q6FwLFxsPha6hUTQOWizV+zjDHjJhEWCZZJc0LVVSS5YabZxRv/ag
         eDnoGCtZDZtEO3kwMrhnYshjyxlN8MJwE7Ls0bapuygPF4h+R7S9gdkHe4/rKBSg5J6g
         dwjGoVB+bNOzDh2V6rS33Z+MFMYU+4pptiz7MZOGZKY45fe5PYURlTE66DZe+YPy52o/
         91ZqdprqNRyiF299ohtd/b+PPX3pIgg4zL++mhGaIIYR+s/zD8TYH4DsSzU3wNTA1clC
         MmXw==
X-Gm-Message-State: AO0yUKXBTxp89kHHNe0RoQtIGwmumFtM6oXjvdr/+el+lwfga6QQFhNa
        cklQt6dunJVicBe2x/0uM90DGbiI0hE50b0FKC4=
X-Google-Smtp-Source: AK7set/I1KCN0rWQo35imQYLg84WfvY6tW/8QovGImwQAEN1AVk0vreSpcbj/JK/n6FCsRhai5eeBpRlFqn3Ketrw5c=
X-Received: by 2002:a05:6830:1441:b0:690:daac:e823 with SMTP id
 w1-20020a056830144100b00690daace823mr1305682otp.2.1679501301012; Wed, 22 Mar
 2023 09:08:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:3d45:b0:111:8854:d0e7 with HTTP; Wed, 22 Mar 2023
 09:08:20 -0700 (PDT)
Reply-To: fionahill.2023@outlook.com
From:   Fion Hill <youngm8819@gmail.com>
Date:   Wed, 22 Mar 2023 09:08:20 -0700
Message-ID: <CAKE2LTaSYVzXSrVf+ZGEqiCSvR=fuEbWKUqtyJsHiODak9a53A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello friend did you receive my message i send to you? please get back to me
