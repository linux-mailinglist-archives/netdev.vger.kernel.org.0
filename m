Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFF4436E04
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhJUXNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhJUXNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 19:13:38 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068ACC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 16:11:22 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id f4so4360081uad.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 16:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VyoOlx1f4bY9qJ0WEn854eIaH9saJD/psl6FGa9mBmM=;
        b=WbLrNlrIbHYkuFjsWWuyUfnoQ/SHdpkO/8HVkiWdYP5m3f7AGfXeZiphKbYBnRtYUt
         qhlm8FX7aUbJc2Bv3hxz3rK3UbljK4BwlwjzEzJLUZTHvmA6JnwJEwodFL1x777iUHYj
         p7VJToF4uqLAYbzyYYpP33Nh5QMAhN4zzKYT9VoyQlntp0sfyfVVLNc2Ii5zOUpEpxx0
         T62SJSnC6BmvNC03Hqod4nfBJAgchHPgIzzp7OPwU+ee1Y4bW5uFKmbvGr//09KVRU/v
         pqu+edIrpPVRdP8hNUocW7D/31pj6fUAJMRZ6DRuAFBLBuhVsHf6hzKZCOw0cDPh7Mwn
         OzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=VyoOlx1f4bY9qJ0WEn854eIaH9saJD/psl6FGa9mBmM=;
        b=FfzYhitLYv3T9Uc+0D57m6J6BWc55oMI5sTysVq1+mLnsTbNlO37opds6nIGuD5GFS
         c9/DcGlwWecDpkhx9vH7EEq4arpWoADvT6bmBNmN/iPUppmBXdr/r+XuUUrcau5tbvCR
         je4JJW4v6zhsgb8Qk8dt48Z5zQYWoGsP0Jg9JtI09M1+ahvLpW0Fo9CrqjP9DZQDI1Au
         c6+nJC1bJwxJ0uKE2D7Ticx8dBjRcBT9aDgqNyznSpM9YTE8dGlhL7yWDjpRyK92UAOd
         AlMkbfWq1fJkWYGk9GNs+rxp9dwJB04ajLgaT/i3yo19OvmP4o78jYcZUpLBFzkQmWGb
         mnbQ==
X-Gm-Message-State: AOAM530GrMZAmiY1lJGkhKpOuIrt4r7hG9Xq+7w9A5ikLuG/u0qNa4jm
        tIt0aw3Wf4EBvivQTPlI6zFQlHydy+jr2bRizHs=
X-Google-Smtp-Source: ABdhPJyTNoXzlb/o+LPOW+nD0HPpN2DjrQGSpEGOw+/AyjY40DNytW3dMEWuglxdrG3zJUWMJYeA7Z08pSRCNz691to=
X-Received: by 2002:a05:6102:cd2:: with SMTP id g18mr9983388vst.25.1634857881152;
 Thu, 21 Oct 2021 16:11:21 -0700 (PDT)
MIME-Version: 1.0
Sender: sandraljohnpaul21@gmail.com
Received: by 2002:a59:b90f:0:b0:238:9205:39e8 with HTTP; Thu, 21 Oct 2021
 16:11:20 -0700 (PDT)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Thu, 21 Oct 2021 23:11:20 +0000
X-Google-Sender-Auth: 9Qu9FjdPEMHuuSESguTCjpfIN2Y
Message-ID: <CAAdqRCxs1humESVPTOLH3qcD=VTkXCSzCJLY3GKLPeXFJNPgYg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear ,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Mckenna Howley., a widow. I am
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
Charity works therein your country for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina Mckenna..
