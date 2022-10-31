Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77F613344
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJaKJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiJaKJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:09:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FE96386
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:09:25 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id f5so6556169ejc.5
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FpM8EZDReFBr6EJQ5XY8As4zcOaiqCsdiiu1hEdYzEY=;
        b=EUm4mhxZCroEzPHyhMBLflyCVW5QRkyfOvp2Wt9sREnsoM7ZSSv/1lpnJD9KCEATkp
         CndKFabvTyl4G4AkIFTQvFvQfPjKSV1/KAbr1JAJiIPz8DoLFmmgiYL5y3cK8z3KAAE5
         t9VLJl2vFoxDp3ufc9RXhpNOCOtvGXfA7Yko3G/qDhLqCokALg1xigBdW3eXeVrFYYwU
         K6StZfDqEMDrhKFm+ALrxUZ9reGTicmVCMBPlM5T9I1p6ar2LvbQ8X6r4+b4ZjL5dK+H
         O1OYiAv1/P88iwsWdD6Nei+9bLZF6KntxAEpqMRaa9qyylJ9jUGaqAsM6CNBJSznABwp
         MGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FpM8EZDReFBr6EJQ5XY8As4zcOaiqCsdiiu1hEdYzEY=;
        b=jGazcKZtXVLuq0t1KDHlIXL530cHUL6MvcvxW7NiRBJexfDXNI5qGlphhHhspkZ/z5
         cl5uSQxXShLmy29d+yZSbwyYVpLrpRY5PYkFP5BrADgUqL4lk88dPpmuB69gfU4gyKVA
         Ct6U1ODhI6q7YOPkZ9hTbJTJBGc6LmfAAHY0oTOe2Urg5BeDPRAkw9CW+Cy1aLveuLUJ
         W28i83J48REtCwuPWt0FQFFzk/xiiKEUIl3Y0+FZ/u+zDR/bOi0xKUsNr4wyAqNJd0Fh
         irWSeXYHOf/8h5x+qo/69lmdyTJjVO+O5hjpdWYrSSk4wwj8fTYJMQr6eIYQc4l7oNzx
         UW7A==
X-Gm-Message-State: ACrzQf3ggA+Gd+hfXhE04JDrHF9P3AxA2nWife5s5lE2MBFkbOTd+tf5
        WKXzFtrJcBN82uoPPwK1YaxALtxdxEdCLM7+eO4=
X-Google-Smtp-Source: AMsMyM6vU8feft2jB74auD7k+yGrxikK8kKIzcMlGayP4UYKh53E9ptFqNoc7fZUUDe9xmR0j/tRAY9aN/G10THgm4c=
X-Received: by 2002:a17:907:75c1:b0:79b:f804:c081 with SMTP id
 jl1-20020a17090775c100b0079bf804c081mr12149652ejc.381.1667210963404; Mon, 31
 Oct 2022 03:09:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:3141:b0:5b:56cb:6449 with HTTP; Mon, 31 Oct 2022
 03:09:22 -0700 (PDT)
Reply-To: bankinstrument793@gmail.com
From:   Stanley Ikenna <stanleyikenna213@gmail.com>
Date:   Mon, 31 Oct 2022 02:09:22 -0800
Message-ID: <CAAVTjW4QQMtjHpEe9kWhDoiv03UzhxppKTjwJ6W6QSc0LSh2QQ@mail.gmail.com>
Subject: BANK INSTRUMENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:633 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5393]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [stanleyikenna213[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [bankinstrument793[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [stanleyikenna213[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Lease and Sale of Financial Instrument (Bank Guarantee (BG) And
Standby Letter of Credit (SBLC) from AAA rated banks.

Get back for more details.

bankinstrument793@gmail.com
