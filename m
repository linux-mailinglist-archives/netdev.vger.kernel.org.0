Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061DC274374
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:48:58 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6201FC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 06:48:58 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r9so19657118ioa.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 06:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7dYDX/8GCPeSPFf8TwQlyOic5w8+3rw8997jgTX8hAE=;
        b=VCnNKZQ0UmgOmsN5FL/SlWQPQE+KgnZZkN/us0A/FPDH/MFkD+6+9r6v8w4lVsQvyo
         MKNcWKsC92ncDpXFnQC0M2gGcLaJ/yvIF+iweHoa/atlOSm6jQfOKkdKGa+a/X/3pnLL
         8qnlME7pcrPc6dtEh25nEv5nZtrp8koJH8pwzSYnnsjiqfmmrbdsupwGri9OTMoqX7kI
         tNFnhg68RBy9Ew3RUzbDUXvUhOS+b0UfZNoEeYVTrS1CXqyXLTckt0cQuqfxdre9SCNH
         0uXJhMx9yKm6WmPvjzvIRi+zY2ZZxCqC7VV/P4LMQSKjRA4F38Pzp1zEOpeqmXHp/ra7
         0UQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=7dYDX/8GCPeSPFf8TwQlyOic5w8+3rw8997jgTX8hAE=;
        b=GV4ZoCvj5PZHCPVzDb/9vxQSY9lNPYri1gfqC0AqjWCUJ944RtT7SZSzI2McyXVBU+
         UiMF+/QMufB7GZo4hUgMO3E8MuhlZ1uHRCXzgkQ6aEd7iFQq8Dvk/Kqxs+/YPdrY9Rx7
         HNvR85A6qRz058ePzZd6GWh9SYubBz/q8BhpCzSklBBCT8w7UIkHScpweUdZ/owqyOfX
         KDH7KKoazi7pi1SJi+QkMPTMCt/N9GZepv8XvZdN3j0jnuEjTweXlx3aodtWCV5o12He
         YmdsuMkr92xzCX1YTf/lIJKrtOPilUWjMHkVQEsjVDgkl8eRSQvdlP8De9KQMqXjDcWf
         b1fg==
X-Gm-Message-State: AOAM531QKATt8IyrgNlgLjMvkxwJOPxifsYOdUMD56kvGeXhd/fQmTFV
        ASKPPZrXKWbjjR5jloURU93PJLFBxkn1cZJu3Q==
X-Google-Smtp-Source: ABdhPJz7sE1iPP6lClHQFCRT4Hbt2FfzbECoJOtuSKQOWAej8uUMPjOiQ6gTwvMYJlEXfjqRTRv3kII2UjskLqGs6qE=
X-Received: by 2002:a6b:4f13:: with SMTP id d19mr3345709iob.90.1600782537666;
 Tue, 22 Sep 2020 06:48:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrshenritapieres1@gmail.com
Sender: dr.mahmoudabdelaziz10@gmail.com
Received: by 2002:a02:a48f:0:0:0:0:0 with HTTP; Tue, 22 Sep 2020 06:48:57
 -0700 (PDT)
From:   Henrita Pieres <piereshenrita61@gmail.com>
Date:   Tue, 22 Sep 2020 13:48:57 +0000
X-Google-Sender-Auth: RxZq_wiSelV9eByJcBQL-ZsNWwc
Message-ID: <CALFv0Er1Bh86AsgSkJ5wb9Hr-08V-szste6oWQnSnf8avj65eg@mail.gmail.com>
Subject: Hello.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise.  Actually, I came
across your E-mail from my personal search afterward I decided to
email you directly believing that you will be honest to fulfill my
final wish before i die. Meanwhile, I am Mrs. Henrita Pieres, 62 years
old, from France, and I am  suffering from a long time cancer and from
all indication my condition is really deteriorating as my doctors have
confirmed and courageously Advised me that I may not live beyond two
months from now for the reason that my tumor has reached a  critical
stage which has defiled all forms of medical treatment, As a matter of
fact, registered nurse by profession while my  husband was dealing on
Gold Dust and Gold Dory Bars till his sudden death the year 2018 then
I took over his business till date. In fact, at this moment I have a
deposit sum of four million five hundred thousand US dollars
[$4,500,000.00] with one of the leading bank but unfortunately I
cannot visit the bank since I=E2=80=99m critically sick and powerless to do
anything myself but my bank account officer advised me to assign any
of my trustworthy relative, friends or partner with authorization
letter to stand as the recipient of my money but sorrowfully I don=E2=80=99=
t
have any reliable relative and no child.

Therefore, I want you to receive the money and take 50% to take care
of yourself and family while 50% should be use basically  on
humanitarian purposes mostly to orphanages home, Motherless babies
home, less privileged and disable citizens and widows around the
world. And as soon as I receive your respond I shall send you the full
details with my pictures, banking records and with full contacts of my
banking institution to communicate them on the matter.

Hope to hear from you soon.

Yours Faithfully,
Mrs. Henrita Pieres
