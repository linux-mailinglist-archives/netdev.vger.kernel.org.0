Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC837402768
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 12:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbhIGKxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 06:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245466AbhIGKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 06:53:54 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3F5C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 03:52:48 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id x10-20020a056830408a00b004f26cead745so12186266ott.10
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 03:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=OyIB5aWCPQPIxRpPcXS3MVhfx/nzhAHC4exUCuBb7Ys=;
        b=J/WacDcZgOwqYm5/Xq1eSbuRfC5sAfsIZ3v8deynA1Ni4Mzso7Fl/fex0+/PoGT3+9
         BpwMaSv+QvlKP/SSVeaaZnRdl+mRJFVg7KkpB6m3ehAfJhIm1bWknayIuEwLxI/0thse
         HLRn03roOBcX3k3ApoPvhw8srtYRU0Fn63LhbJZ1NdryMnJ5q5xwqBrG4FakVkNeC9fY
         U84Z9FhBEiY3WC8jUcmqbbRlEs/Obwe7yAJ2UWVjXsbV6cS7mF7+Qnkgb2eeAwUN1t7U
         ihauSyGM034OPY+mtDKvLYWN93NH/HrACQpg1GTFraaVy/5qg72q7A0QYVrW7R5qJ1Iq
         u7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=OyIB5aWCPQPIxRpPcXS3MVhfx/nzhAHC4exUCuBb7Ys=;
        b=TF7sIjSM9z589CyYCiq5ZhFLuJ5UHz3iy/hh3zQOSIr8X9aWxN6cWhPGJZvnxPa5nd
         yHFUDmpY6uXf6p36mSkVtDse3+koV/4iqKqzKIx5Dhm3N8Axo7d+oNc8+UvYvEbQu3zE
         PrZrmRrszunM95WvBhJ2Zj7yLjFGvDhRIRnu/MwIj6Z89gfSYoY++jbtST9C3C+mWqPO
         FaryENvxm/JpAZ5b7mQkVyA67/L+9bvupnnrXcnynKfcMT/tZsTmQLIKKImd4AsWSUT+
         ZDm3jlUXwYF6LltYeNeojOk1qQAS26Il7yMGm4YfukgucPOlv1hMdav4cqekj6/eH5Ch
         s76Q==
X-Gm-Message-State: AOAM531vn0oTN8Dkw0Uc/w5ezEwT6gVlefZfqMw7mXaCjf5Dz6MxeONc
        EA88NTNiYsZ/A6Y2hH27uBYVVhFVZuDL2DvE++g=
X-Google-Smtp-Source: ABdhPJxVqTRpSG40+xLzF97h6IzIt5CRrI7eNpE/w+zfU0R5xZ2TvYuKDcWjYTD7Ex+k+RMWuc0511GDEktaPI3cR+U=
X-Received: by 2002:a9d:4111:: with SMTP id o17mr14048231ote.355.1631011966320;
 Tue, 07 Sep 2021 03:52:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1249:0:0:0:0:0 with HTTP; Tue, 7 Sep 2021 03:52:45 -0700 (PDT)
Reply-To: j8108477@gmail.com
In-Reply-To: <CAPekpP+Zpz47pLjY76Q1Bc0+L=vR5B-zO1M+fQMcx1-6jN3gww@mail.gmail.com>
References: <CAPekpP+Zpz47pLjY76Q1Bc0+L=vR5B-zO1M+fQMcx1-6jN3gww@mail.gmail.com>
From:   Mrs Norah Jane <sla03572@gmail.com>
Date:   Tue, 7 Sep 2021 12:52:45 +0200
Message-ID: <CAPekpPJso2Rd1GAnuJgRwLHNASBhAzGz-U1AWKEXnbukEfq6NA@mail.gmail.com>
Subject: Fwd:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---------- Forwarded message ----------
From: Mrs Norah Jane <sla03572@gmail.com>
Date: Mon, 6 Sep 2021 16:49:02 +0200
Subject:
To: sla03572@gmail.com

HI, DID YOU RECEIVE MY MAIL?
