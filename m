Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E142571313
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 09:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiGLH1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 03:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiGLH1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 03:27:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D18080533
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:27:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so7110077pjl.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=a3kYebXLmQqNmOgkXVEM6oyVn061/ieKKJxue3okNp9JOo/W6UDwLD3voUXF/jT8rg
         8Akz50Nv4PdlD5+Mje6HHcQte25G8IwFrM/d4noasmUEqTKALm7RlUL1Mm8WP+jfZ466
         VZodrXp2lOFYDwq5mI6AY8/uayYxDJtq8XAWR96YzLpvX+1+0Mwhc+cVgkeCEOPo/ft7
         I6UcA5uoVqh46msaYPhzKdwG3N7XsjcbA3IUXe3e6FjExYatCP3AUF57DoSQ2hy7ZnD9
         48qo3/kKFyMAKlVZ9jwII2UTB4vrmgpApSC/iSsB7Dl87GQU1lu9/hWvZR7iI0JMSlKM
         PgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=7JCSqp5VzQKTBebSxYoRKnVj6F2ZtpoHZFiDFa3rmO2Gpptkn9HCeC1CoDSvvX4f9V
         /fbJK1OKfH6JvcJ7Cnj0YBKnfs2Osmc4tp+lCQ8gWSsj+Jyiut8kakKSDmR8AOds0hpy
         BZCDkkvHTrcJUahJ1PyGIWKdgtFDvc69kl7M7DpM88mHMcERkJ4Vc86i+xU3gEjuYJ6t
         NXdzfoVP72mkIUoOsKHsSokYq0fFfJcaSGlTn9ZQofcROQRmfdLLkq+/b2b+fbPwvFoh
         RXErHIjbEfZwBEIi7EzLI3quJaqAMOWLUGzadNgJHTN6jYS4KQs4T5NM6QzGSI/9oZBU
         /OvA==
X-Gm-Message-State: AJIora/NDV5wJzNs4wO/Ro225z/QmpRGMQZ2dRuU8OpHMkvqCmMmHyY/
        r2iegGciAQKecep1VHB9QcJCaOSV2R2PrPt0734=
X-Google-Smtp-Source: AGRyM1vI42rPkWqE9uEhdxqIs1qK03UZmx0IOYfI/y1pysesvPtg9zytEzktZd8ummbbHgxhe5+HCUfMif6IuKUGR6I=
X-Received: by 2002:a17:902:f7c1:b0:16b:de8e:dca6 with SMTP id
 h1-20020a170902f7c100b0016bde8edca6mr22118422plw.99.1657610837703; Tue, 12
 Jul 2022 00:27:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:540d:b0:60:d22b:60f6 with HTTP; Tue, 12 Jul 2022
 00:27:17 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <gracebanneth449@gmail.com>
Date:   Tue, 12 Jul 2022 00:27:17 -0700
Message-ID: <CAOsUanwT4JN_ONhUJ-X-ELKE3YP_vOaX_+34mRj3FFNcYmQYYQ@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1030 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gracebanneth449[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gracebanneth449[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
