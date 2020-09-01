Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BD259FEC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgIAUWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgIAUWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:22:34 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD1BC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 13:22:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id u126so3037006iod.12
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 13:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=67qkZ2bLgVOwzyCtWPnFwxPWvtPKNu8i8ClL4e0Oee8=;
        b=O3dDhILxU169qSG7ZyW92+ClWnMBCPZeI2XrIRw2I5zS/zM6l31bUrq8UX+fxsCIEA
         E5Zg8wTcYKTWIS3YyBk6j+Joff/cFWofQyHaKmeJmgTpvmGxekevZZOgiIuOcU54K1iX
         Gcu94kiDEjfeLi0zdZTsrgCJ8hGjhO8AX70xIzUrtFQrNsHmaGJu2aI+FaRbguhWa14H
         odQh9jVnqGvuzv+iMTXdB3cIy3+rSW42i/03UETOEt/zuNVp0yk3s7K7P+SFfrI29Rav
         vpE9ZXPl37nv0V7PtWSRfRB4g7SATuKp7tjLUdSFDLs3051RQnhOt47jhOoqSP04JUxS
         Yb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=67qkZ2bLgVOwzyCtWPnFwxPWvtPKNu8i8ClL4e0Oee8=;
        b=rIRRSYs5nzc1QDJhrnEqcA9DIzeXL/X93mWNJDf+uUchGtQy1uFVJoqaX4eDNKau24
         L3V7Js3oGVW0G11QEM3JSBfW585fhLQqMZQqE+nSMvZVm8vkp4sSD6jevCbydvUZ9GT3
         yDkhflAiG05uuS86/cNuCai3ta5uF5eNpWvWtVeSAax+8SPVypj1ll79eVGBUlO/eiCU
         jz1TzWmTt/sAofsD9s9drotx1KDWVfm8BGtWIbYBuJPTBbsVRdrV2FXNO/LRxBkesykf
         cryGD/wheyxtRPQGi9rHDCsSubAjmZUCGLd32kqzgOXSlCUUO8qNl5rnyO4N3pYXx5Z+
         COfg==
X-Gm-Message-State: AOAM532ZLdGYgJi2+efzay2JDM4AzOivkksqRCLDvdaMWB7vh6D4vwHf
        KcrmiG5pEoHNx1WWDwcR3GS1YFbjnCpZwg==
X-Google-Smtp-Source: ABdhPJzqkq462ASgRLhrInzjCTwrVP2Wm2J5MgY0Y+QHH/QM9Qin7vTRBQyUESSQSLOUYV/3wriuKQ==
X-Received: by 2002:a5d:9ed3:: with SMTP id a19mr734528ioe.28.1598991752841;
        Tue, 01 Sep 2020 13:22:32 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w19sm1101260ila.25.2020.09.01.13.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 13:22:32 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alex Elder <elder@linaro.org>
Subject: COMPILE_TEST
Cc:     Networking <netdev@vger.kernel.org>
Message-ID: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
Date:   Tue, 1 Sep 2020 15:22:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, you suggested/requested that the Qualcomm IPA driver get
built when the COMPILE_TEST config option is enabled.  I started
working on this a few months ago but didn't finish, and picked
it up again today.  I'd really like to get this done soon.

The QCOM_IPA config option depends on and selects other things,
and those other things depend on and select still more config
options.  I've worked through some of these, but now question
whether this is even the right approach.  Should I try to ensure
all the code the IPA driver depends on and selects *also* gets
built when COMPILE_TEST is enabled?  Or should I try to minimize
the impact on other code by making IPA config dependencies and
selections also depend on the value of COMPILE_TEST?

Is there anything you know of that describes best practice for
enabling a config option when COMPILE_TEST is enabled?

Thanks.

					-Alex
