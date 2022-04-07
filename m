Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E874F7A99
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbiDGI7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiDGI7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:59:37 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835EB8020D
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:57:37 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id g11so555065qke.1
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=RBvksbdV8NckaD7sEylhW5ieackYTFU8OlDyXlNx0To=;
        b=cxHNshbjNKY15YaO0UyhrlvFkInFxJseYmka1lmhFEtsvGUkzXjNYmfsAtHAJp/nU2
         bk9H6ivOLKSQSd73uXxr+3EXd2mgg89vXGOF+sUi1xZ8ic7Rsb9hAeghwrd6zVBX8fnq
         xpA2R8T/JoQdmHkvtvgK9ke2fWMoRnt++u+JTSJtP3gkt/ehE/R4vd92yYU0OVouoN+C
         /kx0gqSzKumEWscaFt1PntNpqnSD4YQSwSfwTC4Jsm8n6BXlsfOKeVLcqzhp1DuKzfop
         NL9lxwXgOwXewrMq52D//NISJ+nHGh54HzsLxmqMPDT48YEYq87xW3Hy21jyVfATBZPK
         329g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=RBvksbdV8NckaD7sEylhW5ieackYTFU8OlDyXlNx0To=;
        b=6EPpfSgZzUFh29xNJcZGFOpBkm8xA6gSHxGGRkdBy7NdWA3RakugsjdfZ1heomlZ4x
         uxZy4TEbuaUa7+0pK33lL/Oa435y1UC8V6yMKuC/xpkengsPil0yZkTOIV4vUwA9oiq8
         W98fDWqT5rmORlqyD40rWGCMy124bd8A9kw10NJF5dtUByCWHbARPxfIqjjbOSPIxAjj
         yPUJlCHjxVNdF7+oOxD03krK2c5xItUGhBJnTMheiq57fUPH6BJJHaVtwaEWiiXkfwCD
         q591ywaw3/Qmg9lucVgxjHOdwil1+9BEG53BGULeeCFqHtdurO+Tu0IAFdgGq0T+T8Ra
         Gz5g==
X-Gm-Message-State: AOAM5315R9ZRXPeZKsUgFQVmdkA7/fe6Ca+7sYFbeeNfpCJ75xWo4DuK
        XeimMyQE0Q6d18qzls20vMkclNFXYXiAANC0Y7Q=
X-Google-Smtp-Source: ABdhPJzc+Sm6j8qfgi5K3LmkJM6crGcEPYL3LuCKdOXRqNOs7EMTovI6cWb+d9SrtISeGvLbEvznaa8xqJP+xF0cwFE=
X-Received: by 2002:ae9:ed03:0:b0:67e:9830:93d7 with SMTP id
 c3-20020ae9ed03000000b0067e983093d7mr8220735qkg.527.1649321856586; Thu, 07
 Apr 2022 01:57:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:1c4a:0:0:0:0 with HTTP; Thu, 7 Apr 2022 01:57:36
 -0700 (PDT)
Reply-To: alexnorman439@gmail.com
From:   Alex Norman <edwardperry057@gmail.com>
Date:   Thu, 7 Apr 2022 10:57:36 +0200
Message-ID: <CAG7zNZJ7KZCTo_9Tjd=XgWbBchnnZVsRWKOku8MyiCzb3js0-w@mail.gmail.com>
Subject: Reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:735 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [alexnorman439[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [edwardperry057[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [edwardperry057[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re:Investment Partnership,

My name is Alex Norman.I came across your contact.I have an investment
proposal that i want to share with you of my client desire to invest
in your country.

Your prompt response will be appreciated for more details.

Sincerely,

Alex Norman
