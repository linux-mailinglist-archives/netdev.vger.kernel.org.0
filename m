Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04C1E82BC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgE2QA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgE2QA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:00:58 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D58C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 09:00:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d128so4204474wmc.1
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 09:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jPExNZM3mmX+1Ih8VVxmCh7AFIrM8pkRXK2ZyryZhKI=;
        b=Vrz0koRyGGYL2AJ0G1wCIiNuCQT7jIT7CPBv50XCXvEpmsft+09i03KFDbBkbtMoE/
         w9tf+EMg1b+Akm9sJi8K0BrQAHAeoqWVWoQ9ErhHv0grn5Pf2ZfGXIhszw7+yGRdTSMa
         Jku3xof6S0weJyhsNOvEJGJjJH7DGJg8s6M5dZC2mEUXPEUqSnaXO5w0SUkxMw0nP3yu
         IZmWAeom35CsoGDivbnG/u7KTpBZBMMP8zkfW2rcW0CrxpanMqc6K/q6UDKgyvC5QhQe
         1n/BFkb5NpZZcquiG/6aqX21UyvMA5OqoRztGxzV3gYsGJlbQrwjxcSx6xodrLb5XxyA
         9bBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jPExNZM3mmX+1Ih8VVxmCh7AFIrM8pkRXK2ZyryZhKI=;
        b=XqCJERZpJNyX7w2nJSV2806fVcFDUukUB0asKZ025ZiOAvunlayLOlAmFUNsIYCAGk
         Tr6A4c9E2/xR+GOflppmqSjGXprL6RjciJ5kHN9skGji/f8ctRodNcKjHh22+NcSQMXi
         pUvYwYfDaYuSKJfbFZbbJvOPfhxCkMY+HaLtcB5Z4eTeSAkFdESQg7rSDkeWfHvkS4Pq
         eBA8TG3uuMOhK/hlGkAey4xcWHUBwG9y+4i23V3HHeL8dwli6GB5X5GynrGIo6ktxrPB
         G84bilBefTQE4T0bdtqfF4MIl8xfDRRUJkZBs5VrccrPL99SGSmkDh48rpj2/fFfR4VW
         W45Q==
X-Gm-Message-State: AOAM5330Q3EA9f3OiSrIL/6W3jG0Itg1P77KzaR0wbilcKvZ3UXZqDEw
        rOGa/SRBcLd4QjO8DN+BOeIa+04/vwHQfC/J4Ck=
X-Google-Smtp-Source: ABdhPJwTZCNqBPJPy10nRkNlAvwRQcopUEGwV0loWP3wq2neV36N9dvNMvu6mOV+nTmE0x4s2wR98L7ZtLwOISy+BX4=
X-Received: by 2002:a1c:6a0d:: with SMTP id f13mr9426033wmc.180.1590768056657;
 Fri, 29 May 2020 09:00:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f3c7:0:0:0:0:0 with HTTP; Fri, 29 May 2020 09:00:56
 -0700 (PDT)
From:   baco uche <bankbankb38@gmail.com>
Date:   Fri, 29 May 2020 17:00:56 +0100
Message-ID: <CAHJX93Z7F-kEVTNMe+OgmdTZTFTL6Cy9fTS6sUyaOR9aLQ28-g@mail.gmail.com>
Subject: Eid Mubarak,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assalam alaikum,

I am an active banker,  I saw your email address while browsing
through the bank DTC Screen in my office yesterday. now  I am in a
better position to transfer about $8.3 million US Dollars into a
foreign account. If you are willing and capable to work with me to
receive this fund into a personal or company's account, I will give
you the full detailed information. No risk is involved as it will pass
through normal banking procedures.

Hence, I am inviting you for a business deal where this money can be
transfer to your account which we will shared between us in the ratio
of 50% for me,50% for you and both of us will share any expenses that
will come during the release/transfer from our bank, if you agree to
my business proposal. Further details of this Fund release and
transfer will be forwarded to you as soon as I receive your detail
Mail.

1)Your Full Names. (2)Your country. (3)Your Telephone
(4)Your Occupation .(5)Your Age. (6) Your full Address.
I will use these detail information=E2=80=99s to fill a release/transfer an=
d
arrange some documents on your behalf in our bank here as the
beneficiary owner of this fund abandoned in our bank

Please contact me through my private Email:alhouttta@gmail.com

Thanks
Alh Idriss Akim Outta
