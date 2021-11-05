Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1E445D05
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhKEAck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhKEAck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 20:32:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B908C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 17:30:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so2167629pje.0
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 17:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=15W8j/m2r6YdeJuhHh4x5be5riWE/px56Prwg1zHjrk=;
        b=IQ2OqsHXQm0CWM4RiNjBGfR6tAEV95v1qtyLUm3Cg4QDtbQQFjr6VZSdQNsBpu7dHB
         snsPXnmTnTXXM3k7YEqZLElfddDnFae6b6hGy7RxWFJp2X8ZrJGJhLUQcdeRGp7rxqs5
         M/vUagiAuvTIjtCR72BRyaIQX04KfeZwstZuiFvZBDkXi7epaAql6vh1EAP9BXLczrm0
         4+99Vf0j3uwvTobEKmOslGcQMhbbOzV67PNx4aUbEgyL4p/q2B+QqhfhpR95Pkb8Cwh1
         ah+fPuUqh0sF/ygHCzHln4kE47sRuoCVCNRKjcw6uoofihZCZraYOgnBTSCbaMlDHOIs
         o9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=15W8j/m2r6YdeJuhHh4x5be5riWE/px56Prwg1zHjrk=;
        b=Yn5GrJvKZEENpqkd4bdRvx9K2Gj0s9oLP1HOeQhnbl+0karyVjlkuLrkuqwxXWQPhu
         G9qCI4ecj8p61lOMAcEe5HAN6h6PppQP48cQGqGBHBiXiZW4NSgZfCmD5wRXFIrfWDqu
         DloS7Lk/OIPoI1oHAMSMeCLJ0kF7jxFlXB3gwJ8B7q4ni680nUa4jsOVGHBmBIWS5YMy
         I81BTp4kIszcK/9Qd2avkh8nhnu5Q/h8koQDFR2LTp3rbxcBPOD581W7wYPMvnbCu/tm
         U6wx36H+FIrLW98UEolLEMz/RCEcwbUcCyvnbLqHlpcfhzm1OnX1yVfPliLyYqeczMNY
         oh6A==
X-Gm-Message-State: AOAM530yx4xP+6VyFcWchdwd8rJHtUIcY1SSdjpGBvendvIVUKNolLhI
        fJqGN8u8upoU00pVy15FUwApzHkfefuoWw1KJWA=
X-Google-Smtp-Source: ABdhPJxMOKjetZ54Z2SVeHVt7V8Lboe5pNEKSq52EdyyiT8LE9X4Tj00esWJrAORCIv2FuacwZoYGHHkzWR06zM8fwQ=
X-Received: by 2002:a17:902:9303:b029:12c:29c:43f9 with SMTP id
 bc3-20020a1709029303b029012c029c43f9mr47908181plb.5.1636072200876; Thu, 04
 Nov 2021 17:30:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: bfkabiruwahid@gmail.com
Sender: ballaw100@gmail.com
Received: by 2002:a05:6a10:f483:0:0:0:0 with HTTP; Thu, 4 Nov 2021 17:30:00
 -0700 (PDT)
From:   MR KABIRU WAHID <bfkabiruwahid@gmail.com>
Date:   Thu, 4 Nov 2021 17:30:00 -0700
X-Google-Sender-Auth: hde2FI0AugSvg3mmfMy6HInl9xU
Message-ID: <CAJfVvUL1U2UU11B159BSU6188_Nt4b8A7Yf6_DARFMY6g-vb4g@mail.gmail.com>
Subject: Hello Dear Friend!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend!

I came across your e-mail contact prior a private search while in need
of your assistance.I have investment funds worth million of dollars
and i need a trusted investment Manager/Partner because of my current
status If you are willing to handle this project on my behalf kindly
reply urgent to enable me provide you more information please this is
not a spam, its a real business that will benefit both of us your
urgent reply will be appreciated i will explain to you on how the
business will be executed as soon as i receive your return this
mail:(k888888888888wh@gmail.com)
Your Full Name=E2=80=A6=E2=80=A6=E2=80=A6
Your Country=E2=80=A6=E2=80=A6=E2=80=A6..
Your Personal Mobile Number=E2=80=A6=E2=80=A6=E2=80=A6
Your Age=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6.
Your Sex=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6.
Occupation...................
Best Regard
Kabiru Wahid
