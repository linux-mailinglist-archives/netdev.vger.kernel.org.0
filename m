Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7006B5B9F07
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiIOPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiIOPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:38:21 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3954181691
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:38:19 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id m130so2686177oif.6
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=WS4wMSByWryX8P5xXNg6/F9cuXaZcQ/JDEQQ6/oYhcI=;
        b=QequX5ix/DkywyzJU1nozIw8j4a6et8DVLGXjD7ZNg8Z+oH9zLnzmK9RNbkjzJOgFk
         sBqZaRFWJ3HGLklbG1xTbZjB1bTs9zaVb1B6PFvFVbbM7NMjtkfWqQYSxZTomfNdl1jo
         YxptK5CChlHgv4WhxK65Nao2aOcV3blAq5IArWGHcrm3HllG8RJx/BhacNXEvGHBtHXc
         G7uhOR/MjG+oAjTbjLoEIND5MXelSXxIXSZoPcbOB9HmA4JZZpAGjU44a5QfCMkLQsJz
         BiD4CleBU1FAo25hQ1cRVsB4N0ATH4D151EbGgpg4yaCEJNj1FYgC7mA3h7KXZlJvRxd
         /7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WS4wMSByWryX8P5xXNg6/F9cuXaZcQ/JDEQQ6/oYhcI=;
        b=oZknhGeBQrmed5k3VPDowwLYjrSTg3sFnZtgYyliUN0uVVSJVievltpkK/7owmu+x/
         v9ldwilBLbU6HVHWJnMpXUA3UYgOaHyo1g/pq7aNv72ifnImgH4Qm5uqDr0iPqyoIK2r
         cdngU/NevItBJ4p1deBDO6thGqaXcOD/RRssX+KmP+6pr19ieVXCBeglgninVVQwHXAA
         Ktf6pnKQG5CulkEGYX6wtE7HM0J4JA2f6CGuVMcOJTog/DxRqa5MRMRDOl4Jon7x+IDD
         bykBOgs4A4pHIJQZWjWVgrfnKCD8a49YtH9oxyvB4s2/T6YaP26bh4IyfeZX1FQqITTP
         SYHA==
X-Gm-Message-State: ACrzQf3C4vKX6zwGRWdQIppX7JwHbU/o9v8uCMd+fvLRoUrNdGSk6jXN
        jmEfm9s3/qWK8tCkGAZ5M7PQ8zhx77bPTggJt74=
X-Google-Smtp-Source: AMsMyM5rmpVYVuvjdIov5HSLQFzpQhyPIsTfDkPLYp0Q+ZK9oJgN0WqbC6VoBC3qMrd8/cvKv7XPXQreM/DVm2i/+bw=
X-Received: by 2002:a05:6808:15aa:b0:34f:b7e3:26f5 with SMTP id
 t42-20020a05680815aa00b0034fb7e326f5mr244441oiw.22.1663256298438; Thu, 15 Sep
 2022 08:38:18 -0700 (PDT)
MIME-Version: 1.0
Sender: 1joypeters@gmail.com
Received: by 2002:a4a:e685:0:0:0:0:0 with HTTP; Thu, 15 Sep 2022 08:38:18
 -0700 (PDT)
From:   Aisha Gaddafi <aishagaddafi6604@gmail.com>
Date:   Thu, 15 Sep 2022 15:38:18 +0000
X-Google-Sender-Auth: UApVPhyziRw96WwX-ztBMn4yQwA
Message-ID: <CA+F+Mbaq+2GFREhw3DUYHMsbHye1Rnow6V1c3ek7ktSvDdNe2Q@mail.gmail.com>
Subject: Investment proposal,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_99,BAYES_999,
        DEAR_FRIEND,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,MILLION_USD,MONEY_FRAUD_5,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22f listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishagaddafi6604[at]gmail.com]
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend.,

With sincerity of purpose I wish to communicate with you seeking your
acceptance towards investing in your country under your Management as
my foreign investor/business partner I'm Mrs. Aisha Al-Gaddafi, the
only biological Daughter of the late Libyan President (Late Colonel
Muammar. Gaddafi) I'm a single Mother and a widow with three Children,
presently residing herein Oman the Southeastern coast of the Arabian
Peninsula in Western Asia. I have an investment funds worth Twenty
Seven Million Five Hundred Thousand United State Dollars (
$27.500.000.00) which I want to entrust on you for investment project
in your country as my investment Manager/Partner.

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds..

Best Regards
Mrs. Aisha Muammar. Al-Gaddafi..
