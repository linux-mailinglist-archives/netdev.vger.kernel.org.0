Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4DF5473A2
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiFKKLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiFKKLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:11:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD137C39
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 03:11:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 25so1681095edw.8
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 03:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fE13mG9CKvIUbMO9JtlL0pZ2ijxEEYtHb1Jlhe49Vto=;
        b=lEi35FKLPLvTX4V85cKVN9rW0PKI+0An7uK1c53oNl+MjC2LCid2nW7uhaw53UGdkl
         8dCfPOzOqz+35y4DMRly2kUoH5SuzcYnymjIBVsipHhrVO2nqIbTFFgWsH3DURbNsim9
         Xbwb75VnpIU0zlyXFOoizRPSpRTe+C8GSf1YS3s/9Is4N5Im1AAJ4mHYPv0+T4ODE/3+
         W9A7CW653hF6rlLMA73SZXcYRJE+21Lfsn/4XbLe9beBrHkfilv6RilMSRqPxnBOUWN8
         5eTu7z0Gq9QFssghmbw+PUtIkSr5FdB3u4wmKVhmJNutLbGHM1aMWEBZN8tHBXVczi2O
         0ZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=fE13mG9CKvIUbMO9JtlL0pZ2ijxEEYtHb1Jlhe49Vto=;
        b=gKD3yd26tDvJA7wIXPR9ox0RXdJuht9uxZNgZJD2iOa54LvP1dcazXuSjuevmuQpYE
         Bg2t6CGRgbnHmpyNzXAbpaoj24jtMIA3q2cC1ZLlTmqiH0Wuo0xw/MDaCLz46O2AocJA
         zfRH0JiXEo2JgP/NW2vFmLz7XKalWPDlTyhd4EdXnqLw98/BuhD0X7MW0hAvnTHVG1Ta
         nm4YSxzKM/JmmHWAox0tWj6APt2NPHSi9jmtG+cgLRZp1Co3IK1OEdlkPWiTsVYCkN5Q
         fGKZ3P+CpQFO87OUk/MLwf07lzFUdDYJJhmXa5FOp07JPUfFR4z0vmRfE22Wgxhuf/R0
         5H8Q==
X-Gm-Message-State: AOAM532PvcFC730/9/FcbSuJiO1eZuzZyADix4sXd1ymNTqRGzrOxa9b
        XW2IGD64GeehnRH/ENERjOItm0Dc2CKVfrv5L7g=
X-Google-Smtp-Source: ABdhPJxmSrUuHeAQ/fBQ8ioqbon5qU7QC4uS9c8Rzx3QMIGIstpSg3q8hQ9WEjLCH5IQaUzub+C1IxZMBCaH1EBhAkY=
X-Received: by 2002:a05:6402:50d2:b0:431:53c8:2356 with SMTP id
 h18-20020a05640250d200b0043153c82356mr36118348edb.300.1654942271324; Sat, 11
 Jun 2022 03:11:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:64c2:0:0:0:0:0 with HTTP; Sat, 11 Jun 2022 03:11:10
 -0700 (PDT)
Reply-To: schlumbergerrecruitmentteam@gmail.com
From:   "Schlumberger Oil & Gas" <schlumbergernoilgas@gmail.com>
Date:   Sat, 11 Jun 2022 11:11:10 +0100
Message-ID: <CAF-xUUhhHD33y2EW9T6DP1cUgtCiGy4cWht9P=20E4kpHuy0WA@mail.gmail.com>
Subject: ONGOING EMPLOYMENT IN UK
To:     optionsschlumbergernoilgas@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
The Schlumberger United Kingdom, We are recruiting all professionals for
our ongoing project . Salary Rate from =C2=A3 2,000 British pounds to =C2=
=A3
65,000 British pounds depending on working experience and
qualification, you are hereby advised to send us your recently updated
CV/Resume with the below information if you are ready to relocate to
the United Kingdom.

1) Your present monthly salary in the US .....?
2) Expected monthly Salary....?
3) Are you willing to relocate now.....?
4) Your present Position....?
5)  WhatsApp Number for interview

Thanks,

HR MANAGER
The Schlumberger Recruitment team
