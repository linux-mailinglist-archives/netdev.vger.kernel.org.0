Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06794447B6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhKCRv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhKCRvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:51:55 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DBFC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 10:49:19 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id q74so8246580ybq.11
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 10:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=KAKbOau+k2F74lkTBilcg5L9iEPlB8yy1KK479B4eb8=;
        b=QsM5ikBd1YX+swRfHlg2I5SAsuYihr+YI/MI9VLQtMZGurxoqp0e+QO0F62vVzj3BT
         Ff9qkgwTrxV4/ilM+U5Di+LbqC/GIZdCCUxh0q0GNH7/Zjz28MciqBRxmAtV8IgiUMD0
         PyPTxpH3vNg+9j9e8hwvV8LohVwkIZSXHY8jkQf9HfMDeAfDdVXPJN1zlidGNFMpPibl
         r5eKw1BnUMwBBhuJSd1/WY9AgKIO1xmQZsR4kKwxnmzUFcRL1KR5S9Lr65pkmqnHteqB
         AhHG4uS3zoo8Jmq1j151qg4Whe6GrKREwLmbm8WLTs7vqlaKyDKkWVLUbEuTWyTa8PkO
         2X5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=KAKbOau+k2F74lkTBilcg5L9iEPlB8yy1KK479B4eb8=;
        b=iThebNmrvpMxc4PgdAPKsLpbVSrjB/LCkXHrib5eEhnGEkMzjrr+a5v9OBstxxH0y/
         jpBxzlBsSJteC5yiBxYqSm40a+DFZrPQusml3ETNw1ChYK0og/LZAh+rRiyuDDRCphTO
         7exVJIwIvqT4JzNU2UWvejWLMMh8lRKnDDL0WTGxalXiZs1bzZ+Axw4B6Vv3lAru5xST
         i7ejeflo67pqkqZLk9BSuDqq4roJl6Eq9K2J+pCG/4HsWkewI4WNvRyvpOPS2CVOVIwI
         Z3w0jCFEke/UTXf+qu8+1DfJGbPg0/obZl2nhJrefEFw4BYmJtNFY2/9JBhQiUjLuncm
         JZvg==
X-Gm-Message-State: AOAM5329/HJE39F0YT8AA8/JZ3Op0KSzWO/+pGNfyalZnIqBL2RzBADb
        hKJrG7T4KJOftcuZb+arwmQtC4F7LdExz+nIj8U=
X-Google-Smtp-Source: ABdhPJzhsQ8atcLXg2PvAU2hPtvHFtFX/0VYNSQBMXkm7MYBoXSkkCkE6WNqo+TuWv7OPu/PcMbsFxCEJ9zMELl1xs8=
X-Received: by 2002:a25:5c6:: with SMTP id 189mr21538719ybf.124.1635961757227;
 Wed, 03 Nov 2021 10:49:17 -0700 (PDT)
MIME-Version: 1.0
Sender: mrrnra.kabore@gmail.com
Received: by 2002:a05:7000:bc06:0:0:0:0 with HTTP; Wed, 3 Nov 2021 10:49:16
 -0700 (PDT)
From:   Anderson Theresa <ndersontheresa.24@gmail.com>
Date:   Wed, 3 Nov 2021 10:49:16 -0700
X-Google-Sender-Auth: BooIjtjlyUISUOSKSOhBThzCT8c
Message-ID: <CAObd1co7h7-fanpOvxZT694BxvXNp_jFCvFWseSC1t3Y6RpFDA@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night without knowing if I may be alive to see the next day. I am
mrs.anderson theresa, a widow suffering from a long time illness. I
have some funds I inherited from my late husband, the sum of
($11,000,000.00, Eleven Million Dollars) my Doctor told me recently
that I have serious sickness which is a cancer problem. What disturbs
me most is my stroke sickness. Having known my condition, I decided to
donate this fund to a good person that will utilize it the way I am
going to instruct herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God Bless you,
mrs.anderson theresa.
