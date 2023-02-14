Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B334669692D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBNQTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBNQTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:19:45 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D8DCDCD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:19:28 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 24so10551759pgt.7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ep3xQh1zor1C5ZyQ3a0BkJnjNwogoomzEQSYq0WLrBA=;
        b=i1OxfQxawJnrkbAzoSnioprNpXxw6f5IRNDhorX7HE3qTrxyjT8ZbWO1avQLLbS8SL
         WxLgz7sTh5hpLBOFUksaT8zn/194oaFEBvS+dLAJXjD1YJCzNnXojO0qxXvX39KMh3X6
         253Aqwv+5IJKsY3J3yXkSCWW3rcavgqxykEPRRCKz2SvuWE4y6WX7u0fzLnmWBJ12lGj
         QJCkt3Q6rIbduNleS0YAQzfg/KlkXQER5zuvdCCADRQ1YY6mrkNo0L+kfihF8akVoE49
         xGTJvaHY1v1wW81VBVJbze2sHM5CG5T+1W/I821uk/cHa3do6vQpHn/6683aQRKBP6k+
         WIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ep3xQh1zor1C5ZyQ3a0BkJnjNwogoomzEQSYq0WLrBA=;
        b=5pjls1fXKpqPybV9sZz8NIS5bo7Cp1gwkxiQ248+FjqRyUpOMERGsZ8C1HjQ7jDRVg
         Gz9Fb7aa07sKeDh1B0BiOw7NhZSEUq+QwuGdTLOlEM0lRUE/jQ2IuPqPM+l9jyfKxrR3
         UVRYgrdyBbENnjTGj1qjO1W7F8o/xuiSHEZ/FXfhCM0SMGl6soYA5hvVjZYuiTEonKcT
         n2PapiuLdgiES4qCUSdmcfxo/YT6uqiLu00J9KFkaZkjlj0J+kmUD7UOpr5av2qsonry
         xPFQAJ2khbB4exTuTX261mQukBuJ0OC6rHdY3qwOuOxj5EwoLV/sANxM664mZOlr6D6j
         7i0g==
X-Gm-Message-State: AO0yUKUG0/Dt2+7p9ZJ5t1fL/bd3JdfFbpCUEpPeH8+4LC9BQszRUN5Y
        HYxQ1ehZmCRUiLreC4xM8Ra4ObJ6toDPMbOCLe0=
X-Google-Smtp-Source: AK7set88Hm8fwyQvAQzC6+n9wthZeS7NzjypXLuCJvlUwpD7mWfpkcvk3r5XfdhCY0IT1oCsR41/zL77TefzG/etmag=
X-Received: by 2002:a63:784a:0:b0:4fb:7b94:46e0 with SMTP id
 t71-20020a63784a000000b004fb7b9446e0mr395823pgc.129.1676391568359; Tue, 14
 Feb 2023 08:19:28 -0800 (PST)
MIME-Version: 1.0
Sender: babanganamustapha@gmail.com
Received: by 2002:a05:6a10:614e:b0:412:87b8:6bd1 with HTTP; Tue, 14 Feb 2023
 08:19:27 -0800 (PST)
From:   "mydesk.ceoinfo@barclaysbank.co.uk" <nigelhiggins.md5@gmail.com>
Date:   Tue, 14 Feb 2023 17:19:27 +0100
X-Google-Sender-Auth: wCJYMfRrLW5UKDngOhLP9b2DG0o
Message-ID: <CAEVYrm-dZ6W0ZAVpfQRitw5i8dRJtmwXaz+6Cqp=Md=oF8HowQ@mail.gmail.com>
Subject: Re Fund Payment Notification
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MONEY_FORM_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [babanganamustapha[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  2.5 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Rightful Email-owner

This email is intended to officially inform you that your name/email
address is among that has been forwarded to us for a Grant/Inheritance
for $10.5 Million respectively payable through ATM Master Debit Card
or Online Banking. Get back to me for details if you are the rightful
owner of this email.

Looking forward to hearing from you,

Yours sincerely,

Nigel Higgins, (Group Chairman),
Barclays Bank Plc,
Registered number: 1026167,
1 Churchill Place, London, ENG E14 5HP,
SWIFT Code: BARCGB21,
Direct Telephone: +44 770 000 8965,
WhatsApp, SMS Number: + 44 787 229 9022
www.barclays.co.uk
