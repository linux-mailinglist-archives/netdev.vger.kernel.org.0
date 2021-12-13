Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14A472D8C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhLMNkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhLMNkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:40:00 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F92C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 05:40:00 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso17386174otf.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 05:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Hp2wuf+GFIgPk2krY9oLPCwUDqecUtCiJ9IkJj6FAwY=;
        b=JoTgBZ5QhZ1zJ+zoAs/5acKsh/nqSl8ksgt5417h8ZMYvSOnCAnsN70JPPOGxNVLKc
         LRpMVtKERVEzhaqSk5tabMb3721y0l2aPpMaVQyaFXnSgbRjVEkbPxePJxvl7QPsatBG
         bzzLIZ+OUHVEERgadEm/OhRbk64EI3s6saGFvpdNcHJY1KhyqzcSqYTTzUkUh9lK739w
         NVn4VqpuXhwiYbmn0lW+9QBp/HXX7YdXrZXyfZJRMj3cEpSBoBxx3bq4EU06TrFgxU3D
         2hopzLwoUHEKltSTjngfUnflsK2wQDZiuxKaW3W3VgbyC1PWvjOB2Q8ltftkYTZPpbuc
         lxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Hp2wuf+GFIgPk2krY9oLPCwUDqecUtCiJ9IkJj6FAwY=;
        b=ummDD+tMekSzE6h4/s0oznN6XaP6D6Oz4CQvKNtzsHnZ2m3e+B1FP9kTMzmhRSriVG
         RtxCclqm4KpiK3MmT/B0EngsbG1MMntkmZNZkCVcVJffkWENqeTK8v6MF5Crrm5umN1Z
         dKUgms8bg0zK/41S5eNrzM/aMWJ114o8djkgl+cC7sIcpcBHm3rMNEsZ3TFWJsmU9QYp
         v+fFXCEuMeSOeGYzC72GKH1TopxypXamVt4PAXuXNG25Gn4ufkTsf/+DWzHEIGqH8X/u
         wtd2ShJgVxPQNcphf5PePb+63UKgDOpSp/VMqlPZ402jw8Ev20krJ0CQwkrhrTWyfWYA
         j4jw==
X-Gm-Message-State: AOAM531pIiJhUodU1glfjxvND55tCNrRqKxFQaiDiaU03QGAq/f6RBLf
        QIZh0DIQPBTNDi03bYmCggLiPB2W6kP7WNWgqgo=
X-Google-Smtp-Source: ABdhPJwVQipOClbYvFQMj4nEZ1mR8CMlndZPukxyrOm6a6rt+JaJ12/CHsCSgH+/r4bzKCpynMfTjq31osrxEX6Sjs4=
X-Received: by 2002:a05:6830:1417:: with SMTP id v23mr25299274otp.367.1639402799686;
 Mon, 13 Dec 2021 05:39:59 -0800 (PST)
MIME-Version: 1.0
Sender: blessmegod87@gmail.com
Received: by 2002:a05:6838:9414:0:0:0:0 with HTTP; Mon, 13 Dec 2021 05:39:59
 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Mon, 13 Dec 2021 13:39:59 +0000
X-Google-Sender-Auth: gcM7gUYPrGGWQnSh9sWC4ff2zPA
Message-ID: <CACOw96=huHRYv7zh2RN72Y3WF5LngtgiVerYC73bSLNRob6YRg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Howley Mckenna, a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account.. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina Howley Mckenna.
