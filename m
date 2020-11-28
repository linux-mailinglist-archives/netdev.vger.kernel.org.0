Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C02C73DC
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgK1Vtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732116AbgK1S6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:58:05 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08DAC02B8F2
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 01:25:48 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 79so6727302otc.7
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 01:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4oet+itYy/FpXawBAaYlSSasvmt9XsmpImb5CX/K3EY=;
        b=dHW2LjXVBjFYAyMFr1vFRQsCVTrQrB9i4c93Nyd02WIcKiIX+Qkuu9gdG3jwZNBF9r
         RH/mwrRLdUqeeGsqEIgxoZ6jVtFi1ht+G2v2uJTC/BB2mh1moKStZq74QnwkdUj6V4L7
         eMXkgNgYUI7sx9jHNANn7kmF+gIQGJW0c4+0eRna5ZbwNtKK3xOFPB+AXLXSQMERv08E
         Qo+dS1jcOpbuV9BrdiTe9Vw855DKLvr8HDHfPkYh8FpooAjjB7IUbtRJHfvVraPgzb/7
         IQWs3UMP/4ZJBOUAMhS3QLliAVBJ3rPMMhiFAsmrX9/aFjD5vgzi8uBI1p+35zusBw15
         N5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4oet+itYy/FpXawBAaYlSSasvmt9XsmpImb5CX/K3EY=;
        b=NJzZVXXUxb04JMou3hrA5ovS7piRzPTS94pnAIansLufi8LKDlnS66wn687OoBz+aj
         kxsywEzeqtqpeh9OP5sg2qiOklnpHwOuBuLJdBLuBqfpuQQ2IxEOrPLNa/8Q0duOA6sp
         KX1wT687e2bSo4Bsg81KHF/9ARcE2e2UBO+XqhXgu/uVAfC2TPYI8VEClXRohA2Dfgka
         07clDudMWzgijxN9PfIeBlSuyRU5uLgEQ3aQLJg5uLbXY9LSsHqtY5yretPHYjoPPfVg
         2Oq79YaRLXprounYyvUOqk3h7zvc11WJqfTQ4P64meSx6Tz4+AT06rs0/iJrHiVC2Q5z
         1epA==
X-Gm-Message-State: AOAM533f3jbLYClI5dDUO640JS14pn4pbFXe06g9drI7FRrh/KC1aXgL
        aAAcpfhQu1gEFVbJNfUrDc8g/vHYUPgvA1coNcI=
X-Google-Smtp-Source: ABdhPJzq8iD04ikCiTf4HY/M9BawmOt5Dg+LgLyIJhTWftJoNhnaGMjssgQP2Hu4tL8Zy4/TmEjcWVSuKyMe7nOTXis=
X-Received: by 2002:a05:6830:18a:: with SMTP id q10mr9285127ota.54.1606555547126;
 Sat, 28 Nov 2020 01:25:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:1924:0:0:0:0:0 with HTTP; Sat, 28 Nov 2020 01:25:46
 -0800 (PST)
Reply-To: xinclark@gmail.com
From:   Edwin Clark <hagabenjaminconsultant@gmail.com>
Date:   Sat, 28 Nov 2020 09:25:46 +0000
Message-ID: <CAJ7SCJKBXeuwguv36JoKKcY3dRY-q5QvNXzKQcvuM_zRxyjiWg@mail.gmail.com>
Subject: =?UTF-8?B?0K8g0YHQvNC40YDQtdC90L3QviDQuNGJ0YMg0LLQsNGIINC+0YLQstC10YIg0L3QsCDQvA==?=
        =?UTF-8?B?0L7QtSDQv9GA0LXQtNGL0LTRg9GJ0LXQtSDQv9C40YHRjNC80L4uINCh0L/QsNGB0LjQsdC+Lg==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0K8g0YHQvNC40YDQtdC90L3QviDQuNGJ0YMg0LLQsNGIINC+0YLQstC10YIg0L3QsCDQvNC+0LUg
0L/RgNC10LTRi9C00YPRidC10LUg0L/QuNGB0YzQvNC+LiDQodC/0LDRgdC40LHQvi4NCg==
