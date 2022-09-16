Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DBA5BAF1B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiIPOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiIPOSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:18:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AEC923C9
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:18:42 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id cc5so26423056wrb.6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=XV3slIZ87yRUbCAc8CGl2al65c1iLbMw9wYykT7rlqbSyL3bYJRIYaCZexkWgMqrvB
         9cRc8lli/M8W3UlVqUEZ4noMQkF8GlVr9teBBn8qZYhfT1QNRBs/gR3Qt3V/SXXepFft
         /NkLc/2zDgaAqSgEgJKqvoYaOyfSEZs0zfbuNTHYPrOdR6ADBIRUjlDfKtvnEvDOKQXK
         ei/wjXwDpP5blmLDIuc7eCqbnOffIN7kGsRqmwpohxxDuJwAwfiqH814C9hgQS1RzXl2
         fy05AHuwq7TCyYIhShoUn9vJ6j6Vroe7Wxeg75xnKtIinnPsTn1z0wRF0wdb5quefxKr
         BRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=V4RXlBwsBzaQrJa6geTm1bciq3hnClAjHY2Ho8OIg399jq+D1TUuzFfxiQrUJh07ll
         1UaQbJ14zGoMXQ7+nWBwtOUF2yiY+sG8ksea9D2eQV7iE07X88vH9KV+H5Npu7QX4YKP
         l/pesAEF8d8q8YDc49ea7ryxRfkK9xLPsGJR7AIL9wrh861GV1cvDpX+zqahj1IdrH3c
         EnzeZ2ssit6o0tkWSWAnEz2XtPQbFBiyw3pN3L+IsctEsWo673VXwpjNm5oSMb2S+FeF
         BRIM/7w+1AP0snrTeHRmNv0mWsbVstWKZBiiH96DcTWX8pErtWuEsYu10eYPtkIg5lrj
         3x9A==
X-Gm-Message-State: ACrzQf2tOImTY3rTw4lPew8LWArgGwQ4+1QW9vZzAq6hXYISROVRU3Hq
        yaLM1mSnzUbQ+bCwpMVnZ8icjyeIsmnpZOZSgjXGqTKu
X-Google-Smtp-Source: AMsMyM6LGJpJtEn5YKfeDjbpKMxAcsMCiXjnwWlZoJ6LQ4yicHm73MFlR6Ba6ahUqKwAuU10WHF1XXrD6AX5m5j9hdU=
X-Received: by 2002:a5d:584d:0:b0:22a:4713:2e23 with SMTP id
 i13-20020a5d584d000000b0022a47132e23mr3117197wrf.57.1663337920566; Fri, 16
 Sep 2022 07:18:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4804:0:0:0:0:0 with HTTP; Fri, 16 Sep 2022 07:18:39
 -0700 (PDT)
Reply-To: maryalbertt00045@gmail.com
From:   Mary Albert <edithbrown072@gmail.com>
Date:   Fri, 16 Sep 2022 15:18:39 +0100
Message-ID: <CADV9g=utM1E=7RD0DLxO7YmpE_-xiMN-nUuwuON4mjmdbTkjTA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:443 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4992]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [edithbrown072[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbertt00045[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [edithbrown072[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
how are you?
