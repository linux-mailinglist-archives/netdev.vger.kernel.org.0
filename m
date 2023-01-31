Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D88682BB2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjAaLnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjAaLnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:43:12 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C5A259
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:43:04 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lu11so3417713ejb.3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xyPjlnYpCPxGsCquvTFi5VDTIk6JDJjiRwkGCbPL5r8=;
        b=oq1A3H0gnWc2MPatjj1BnJMrWoBkm25+DID/+4M1HFmSB10UY6YsLWIdC7y9JAH0eZ
         Uqa4q5Ze/i4/P1SQDSI14ChcsaA+NtNKqQ1ZzispIeJF7cH0QvF1BBklYxtlv8JJ9YqP
         6hdBMh0bMkN/ysAF5PHbUYR1lfpJEgaG6uLRqz7S59rWn6rkd9iO2wPeURlVwKGZSfKh
         0AWKPt7WSt1gWPropkIffu/CTiVfZNudD58tSSlajRA+rUIZkUVFApG1GpfFkIpRA396
         SPL66Yc4QQuSV3O0mbhNNnBbiytaunaINx62jMZ/6VHukbVjdloo4kVbNNp1NUfO5Z8B
         ZBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xyPjlnYpCPxGsCquvTFi5VDTIk6JDJjiRwkGCbPL5r8=;
        b=iHnTfn5bPt5YDcdeANvXgnrx7hruOu94Ur/wMYVSWNqr0ld67mODiN9nwgv7aJIRao
         xF3EoX7t+nZ2X0lB8MufR0uY4PdxVcpSbwUfhAxDgu50YWZlSUr80v1wnzoX0CFYAfRg
         fQMa0Cbjm2Lid6qPnqVFv+sqvtv3K2sAlKKO1AlPAktRh1qLPn/a0CWbGgc3Cmee3LQ2
         aS75/U2iF0ifxqWCcLUwT00BmUfvD3BW4XKGx7OVOVuUg3Kq8zZP6cPxc0w63b/w9l7b
         uqpY1+6CboYIFhtCDdbwL4mRsv/OCx1JY4RJM/XiO/2cp+ZRl2AZW5FqnEYaDO1sR7gg
         YIEg==
X-Gm-Message-State: AO0yUKWDSeM9YTOiWjHkRlR5oIQajoy8+JbeS5oyKv6H+ceejsvnIa5t
        U8FSLjO7GVMbtk98ExXLgJXvc1AbUnIXfSkyTu0=
X-Google-Smtp-Source: AK7set+4aX/K8QGI3mUGCu6vOOofqBAFhsilapzLv/fG0dBt54NzAq/2ifVkYamXT0ybUPt8nXVoazYFChd6Y5vV/j0=
X-Received: by 2002:a17:907:2cea:b0:88b:93c0:34f2 with SMTP id
 hz10-20020a1709072cea00b0088b93c034f2mr1034826ejc.296.1675165382446; Tue, 31
 Jan 2023 03:43:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:8e8d:b0:86f:161b:184e with HTTP; Tue, 31 Jan 2023
 03:43:01 -0800 (PST)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <luben8213@gmail.com>
Date:   Tue, 31 Jan 2023 03:43:01 -0800
Message-ID: <CANyAdH_D=o2iO_iAvwjk3e2c186yP+qRqxa_SJrERBYaHUNWJw@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6172]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lilywilliam989[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [luben8213[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [luben8213[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

How are you doing? I hope everything is fine and OK with you.

My name is Lily William, I am an American presently living in the UK,
as it is my great pleasure to contact you in communication with you
starting from today, I was just going through the Internet search when
I found your email address, I want to make a new and special friend,
so I decided to contact you to see how we can make it work if we can.
Please I hope you will have the desire with me so that we can get to
know each other better and see what happens in future.

I will be happy to see your reply for us to get to know each other
better and give you my pictures and details about me.

Yours
Lily
