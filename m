Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5924866BB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiAFPa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiAFPa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:30:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9C0C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 07:30:28 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so8936242pjf.3
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 07:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=poy9jWlKe3PqPzH/ksjlva2ASke2fGxYCMHz3+mLehk=;
        b=KvfhUKHIsYpe2WPQRWjRSWXS/Hp2w5VbAYByXPN3Uzqtfipk7Gjz9BjhIDVJw24brl
         FM6daMno40Qzr2UA8VFavZA9tz22zP+nXcEB+9/vZapdrmTHNrXGG40JFcKosPqE07KP
         FbKWR6wQmgswy2T2Gr4KmsFIjnf1mnlu4bJwNzR1mJjMq3qZEZHBpD9Q3b6I2TQJ28lh
         4Gv1iozr3/sNMYpaS4+any/PYkfcmCHBDBQWwkSQanWhz7UAUFGdIorR37KjOeqLHLcB
         84UEmORvNTYqRs6B8YMgZW6JtQAR/uG0dRoYFJE9zkchBRnn2NgvXTys/tUIL6ZEE7Vc
         TNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=poy9jWlKe3PqPzH/ksjlva2ASke2fGxYCMHz3+mLehk=;
        b=69QiX89nj/0jj5lu5liI+c8GPixhrbNfJUE/Sidg3vUVoBeDUeKwUfAzy0xiscEKDm
         cKaOimnt/xa0HEMXVg1FTGR8L699O+9Q8PIFjw7yRiTH65fH8OGPQ/eNWtlZVOZ75/NM
         wSN/QA7BBj9P/3OOLHsmBLJ+QQGjK0lw16avf3n1Jzt9DP6b8R0/PTEfOd0/lrBTAZk9
         L8K4ju3RyYnbGee9NM22HH6n+PJDO+jfYNcHZSSyp79deie1t7DOjnwNb/gnQ95GHKGV
         Z4Oszlau2wHQX+kDtvSG0XfeuVnHyoy0XM0wVPSEbVqJT3DR3G1EbWDJk8I/C+oVZR8W
         0aqg==
X-Gm-Message-State: AOAM533w8v7eKXgeb8p3PrAPeKD3h0GmfjzDCskDc5l1ZXd8dkYIbXJL
        +GCFuBXAlcyAn9Ix8YtnDi8fhG8BBHSYXwZ7oDA=
X-Google-Smtp-Source: ABdhPJzDriJQqFj5GEQudeaL+0mrc8m4757IAi75MhNB5WyDh5FxmqrDL1J9hjh/RnKeDzzxWRvZsIZH8tW6u5vkiqE=
X-Received: by 2002:a17:902:8e84:b0:149:a2cb:4dac with SMTP id
 bg4-20020a1709028e8400b00149a2cb4dacmr34293217plb.22.1641483027981; Thu, 06
 Jan 2022 07:30:27 -0800 (PST)
MIME-Version: 1.0
Reply-To: elizabethedw0@gmail.com
Sender: adamssaad14@gmail.com
Received: by 2002:a05:6a11:d11:0:0:0:0 with HTTP; Thu, 6 Jan 2022 07:30:26
 -0800 (PST)
From:   "Via Recognition Award:" <ee7358936@gmail.com>
Date:   Thu, 6 Jan 2022 07:30:26 -0800
X-Google-Sender-Auth: vzn3KUJJtGrWvYArxfrpm0sIVoU
Message-ID: <CALfnPCJfKjxiSMtQMC0qNzh24eJ-egkSN8aLnnLomPHeQcQ8xA@mail.gmail.com>
Subject: You Won Us$2,800,000.00 Via Foundation Recognition's Award.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello


A notification for the owner of this email address, we are glad to
announce to you that a sum of US$2,800,000.00 was generated and
awarded to you by the Qatar Rowad Awards and United Arab Emirates,
West commission and the Western Union Foundation under (CBI) and
Superintendence of Industry and Commerce foundation. Achievements and
results of this are to assist financial problems and charity in the
nation.

This award was selected through the internet, where your e-mail
address was indicated and notified. The award foundation collects all
the email addresses of the people that are active online, among the
billions of people that are active online, only four people are
selected to benefit from this Award and you are one of the Selected
Winners.

To facilitate your claims get back to us, with your processing code
(22EX1) number for every correspondence and more details of the claim.
Through my privet E-mail: (elizabethedw0@gmail.com) for fast response.
But if you are not interested delete it from your mail box.

P.S: You might receive this message in your inbox; spam or junk
folders depending on your web host or server network. I will be
waiting for your reply.

Awards Coordinator United Arab Emirate Commission
De-facto Chief Award Officer
United Emirate Award Committee.
