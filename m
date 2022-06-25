Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C655A7AB
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 09:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiFYHL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 03:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFYHL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 03:11:27 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6968B22298
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 00:11:26 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id n187so2157502vkn.11
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=jE0JLsfEdPpE7rbsOBNLVDtif/ZpFdFdV55NgbKwOcE=;
        b=TmgbPvbWRn+1JqVIbu4TUu3sW6BzLM2ygSKumFEbICJ0CZjVMhkUDVHNqwZklXK5dw
         ppK4Egn4XeVi/qO9ErDEHWhDbOvY5LC8m8B+ycRbmjGAfLDbu8ufi0i8EV6GEW2pN/Po
         GIyntJkBWDyCwMF0CfUq0AYwM7INnSljgTnzLAzmL1LnEDcdS1oKdbJiMDdJjQGeHLoc
         TI4GJtcplNZfyvbOqGoUX+jGex4KnPpWAyXcF1znJ25uAC7eXHsRNltOAs+MjV0MMJlQ
         yqwStGOqaA2FpL7RkCFUBxB/O3cR5bUcV55jwRetmO4zU8YzH2v6XymEo+ni3hwRTu8B
         O0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=jE0JLsfEdPpE7rbsOBNLVDtif/ZpFdFdV55NgbKwOcE=;
        b=yMe05V4Dnfqa8BVVCg6zbB4m/EVkUMJ4GPgPBbs5RwxfEpSlUDAgAIJaUEnyaydex3
         az3dLUtUqUtwI14Tb8VOVKNpfyXn6fmcMKAmdx6Ow0ZRdxWFwaqZdVbdsKVc7AwB/1KH
         kdRmzYs83kNIxhbiNcRdkZJTq6kyughSoh9zljjrZxFY3S1LuY7i9jda9IQiFqMVRNmn
         g9PXRFI3SYoVU8nHNmkP+V64bpyni30182xs//KiXqYrVkpYJOYSgOQ2MdY3UPLANWaM
         qeD+dcHLVQ6BpW9YGov8HTebycx3k4TlAE0tlNshNiPhInIX5Q06NxZVJ/VOQ7EPw65x
         0hlw==
X-Gm-Message-State: AJIora+H/zVbu+Z/PDhhJ6xwtR+aWNXdg56rag2+jgTDWJskol8hJ/ZG
        u3zHJ7SIRUsH9WzP6ltWXBBIRRkHsf+MXSAUSw==
X-Google-Smtp-Source: AGRyM1u/KbQ8LSBl/QCc+0r4qtZyz7l9+j6ROxQTCMjKwRJSl8kfEbONY7wbHbEr97LQdMMeH9NVYCJ41aSmxogsNiU=
X-Received: by 2002:a1f:2343:0:b0:36c:91fe:82e5 with SMTP id
 j64-20020a1f2343000000b0036c91fe82e5mr859040vkj.7.1656141085213; Sat, 25 Jun
 2022 00:11:25 -0700 (PDT)
MIME-Version: 1.0
Sender: cliffordmama534@gmail.com
Received: by 2002:a59:cbe7:0:b0:2cc:faea:7f54 with HTTP; Sat, 25 Jun 2022
 00:11:24 -0700 (PDT)
From:   "Mrs Yu. Ging Yunnan" <yunnanmrsyuging@gmail.com>
Date:   Sat, 25 Jun 2022 07:11:24 +0000
X-Google-Sender-Auth: RstNti6m4zVJu9OijlqD736tAA8
Message-ID: <CAOAvPBvbo+56AThNsiG9PqXULxYLPLz4ruBcWnG3QMn8xac_QQ@mail.gmail.com>
Subject: hello dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello dear
I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it because all vaccines has been given to me but to
no avian, am a China woman but I base here in France because am
married here and I have no child for my late husband and now am a
widow. My reason of communicating you is that i have $9.2million USD
which was deposited in BNP Paribas Bank here in France by my late
husband which  am the next of  kin to and I want you to stand as the
beneficiary for the claim now that am about to end my race according
to my doctor.I will want you to use the fund to build an orphanage
home in my name there in   country, please kindly reply to this
message urgently if willing to handle this project. God bless you and
i wait your swift response asap.
Yours fairly friend,
Mrs Yu. Ging Yunnan.
