Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2511598AE0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344908AbiHRSJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiHRSJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:09:40 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527B852FD1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:09:39 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id kb8so4702312ejc.4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=e9p+6Pd5YLN7OC4nekt1avikAsuPnOrhnFoiNOeQF1s=;
        b=T3gSHEZtBWEx4nlDYgw8G9bXS/GRsb385vfLi2/B6789vBRjgC6YLadDhn9hGwz7Bx
         SzrAL8sS37k/c697SpdKKV/MyLR6lSBgOXSbIFd++DSu16M1CcM0T9TmVVKXFN5YXhsc
         HE355R1+pZ1sY7ikjqfYfar22fCSdc3XW/LMGXNjRXbmUSLw86YM2OpW6Tywj5c6RXHh
         rUWQcqoo+oUEzx/yHi4QgZW9+oe7kkEWs7mDmxoPme8DA2VBGncxiklMxhKjK+QiXo1M
         Fw2PeWXBmioqIfFupPnfFYNu9GBVlGrbVjSo6Y31eMhtpxJNcniR0mODAPo8mdUvYRM5
         5XTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=e9p+6Pd5YLN7OC4nekt1avikAsuPnOrhnFoiNOeQF1s=;
        b=cPXK1oBAyp/zQWgELxNkBiwqxBqjQvr3WRHyi3LTKWHo9U3wkdozFacm3U0BYQKhr5
         FMaRy+n1G8DedGTudPSVRjDSdkK9QKpixo6DQTjQLv2Pf2LhQbO/kQzW+FK3Gic0N7OY
         Aixd2uf3W7GjJmvZBMO79vMOL/0RQDEQJQYZ+eJu1B0DmzPlhd9PlTgXe0v9PCiYyujO
         4gvqeMSECA9FLH5zllLO+mA3N2FZzHBFG5fZbZynJ9LvB02jtHsTzkgefQXhDcSKy/mB
         ejrIoOIfy2pkOegIcbiM7esD9I5cDt/CdhJRxue5qDW7jyMmGFS1rCt/XFxyYbrIwm6D
         4xeA==
X-Gm-Message-State: ACgBeo2JeQ24e+pDIMgMGMxILXbhT8UtjcTeWzX1jW9fbad1RQ1uR7H/
        4osemkppKqwLnXtcmmU6rvNEyI+0am8+NP38TNA=
X-Google-Smtp-Source: AA6agR7bqs9oWbRYROjUAJl3Kt76U7xIEuqxIhBUZrOMXc0aUWAv+q8BV+QXszEt77NldYYI1bon/Ezu3ZhvvbGklGA=
X-Received: by 2002:a17:907:8317:b0:731:2189:7f4d with SMTP id
 mq23-20020a170907831700b0073121897f4dmr2551849ejc.468.1660846177419; Thu, 18
 Aug 2022 11:09:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:4748:0:0:0:0:0 with HTTP; Thu, 18 Aug 2022 11:09:36
 -0700 (PDT)
Reply-To: nikkifenton79@gmail.com
From:   Nikki Fenton <marksfred222@gmail.com>
Date:   Thu, 18 Aug 2022 20:09:36 +0200
Message-ID: <CADLnxhosdXcQ0u-_NL2RtHk2Wq+D=d12mvw+RTbcXJyLBWxpdg@mail.gmail.com>
Subject: Please Read
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:642 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [marksfred222[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [marksfred222[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [nikkifenton79[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I've viewed your profile on Linkedin regarding a proposal that has
something in common with you, kindly reply for more details on my
private email: nikkifenton79@gmail.com

Thanks,
Nikki Fenton,
nikkifenton79@gmail.com
