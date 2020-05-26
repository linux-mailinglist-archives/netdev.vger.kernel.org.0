Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6E21E21B2
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgEZMQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 08:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgEZMQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 08:16:37 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36558C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 05:16:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so7726140ioe.2
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 05:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=Xs1c6/A8GmpgdbMBrIroEWmoFbf3qfcFFbhS2ULR81Q=;
        b=YshZgWTHdKaAQ+WWAU9rOaMBWCZ2A0mkNijpD0IS8YvAbYKOWvZEXVTC4iUiU5OW5u
         NU4RZ4YUVirutAwKiLPih5om/a/uYy2Jn2OtHdQBThocVY4V9BIR4XOemmG9lq34rURT
         iX0PuiHS33A+rCw8HsYWe0cRTgrpmb3PMVhyKSQR8c3CMiUADUOq1XlHEAAf4+9aMleN
         rmid1LWGgm14uASEwc0HXglc6mYMufaqWpAsh6fdW2CRPkzMi9C6opj94NBkZcyVmmwz
         S90X9Y0oE39bJpdkCuGdeS3Ug2o8fqOyrS418h8Aqja79fK47PNm88P6c4aS1bZ/90EA
         cg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=Xs1c6/A8GmpgdbMBrIroEWmoFbf3qfcFFbhS2ULR81Q=;
        b=mX6SW4F+IWMPnuBLv2+kqApQkDmsONyCFM8UxY7wsYM+7sB/hlJeMGQngT3gW3X0ij
         TVf5LG7eYQLj/SatBrIa/MhbZXxqUOhcDqHmaghDycOSITitNYW5+OZtVgNGCM0T5lHq
         x97yFGqE2t8FVkNFdRzlzNrKuqjl9jlF2+UOtKg7VSmeBoVxGqiiRSoBBQY8syxPBsb0
         hGAIAPcKz0ZnYkW7QPXtIdhYv+ljlvBq2WWHxnRYZr+z+KnER4S7jZ46JSM8l841htS+
         c2yJNtzCDlnYW7PSgKNq9SRIZS+b4sE2r+GYPWubkNkaXnYENY81K+tdnZ8SBC/FLvHX
         XCIw==
X-Gm-Message-State: AOAM531UFhBmEVDnIccYj77N5mza8V1Ew7kz0relOTrmPb7+SXHR03CG
        xC/9vVfvq35RAAOmRrkBoHEMxOOiO+FE+cleOvQ=
X-Google-Smtp-Source: ABdhPJzZjKO4nJr4n91jRPiNlouvTflVHyO6sU4ltwNaykHjseLGUuDAPkbUq3K/Ctzx7iaIjrCpnRWrazIthj3FmpI=
X-Received: by 2002:a5e:d910:: with SMTP id n16mr16786525iop.131.1590495396453;
 Tue, 26 May 2020 05:16:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrahmedmuzashah@gmail.com
Received: by 2002:a6b:6319:0:0:0:0:0 with HTTP; Tue, 26 May 2020 05:16:35
 -0700 (PDT)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Date:   Tue, 26 May 2020 13:16:35 +0100
X-Google-Sender-Auth: 4_BZ9c6DCUBh3Tb968lCefBAL8Y
Message-ID: <CAO1QnqEqMG=xc1s_Qivkc=RzStbGsnZ1a=GpQNXrkfJHfg_LJQ@mail.gmail.com>
Subject: From: Mr.Ahmed Muzashah
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

Please accept my apologies for writing you a surprise letter.I am Mr.
Ahmed Muzashah, account Manager with an investment bank here in
Burkina Faso.I have a very important business I want to discuss with
you.There is a draft account opened in my firm by a long-time client
of our bank.I have the opportunity of transferring the left over fund
(15.8 Million UsDollars)Fiftheen Million Eight Hundred Thousand United
States of American Dollars of one of my Bank clients who died at the
collapsing of the world trade center at the United States on September
11th 2001.

I want to invest this funds and introduce you to our bank for this
deal.All I require is your honest co-operation and I guarantee you
that this will be executed under a legitimate arrangement that will
protect us from any breach of the law.I agree that 40% of this money
will be for you as my foreign partner,50% for me while 10% is for
establishing of foundation for the less privilleges in your country.If
you are really interested in my proposal further details of the
Transfer will be forwarded unto you as soon as I receive your
willingness mail for a successful transfer.

Yours Sincerely,
Mr.Ahmed Muzashah,
