Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14228697859
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBOIhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBOIhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:37:50 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3AA367C3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:37:30 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id v17so26646509lfd.7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s+m+ieimh0cjH8hCifDZdO55IxH2JEdT2Rnf6OI7dlg=;
        b=d+5HlF3/IY7wOumWwPMHjU8AYVGFT04GDaEApgzfKFJp0+fQEJzBnA5f3yxKfm8w8n
         i1KMSDIpLfCH8dyW1HnuhBnPH5v5z/QLcNsT5tBRPpdvGfDf2GrJ0L882RSbrZyKcFZ2
         8BmYbBzseKy+P56lEkJrToXZBxYBokRzaU8dEP6FVYrtVQ3R64kr0zWleJfZ4PYbPdBA
         7dcf0teh/UestaOQKGyK+5Cwv5N1i0utNHwr4nG2OAgoi5Em6Q8WHdrBUdnPYz5ds2j9
         hExR4NePv8xV1p7qRCgKGSVLyihft7To0Q414D8KmMX1b+pG/3rlbIEOqalyhzw3Yhdj
         ZZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s+m+ieimh0cjH8hCifDZdO55IxH2JEdT2Rnf6OI7dlg=;
        b=jr1brpOsOEOFbDbtu4g4Ye5GmSj0HXdTredhY3tufIJ8PoIzBNRAwKXI5VZoE3AFZc
         H/Jb5XPhaGxn8Q/jizlI2t0ltTmadzhyLJJzgjsL8XFB+6bphPVJ6us9g2G87LrN9KXc
         1iaj+s5MK+pdhUilMYqGzU3685pk3k3/ox5xSSJgFwZtvBAURGXIZijNQpW/6LWEK94V
         Bvdo8PkpLNzlaEdUjZ0CLKXBU+lGMn4gIgIhyDJyBHU3sn1ILGgGU2YJH6j1/a6DHtIr
         P9BVld2UpptwtE6L0qCa+A5he7wz2baoUP7FLv1jIcLzE9bmobj6JEeNKwh3+decloLb
         9wmw==
X-Gm-Message-State: AO0yUKWO+A9TwiJCv4giXuShQJpLJmAdMTbKSkKZwlOPHw685oWiEBs0
        jV1wPhqfT7kV0zcyTBuw7eG9PcPXC3eADpyeZkU=
X-Google-Smtp-Source: AK7set95edp4DcIYPyaLRvRMZNJhCVpRG06nLYzSdkzpe4nifDRiMz4NYOKfWpYhUrdj0hT0XmEj+u4VSsHtK5IJJ4w=
X-Received: by 2002:ac2:546c:0:b0:4db:f0a:d574 with SMTP id
 e12-20020ac2546c000000b004db0f0ad574mr289037lfn.7.1676450248595; Wed, 15 Feb
 2023 00:37:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: mjosde4@gmail.com
Sender: azukao1977@gmail.com
Received: by 2002:a05:6504:4313:b0:21e:596d:b1e with HTTP; Wed, 15 Feb 2023
 00:37:27 -0800 (PST)
From:   Galina Lagutina <edwardramos1900@gmail.com>
Date:   Wed, 15 Feb 2023 08:37:27 +0000
X-Google-Sender-Auth: COmC_bq_AQfmFAMr3basPISrYLo
Message-ID: <CAMcpFm3quUvKycFumNbcHhZEvPRf7pUwS0_cFZGhvzyKdwrWZg@mail.gmail.com>
Subject: Hello again
To:     azukao1977 <azukao1977@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MILLION_USD,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day, I am Galina Lagutina, an Investor and Deputy Chairman-Mgmt
Board of Gazprom Pao, Russian Federation. In view of the very severe
effects of current economic sanctions imposed on Russia by a number of
countries led by the United States and some European Union Member
States, I ask for your consent to help receive and invest a total of
Twenty Million United State Dollars held with a financial institution
in Canada to avoid a possible confiscation by the US Government.
Contact me directly at (mjosde4@gmail.com) for more details. Kind
Regards, Galina Lagutina.
