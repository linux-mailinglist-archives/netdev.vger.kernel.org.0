Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249705FBEA4
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 02:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiJLAXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 20:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLAXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 20:23:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FB2915FE
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 17:23:06 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ot12so34823531ejb.1
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 17:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7nMl+IIoVXIZCC/DKHT3CXI2Xf2HP4geGz0+dJZi9s=;
        b=PrCF2L7rMlZ7n1YbceNdQzGr4MLDY8xHUdv+IXGsdqMkMHtyclSKWyyWGx9dqJ2+yX
         NQOAPbGJDvjMNLWuBgPxQMVXumKOo1bcv7iccN1soo4ObI6vcRFAx78l86qiAun+2BYi
         Gff48U+LNohqT8oXFd9ydx4/Gdvy8lTsLEspxzn6VEMv8hOWtOl/jlmvpBrhk0V0NRKu
         DijHKvLuF1R09zmKTlPpYxF7sRwJKiDlibK1U4UAKGqnvWTPpwy6PeimAbJ7GacsNrXs
         tvmjkMdwrIOto7P52ZsdqIKes8MGrvD83l+BRxsY/EA2T6OKn/CleLSOVX5F8Os1eMFP
         pRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7nMl+IIoVXIZCC/DKHT3CXI2Xf2HP4geGz0+dJZi9s=;
        b=qVIfFVs50LUGZ6SKftj9bvgXeELkbO5TExjAsjYZeee59sJopIt5LoECQJJ9RYVEyf
         6gnjePx78U7md0VDSK+SrADzgvniQy1BiLBwfh4cajcTIgjsJIoTaOHlT3t+39S81RKa
         9r8jwPhcHFKx6F+jcFG0TrEg4LFoRnbkoE1dxYiWlOWF15HF7eoX9XOVJn3f7W0q4Ydj
         HiLmj5gDzlYQn87X2XABJo4WrQC0eLZ1F4laKyzUXS31r7ByPUCZJJ0Rovx3e9Egypsn
         P7CaZfahWYJWoI4e7BtFBEOcRQdstDJHdZ3Zi0Hv54guVk8AmDp550zA+jOGoNjBNcY3
         DvIg==
X-Gm-Message-State: ACrzQf38bSEGyyL65cEKo2agw8Tea7J8Lzhl7b3F2jnV6GiFw95XlKDA
        +21mnZZAoS4BjnzpwkTz8XMQsVo+Zmau5lyUwOc=
X-Google-Smtp-Source: AMsMyM7+Zje97PCT0guj+7MDh0T20QV0ovlBtB8e+PAJiVrjuxAYo2MMMnsPmYR9u97YdUkS+SuqMinkIdvdVGVS34g=
X-Received: by 2002:a17:906:fd8a:b0:75d:c79a:47c8 with SMTP id
 xa10-20020a170906fd8a00b0075dc79a47c8mr20247747ejb.389.1665534184725; Tue, 11
 Oct 2022 17:23:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:9688:0:0:0:0 with HTTP; Tue, 11 Oct 2022 17:23:04
 -0700 (PDT)
Reply-To: illuminatiinitiationcenter56@gmail.com
From:   Garry Lee <najjumasaphiner11@gmail.com>
Date:   Wed, 12 Oct 2022 03:23:04 +0300
Message-ID: <CAFXZRYFTJaAKrcRqGqfZjryUWL0VCsYK3HVr-jsodw8CAN1pbg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        UNDISC_FREEM,UPPERCASE_75_100 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [illuminatiinitiationcenter56[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [najjumasaphiner11[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [najjumasaphiner11[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 UPPERCASE_75_100 message body is 75-100% uppercase
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
DO YOU WANT TO BE RICH AND FAMOUS? JOIN THE GREAT ILLUMINATI ORDER OF
RICHES, POWER/FAME  NOW AND ACHIEVE ALL YOUR DREAMS? IF YES EMAIL US :
MAIL: illuminatiinitiationcenter56@gmail.com
YOUR FULL NAME:
PHONE NUMBER :
COUNTRY :
GENDER:
