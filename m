Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20E64828E5
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 02:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiABBY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 20:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiABBY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 20:24:28 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899ABC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 17:24:28 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z29so122055451edl.7
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 17:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mrxhTGCiJdlGC+eJy5UXznUx973zEpGxFnhRGTjwkGI=;
        b=dg22SqwFcUsIjq9ouI3Vh3HFZGb5f6o33qQOTTpgMy595b0v7nqWp6iSSXFdEh7Cyh
         MsDTjAZhXrX/zUVS20b2DwdLjkkpFhkmWeyWBcqDUDaljFGgoR0o3w0mNGJ4jiZDoaj8
         OIF4BecCl+qaBz1EFPK+YJps8pHCE2Iov/NqYOzghlrKs/ld2aHCldhScotEPbLKJAZp
         5vP653G9IqgSwCot2HqssmQwr2Ag6TZe7iaQCKgIB6eqR1aQ6saDA2LiPDGGaRbWTVCv
         8bzknDRVdJtk2Nj4F3qdzeXAqYoU+aUf7rjLVFhd+G1DVxsDiJEBPg3o/hCxu8jF3UeU
         /d+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mrxhTGCiJdlGC+eJy5UXznUx973zEpGxFnhRGTjwkGI=;
        b=YMxf1H22qAflsYt+mKNtdw85hrs9vE576jGUC62pFqqrQo8KYVH0uPiqF8rWpKeDij
         xiOzmuAGsCSeGTrljHPxheBNQzbVHpd/hT6ote0JREO5bDP/7IqnTE9wNHj58PKnIBSo
         2ymDNl2fLCJg9Q1BnPzVLqG5DBEQ1Cv46RIAK3lhss6nYIlQe2wQhU97tRSbN7DgQyWp
         5Rjq62lNrzbMneVvlCcl6tctX9dqz6jssx12elSDjBlEAxXjJsTdQn7oSyLmHlE6FWka
         6RC43vojtMNG8yUjSo9m1jKFsQVVPsfufn8PbbrM8B9geiz7KTOYtjXiDF6UTRnjs8nz
         AKDw==
X-Gm-Message-State: AOAM530xrAbfE1SELV1NYM3Q3gq3Ac6zRjp+McgtH+tV1vMtQSxd+DoN
        hfFs+uZ3OiiPYt/Jz2H7cWCxCiEBI+oeC3UZkw==
X-Google-Smtp-Source: ABdhPJyiH5BmAV1kLgXkFUG9G7FkkjekTRZ+u5fRp6u4uCVdDzbJvqubrQ6uLEGG9Xh5FcDWJZa3MgTnOIIty3kxXQA=
X-Received: by 2002:a17:906:40ca:: with SMTP id a10mr34006495ejk.377.1641086667065;
 Sat, 01 Jan 2022 17:24:27 -0800 (PST)
MIME-Version: 1.0
Reply-To: asad1ibn@gmail.com
Sender: 0015ayida.amodu@gmail.com
Received: by 2002:a17:906:478d:0:0:0:0 with HTTP; Sat, 1 Jan 2022 17:24:26
 -0800 (PST)
From:   Mr Asad Ibn <asadibn22@gmail.com>
Date:   Sat, 1 Jan 2022 17:24:26 -0800
X-Google-Sender-Auth: HsDpy8mce-YHsuN21YY1RcaKcrg
Message-ID: <CAE=xPajbpyNDFodjE02xhBvVPgGL7SDE9BSqy5tPsHdzCt8B1g@mail.gmail.com>
Subject: Dear Sir/Madam
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I=E2=80=99M Barrister Assad LBN.from Burkina Faso, I am sending this brief
letter to solicit your support. I have a Client who is an Indian, his
name is Mr. Dasya Kahaan. He was a gold dealer here in Burkina Faso
before he died six years ago when he went for kidney transplants in
his country India.

He deposited the sum of $5.5 Million dollars in one of the legendary
banks here in Burkina Faso. I have tried all I can to get in touch
with any of his friends or family members but no way.

So i want you to apply to the bank as his Business partner so that the
bank can release Mr.Dasya Kahaan. fund into your bank account. I will
give you the guidelines on how to contact the bank and we have to do
this with trust because I don't want the bank to transfer the fund
into the Government treasury account as an unclaimed fund, so I need
your response.

Warm Regards,
Email.asad1ibn@gmail.com,
Barr.Assad LBN.
