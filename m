Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4FB65FBFA
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 08:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjAFHc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 02:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjAFHbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 02:31:48 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6309665AD6
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 23:31:24 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r18so652293pgr.12
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 23:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56U3L/n2SWLavdhRRg0Yc0+2596Qz1l4ZkRdkLejoUU=;
        b=elQsgd3s95kZjmqyDOBj/aqKTfcjhDKSBAgNt5cuMtwoh1TDQCbxOJPMeVDM2n34II
         5WWyQbHNsqew5MFvLAKhqbkRjlfi8i6JbOVNkPF4d6ylgZCzFLvJQRZWoNb1ejf9kJM+
         NfTPXEr5bkjHvkINeaw9AGcJ1xeUx5LZgAg1WLPUJIGpUvgSfGuh1dMYfp6gaIR5h9y4
         k5NOK7cDG/RFjOV9Nf2uu81jtUraAgd0ZXfh5aueEv01IRRFPdie0n7mBQ9zquCpL5zL
         kE906JTkT7idaJEC2qPy99BmXRp4hJvJBkIJIaWZ+1m8JJ7qTBMw6LB6EAeDvUmI4Yr5
         KoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56U3L/n2SWLavdhRRg0Yc0+2596Qz1l4ZkRdkLejoUU=;
        b=yvg9UqIIUytbtPYI4T99zx3R0d0nheuuPa2EXwYTotYVRnuUyELmyv9gwfGqB5Ql5/
         JZK7xSOwIPtp02YT1Pb9Dyy8LfkLw9gcBIDMiOct0g2EADkdSQ0GF3vK2bZYcUwa6jI/
         Mdsq0g/vhFcMbAY8FiylZJJykx7F/ND1T4sj5G5aoPBYBWICW/GIBn9wZZ6vn3xkS8yB
         qS4uKBP3Lhn2vmsvTjFx5qMjG4QBmlqbjAESQKn+nNHKmXBMEfXHBFCkX3XjJK9BkeU3
         AUW9iH5cbR7nIsJTwiKqMdf7jhdty2ZdTn05iUZjPGJqlD+jysr/2IFV9rXsQyF25bhY
         tmuQ==
X-Gm-Message-State: AFqh2kr/RXDPFm+ZAvyLsNA692mtkrd+3lhAvSQhwwQJ5eQzWloOlElz
        rYqtuLepbJLhm+s07bbQD619fcI0i5mtA9KG5Q==
X-Google-Smtp-Source: AMrXdXuPGUqAq/gA4NvozqeSwhn313z9hsk0takCEbXTYxO29I/cls4kzRsujk3GtUKYbVvzE0Io7hI2+QgjSU9lx+Q=
X-Received: by 2002:a05:6a00:1d95:b0:57e:1a5b:d40 with SMTP id
 z21-20020a056a001d9500b0057e1a5b0d40mr3728240pfw.23.1672990276328; Thu, 05
 Jan 2023 23:31:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:586:b0:3a0:4e21:32f3 with HTTP; Thu, 5 Jan 2023
 23:31:15 -0800 (PST)
Reply-To: westernuniont27@gmail.com
From:   Western Union Togo <yatche512@gmail.com>
Date:   Fri, 6 Jan 2023 07:31:15 +0000
Message-ID: <CALrTvTod0pZ28OGsS0=wgrEWApwA47ZKYROhS2LEwT1iZdMVNA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Your overdue fund payment has been approved for payment via Western Union
Money Transfer. Get back to us now for your payment. Note, your Transaction
Code is: TG104110KY.
