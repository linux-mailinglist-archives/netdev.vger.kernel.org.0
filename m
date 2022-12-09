Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F105648855
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiLISRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLISRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:17:06 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E649A84B8
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:17:05 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h10so6007516wrx.3
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 10:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GShbIMXKu8OYP4XCWUukszuAHI4X5ZuUgk/saGJ0GoY=;
        b=CIWFQhFGXCKYI5xqozANBAmFwq4jm0JyOF9/6P1Exruxcv5B8m+6HJnZkHVvHD42PW
         HSWOuZIoA/2Fp8Ll/Bw6ULX0KlHqwuji9dfNmLfaCKy2xbC+bOgcN0ViB6pOCO1xBkye
         uI/simJzTyRCsXnDX48hmTkHWPiwQ2Yjo2M8oBFx38cv949U1BiJo5UNuF8jbVOZZGKh
         uI4Ui7re4vA65g8sCsrptDagX73oArlD3nBrkSU5xtAi3EzonS7l/U7yAXGuf2637UKg
         SDD/dGu7GYoeDe/G9jt/dOlZAbf82GZcrdTpeIbIf93MX4U9rblqB+Apw6FrtXmeOMHc
         N8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GShbIMXKu8OYP4XCWUukszuAHI4X5ZuUgk/saGJ0GoY=;
        b=G3CRGEVzEn6oA2OaQEYm3mPCrl2dUb66OypZ+t4/J69lhJaxOF1LYBqYAnRuq0BEi0
         LoLm4KPtDff7jKQGVjg8+tci/o0X3IuG5We2hMAgVNQjCT+M4G7sdtXJYs4d0wlSt+5A
         wlmiB5WptDra/Z4xTkmI+jtXK1qx14GLfA+rhRAO2WvoHi34La70ZorGcTz5Ql552r65
         KQcAyuzIJhv6U72OeqsDSiYIiy7psvmcxQ06ciYn8PcMWhJT+ZDH1vxDRDUdECNcbfiO
         BWWdurb5QhDOCw8SNK53LRrB2JVvrQ7Yx360p+MCI/4xcyi2k/und7E0hnASQS4/5T4V
         T1ow==
X-Gm-Message-State: ANoB5pk75Y78wJxtHmMX/Dz5T2C/qd26G/ohycN9r7FpPTDfd11zl2yh
        5q0ADqrN5gm3hC8peYjKhcEmvsZxIJzndkax6w3L/epJLZk=
X-Google-Smtp-Source: AA0mqf4w5pPcI6RHt3SNb0dfl6SLuURpC2EDRtIxUPKm+0GCuyO/xBIgsFO6Nm/BYYop7Uaf1BQhMO+/XwFdiszAFGc=
X-Received: by 2002:adf:f94f:0:b0:241:f467:f885 with SMTP id
 q15-20020adff94f000000b00241f467f885mr42049380wrr.482.1670609823887; Fri, 09
 Dec 2022 10:17:03 -0800 (PST)
MIME-Version: 1.0
References: <20221209101318.2c1b1359@hermes.local>
In-Reply-To: <20221209101318.2c1b1359@hermes.local>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 9 Dec 2022 10:16:51 -0800
Message-ID: <CAA93jw56DJKuP+yVim4Hq8UJs9gMJgew_4czNNW+obL3WZ7puA@mail.gmail.com>
Subject: Re: iproute2 - one line mode should be deprecated?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm terribly old-fashioned myself and still use one-line mode, and the
kinds of scripts I use still use awk. I may be the last one standing
here...

On Fri, Dec 9, 2022 at 10:15 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> The one line output mode of iproute2 commands was invented before I was i=
nvolved.
> It looks like the only real usage is for scripts to consume the output of=
 commands.
> Now that JSON is supported, the one line mode is just lingering technical=
 debt.
>
> Does anyone still use oneline mode?
> Could it be removed in some future version of iproute?
>
> There are still output format bugs in oneline, and some missing bits
> of JSON support as well.



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
