Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C069B5F013E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiI2XKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiI2XKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 19:10:32 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC25CBAD7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 16:10:31 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 126so3139571vsi.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 16:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=pNN3zxBjhhJfr4bsV+m7bHcXL0J96fdyy2RNZqEjGm8=;
        b=otNo39pF6YeIxhzDwWo7Pbo+mBMY7CAC4TtQ15Ke+xTm5xQh2qRjMnsF5gEA8zdOU5
         LqMY9PzUcQyjC9JvIbJp+WnAKR6GTbB8qQ6jFQxy8qalO41g83DS5hFQFgIMOrUjDS7E
         S+mLH+K4v1aTP84GEzs+42QcJb2KOt1Ane5OBfF17IBLauoC7CuCROBBbs2cl+N9a3vg
         O4g3nIEkhgK3D0iQ2Ri2+D+1I/KMh/anlIfE2885e4UclPt7likgKAW1SOA3YO2/JD4e
         350vxVZ7a0JPd+RSByWkL7ckjXGj8CBEyGRjJ6DiMqD6oXSdCxRKDzP1HKcnmDrugcaM
         WZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pNN3zxBjhhJfr4bsV+m7bHcXL0J96fdyy2RNZqEjGm8=;
        b=H5YNG4fX4NntgpDtHJpKNfdxZQGn917o9B6E32z2pytB2/TwlHDbHXdo7lmt4QlvZK
         dmYXVIX/6YbD10tySKrqgTX+MP6sRN3Un+20y7E48SGs2osL05Ou6p3eUl+5BO7JfZM3
         XPJyf7NscXp7OI8hZ/uuUIobFq4AIfvxHnAGnfzw+an7zMZUY4m1nL0npGNiBnuCk4D7
         m6ZnLHjtaHg+6mTn+mDpcxAGLIscMgu+SAQ6PEQuvPwYPRoY3R7Bol96lwT5CV1vEKr1
         vO8O9xPiwLKMskyRZC2VMnhmx9sVJrkL8BvW2Bz2UG6LJoqciKQktD7kYW0dHTs07UCF
         BfiQ==
X-Gm-Message-State: ACrzQf0mT9TQlP96Rm4x3XSlEEBSo8VtRyh8q1B+Dxro5MhzxuwhMUUP
        aq1Hv/VWDXaBCjS401KYqZ5fQnCl9ZsLccTh9dw=
X-Google-Smtp-Source: AMsMyM4a4ye4VEyOEgdgo83lh+ZmXogQvEAoZYiynDfWQdEkv1iwuEXJB7SVq9jx+9L4E6UNDIQLA5QFHLKuKniGx80=
X-Received: by 2002:a67:e2cb:0:b0:398:7b7b:90b4 with SMTP id
 i11-20020a67e2cb000000b003987b7b90b4mr2861509vsm.34.1664493030326; Thu, 29
 Sep 2022 16:10:30 -0700 (PDT)
MIME-Version: 1.0
Sender: hj2294752@gmail.com
Received: by 2002:a59:aac8:0:b0:304:495b:8c57 with HTTP; Thu, 29 Sep 2022
 16:10:30 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Thu, 29 Sep 2022 23:10:30 +0000
X-Google-Sender-Auth: v62JpclIH8lfJN-84FvupM7NRJE
Message-ID: <CACgdSp5kdyGg8q-95udARKgXHr1jJ2z5b8m87nryK4HmwXME0Q@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Helle dear
Good Day
