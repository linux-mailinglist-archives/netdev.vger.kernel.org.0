Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75337B1BC
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhEKWwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKWwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:52:09 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2EC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:51:02 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id l12so1102151qvm.9
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=5FL0PAXdFAkGTV8+uoUJixhTCs/2flvto6lANPgC7Zc=;
        b=ZGsyQmwomw9+dJkK/QFDJZzqc2VVqnvavKF5hcukBI3FgaLEKVRCPxZVeYQzXtvrhN
         ry0GSD9P3VvLprKb3ZgH7BIqX0Md8Za4Op71VwubiRAqGc7yq4eOKZg7WCLU0ikNu5xv
         lJPFIKmY9IbdxVb/S0acSFGsgMy5033rANNTYewnJ7QXeXl6VFnSwV7XyIxQybJ0zynt
         fOW21c0AU+z7pdSaaCRlh5aDwzzRD8uWbLCL7QdSFhbo/4d/rSHXRN7Ib5ZIO+j3zw1w
         ArRL0iyqVeFqNtQfNmSHhp4+kRrw4YtLNe6kTp3yX5RzNRX9essFWMZOKCs4Yy4doJKN
         iApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=5FL0PAXdFAkGTV8+uoUJixhTCs/2flvto6lANPgC7Zc=;
        b=LhvX0NAqeH8MFqEzE7b9URYyVGbHnjxuZJDF60JuQt4U+wPqvuirKFRpUfpXgyvnwv
         dFJnshLi1RcLGPSR9u6VfPu3DubRqMM0YayxKMF64IVrXEGGde7S/xwxv0QBe2iwNugq
         52U2SM6dc7z9bXQh8m7uyN6ytzEP11bBlcxmD2vwss98m2dob8GwO1HR2B1qn7phiurP
         AEOsXrWe5jEZsKQxK1ubbG3t0g6RkW9uvyY51LceBGMSdQ2+S8/QldNJE4zIlZcXmqDD
         1tXdH6ABn2mEQiftd00m1JMLPR30iHGaAX9KLtgVmdDeldJCnWLZHFW5iH1xBhpt/UB7
         reOw==
X-Gm-Message-State: AOAM532PgXcz35fN7w+zpRj3MOSHCM26BT+PO8v8MrcaByTdcCn49Plo
        8QrXfO5be49kwGeJ48CpZrrSBQS3s1Y=
X-Google-Smtp-Source: ABdhPJwOY3WhaCzeE9JuS9nsUdLLhAPsMEeowD0BdxvldQRSzUg/gsfklrf6P5MCaELOgR1BMqwn1A==
X-Received: by 2002:a0c:e242:: with SMTP id x2mr31755186qvl.45.1620773461815;
        Tue, 11 May 2021 15:51:01 -0700 (PDT)
Received: from [192.168.1.214] (pool-138-88-168-130.washdc.fios.verizon.net. [138.88.168.130])
        by smtp.gmail.com with ESMTPSA id m22sm15466993qtu.43.2021.05.11.15.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 15:51:01 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Urosh Milojkovic <uroshm@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: Project
Date:   Tue, 11 May 2021 18:51:00 -0400
Message-Id: <3BBE9297-5ACE-4A7F-AF9A-4EAECD81E23D@gmail.com>
References: <20210511145036.3DB57174FC0499A0@flippiebeckerwealthsvs.online>
Cc:     netdev@vger.kernel.org
In-Reply-To: <20210511145036.3DB57174FC0499A0@flippiebeckerwealthsvs.online>
To:     cpavlides01@flippiebeckerwealthservices.com
X-Mailer: iPhone Mail (18D70)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello I am very interested ! What is the investment ? I am always looking fo=
r these opportunities.=20

Sent from my iPhone

> On May 11, 2021, at 18:38, C Pavlides <cpavlides01@flippiebeckerwealthsvs.=
online> wrote:
>=20
> =EF=BB=BFHello there,
>=20
> I hope this message finds you in good spirits especially during=20
> this challenging time of coronavirus pandemic. I hope you and=20
> your family are well and keeping safe. Anyway, I am Chris=20
> Pavlides, a broker working with Flippiebecker Wealth. I got your=20
> contact (along with few other contacts) through an online=20
> business directory and I thought I should contact you to see if=20
> you are interested in this opportunity. I am contacting you=20
> because one of my high profile clients is interested in investing=20
> abroad and has asked me to look for individuals and companies=20
> with interesting business ideas and projects that he can invest=20
> in. He wants to invest a substantial amount of asset abroad.
>=20
> Please kindly respond back to this email if you are interested in=20
> this opportunity. Once I receive your response, I will give you=20
> more details and we can plan a strategy that will be beneficial=20
> to all parties.
>=20
> Best regards
>=20
> C Pavlides
> Flippiebecker Wealth
