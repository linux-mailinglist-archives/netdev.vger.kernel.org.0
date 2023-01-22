Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC7767726C
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 21:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAVUkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 15:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVUj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 15:39:59 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23EF196A4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 12:39:58 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id e10so7607962pgc.9
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 12:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=E/NFV1CSZ9jyn5jtl5j+0H7irsy7RMiriQHMAf9BR7qeTue9KXPr/MYvJ4ddvbOHFb
         wjPenW0RzgHvFTnmRZ9Nh0rMJahtAEeR3jmVnZ4KVjWtPBtouk0XDaXR+OkNSzsifq0W
         pJglyDnR6FB6C/xX4ZbfndH0v2fXy1Hld5avMiPgdnGlrolf9SmJN6sswUjpYrXXFPoU
         T3doiSweslK5rbnhXLo8htXqQr1b0q2xaPEAX2zwh8jMgvCOXAenDqxhVUlKuhbt3Xly
         jtoL8te72qutoTVPPee2AWTgzNPrDTfHe4CViELn4E0695y18dQ+yI8YdlWcXREblKen
         0WUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=D/os1XTOGQc5dI6NoXfLoEUDzamzwT2ovbAvXnKfzG6pzYmsbuhN8o6xT97qX34K8R
         Tr1Ull6DD+QQBX22uz/8CV7L0c0GB/LojX/C0KgpG5UsgrkUUw2XciRrD/eqRUjKNk2L
         RPXc1EurbgeLm/pLL2GfClh3jzie1XMg6YqPxuF5t7w6ZfCMPW7RhdFLflK6QLkIZPKX
         wpU1qed6ffnA1CO8ecDFH2Wi/bTnsV1EUAkhuY8uPWNwJ6ashOZlwXNZtCHmyhmO75Wi
         RIwxEC+5MIynW9TD+/zwaWKb0lheajKBfN2uFBqAQ2pqS6nyp+fdcqb6oDh993vik9Gx
         iASA==
X-Gm-Message-State: AFqh2koZAozeE53DqJ9UkR/xgG4sG5XfERvYL5HUlew0VWuFibFzHxe+
        ckoysB/PgKyKRay9XrfTo7WMeVc5pgIhq6C5cYg=
X-Google-Smtp-Source: AMrXdXtRFy1k463kPhnMi4/iGn/zMxSOfpropTpaRfhEae/JohZGJb8QfqEbeJ9JLvCqo+BSSwDLyk6rRmlNUhB/Cys=
X-Received: by 2002:a65:6e92:0:b0:4b1:70be:cf58 with SMTP id
 bm18-20020a656e92000000b004b170becf58mr1816446pgb.115.1674419997834; Sun, 22
 Jan 2023 12:39:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7301:2bcf:b0:97:c844:617c with HTTP; Sun, 22 Jan 2023
 12:39:57 -0800 (PST)
Reply-To: avamedicinemed3@gmail.com
From:   Dr Ava Smith <captraymondjpierce@gmail.com>
Date:   Sun, 22 Jan 2023 21:39:57 +0100
Message-ID: <CAAcDt7FYPi7n2-2nRRvqDOxXK4=s=WzWeMn1XdQDjUGm4iVyzA@mail.gmail.com>
Subject: From Dr Ava Smith in United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear
My name is Dr Ava Smith,a medical doctor from United States.
I have Dual citizenship which is English and French.
I will share pictures and more details about me as soon as i get
a response from you
Thanks
Ava
