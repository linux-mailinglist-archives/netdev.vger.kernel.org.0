Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2737157D373
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiGUShg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiGUShc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:37:32 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B61989E8E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:37:24 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-31e1ecea074so26491337b3.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=Nc51/eQ9cQSwWCscr3iwCOjw/rn3SkxF1PeuaSGF4Ec=;
        b=G7sjysslErx+YS0OCF2BPLnhP3ZagX8PBQNSj/mQ9LTxhpQy4rRNSNkkObIqaEIzlm
         Hk7WgHDgdKb09EzeClQ9U51ge5j3vNTJnHQ81UfI8uLabmaZ6wnaFIaBnkcqlAuPlba5
         cPVXULj50Sf3G37p507xSYH1zBncckFETsRDByZ5kesbwM1s17HHHurXsvfmt28a/sla
         b8ppU3o7Jx7c+sz3QVISyja0Sbp1Cu8QpDHJcqdinsqI9Js8VEq4bfe+pk3wcxM3N+vy
         lGha7y3IqyJHioe3icSM+UfYyC1bhvpyjFP2V3L2yhTqIuCklKLhrZ2jc2ds2krmybBU
         FElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=Nc51/eQ9cQSwWCscr3iwCOjw/rn3SkxF1PeuaSGF4Ec=;
        b=YHqCCmpxh7dL8xkY/EsMY2xdePR6f0RWFdWsDtwp5yaGAhV5fcE2oQj2legFqz3XJS
         Rm7h4r1i+UiMc37D0SM1W3vyAm/imL4hL4KLTNIHP5hRD4JedD4CtzZEjfUaPOUfJ3om
         eYKOdF7jx7Eot8MNS5BMInO7HjpkJDCXXMt+feXfqZ28XUI09VDbvXmoY97WDhcDF5s/
         Vp1U1BTukj0uVCzF+dDP2KNTmjRDiWvT+EivS01uIjOw28IwhILmqH5SpVANarbT4U26
         0Gx+69ZtKa1MYOTHngsOyfuPf1ay9+1Ga0j8v4HHUew3D4kjhkZUC8KKG+lxx42iKP1W
         HlAg==
X-Gm-Message-State: AJIora/5Fb8TlL5MPRvFbrKLHfcDYZdCGZGGvcAbwgVECdn/tP8AuW1I
        LDWjNGWBtoiNuMvUuDcoDX20fyUDC3S9nxiMkp0=
X-Google-Smtp-Source: AGRyM1uxWDluA/Ka3EEDvWT0HLRqXMCCqNGYpbHFIaRYcPRPzXXI6Ary2HFn/0HBWxz1UWFHRdcDlkPXPj5gNeUwAC0=
X-Received: by 2002:a0d:d382:0:b0:31d:7ca0:f36 with SMTP id
 v124-20020a0dd382000000b0031d7ca00f36mr47821188ywd.21.1658428643328; Thu, 21
 Jul 2022 11:37:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrskarimmikael@gmail.com
Sender: lottomaxpaymentagent@gmail.com
Received: by 2002:a05:7110:4a82:b0:18b:f66e:2f5f with HTTP; Thu, 21 Jul 2022
 11:37:22 -0700 (PDT)
From:   "Mrs. Karine Mikael" <lishalu25@gmail.com>
Date:   Thu, 21 Jul 2022 07:37:22 -1100
X-Google-Sender-Auth: N5AKav1XMZV1iltMTh0SxYyro9k
Message-ID: <CA+NYc2JxXNTqfZmeT+dR0FupWg+QRByMaYtWBmRN=cU5sng4kQ@mail.gmail.com>
Subject: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello
This is one bizarre letter all my years of existence, I got your
e-mail address online while searching for someone reliable that will
assist me to carry out an urgent assignment.

I have been living with leukemia since I was 19 and fifteen years ago
was diagnosed with serious, adrenocortical carcinoma cancer, which has
rendered me utterly useless.

I will gladly give you more details on your responses to my mail.
Regards
Mrs. Karine Mikael
