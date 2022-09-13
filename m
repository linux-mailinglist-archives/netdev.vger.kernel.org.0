Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3AF5B6B83
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiIMKUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiIMKUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:20:49 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047F756BB7
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:20:48 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id e1so114175uaa.1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=oFPao6+FHTUKOYc11RmLF8YTaUlvFn2TAMXlqT2wmEQ=;
        b=WhsN42FS4i6EfAqH3OahtsyH68bc7obC623uOE8DFUexKmksEbpz8tSegdbDrnWzNJ
         9f7AQ2hdFQU0afEOLhSMXZrZjuScZruVLZF/MlLkDV4q1v7JaunqkW91sUhMWoq//dAi
         12cTgUmY8MHemf5Ih9bSzw3MOT5RvClqkDjEHq8aO4n/IP4/ppDAGk1qwQxHgnF4ug9h
         ICQ5d/iddD4s7oogwPc1HUOXD+ucOHK0LriOMzq1d4QpS9nPfC+HoyQ8LzyHFak4UZjH
         uo5AFhAxtZ5p/qmUOAaLSkhxb2sgKYlctyNUWx3gy4uBiYnuMAFEfWFfRRXcgwyWnMgB
         TDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oFPao6+FHTUKOYc11RmLF8YTaUlvFn2TAMXlqT2wmEQ=;
        b=wU1F21spHcBZudxrgCQlzX9lepQ9GhCWEz/HJofITcXGWri3qj+m13yYEpMRj8ueYC
         j3aGyQyqj8g4F9d6J6UpD5w9biWAJKO00BZHvl+FCh/1DejD8ANd0wFg99l2hXQ5f67+
         BFyewnoxLh7GM39nZpvqp5WztXzNkCC5ZaZHywk5Fqm86W2EMgEzuEzj5iQ4NdGcax2J
         d7hcK48SFJjiKyyCSZvRas4yJGqRw4cO0pFt0AVzcXy/jr0cg8e4OPKRCGAZb2lTURDt
         +a5K3dWEGhQdEMrFNi+E3pSmasBZIXqBuO1zC5OTYKdZiV8yfOXAiJrMpXPKh1D42qDo
         xG8A==
X-Gm-Message-State: ACgBeo37PayHUjLCN1TYOmpf3GJjZWjIs8s3pwFFy0sFlgRUSKDvJyrg
        LKgHOJdnIQGmko4FIMFqD3uilUqY/5bJ5C+/5Wg=
X-Google-Smtp-Source: AA6agR4/2AaohCCwZf0vOa0A8tanlFaQk1j6bLK2/RJuTXeVJxOuFpElc1cMFXK6fQsDZjhMtqCYe6KB4Ld6+0JCOd0=
X-Received: by 2002:ab0:2784:0:b0:3b6:5d2b:9a37 with SMTP id
 t4-20020ab02784000000b003b65d2b9a37mr5344026uap.22.1663064446908; Tue, 13 Sep
 2022 03:20:46 -0700 (PDT)
MIME-Version: 1.0
Sender: guillezakalik@gmail.com
Received: by 2002:a59:c6d0:0:b0:2ee:ca22:4742 with HTTP; Tue, 13 Sep 2022
 03:20:46 -0700 (PDT)
From:   Ibrahim idewu <ibrahimidewu4@gmail.com>
Date:   Tue, 13 Sep 2022 11:20:46 +0100
X-Google-Sender-Auth: mYwcOiYmzXKwFSVttb7tWzMFAyc
Message-ID: <CAER-mvRbadN8s7Gq1-Rww+yZn1=rFfO2ghb0ObaPhYnJPRCVJA@mail.gmail.com>
Subject: GREETINGS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FORM,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear,
                       Can you trust a financial relationship that is
mutually beneficial to us both? I have received your name and contact
information from your country's banking data Information, hoping that
you are interested in what I am going to tell you.

I'm Mr. Ibrahim idewu from Ouagadougou, here in Burkina Faso. I work
for coris bank international. I am writing to you about a business
proposal that will be of great benefit to both of us. In my
department, as a banker, I discovered $19,300,000 in the account of
one of our deceased foreign clients.
The choice to contact you depends on the sensitivity of the
transaction and the confidentiality it contains. Now our bank has been
waiting for one of the family members to file the application, but
nobody has done so. Personally, I have not found family members for a
long time. I ask for permission to present you as the next of kin /
beneficiary of the deceased, so the proceeds of this account are worth
$19,300,000 to you.

This is paid or shared in these percentages, 60% for me and 40% for
you. I have secured legal documents that can be used to substantiate
this claim. The only thing I have to do is put your names in the
documents and legalize them here in court to prove you as the rightful
beneficiary. All I need now is your honest cooperation,
confidentiality and your trust, so that we can complete this
transaction. I guarantee that this transaction is 100% risk-free, as
the transfer is subject to international banking law

Please give me this as we have 5 days to work through this. This is very urgent.

1. Full Name:
2. Your direct mobile number:
3. Your contact address:
4. Your job:
5. Your nationality:
6. Your gender / age:

Please confirm your message and interest to provide further
information. Please do get back to me on time.

Best regards
Mr. Ibrahim idewu
